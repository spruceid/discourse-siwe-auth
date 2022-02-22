import EmberObject from "@ember/object";
import loadScript from "discourse/lib/load-script";
import {
    ajax
} from "discourse/lib/ajax";
import {
    popupAjaxError
} from "discourse/lib/ajax-error";

const Web3Modal = EmberObject.extend({
    web3Modal: null,

    async providerInit() {
        await this.loadScripts();
        const Web3Modal = window.Web3Modal.default;

        const env = {
            INFURA_ID: '8fcacee838e04f31b6ec145eb98879c8',
            TORUS: '',
            PORTIS_ID: '',
            FORTMATIC_KEY: '',
            COINBASE: '',
        }

        const providerOptions = (() => {
            const opt = {};
            try {
                if (env.INFURA_ID) {
                    opt.walletconnect = {
                        package: Web3Bundle.WalletConnectProvider,
                        options: {
                            infuraId: env.INFURA_ID,
                            pollingInterval: 100000,
                        }
                    };
                }

                if (env.TORUS) {
                    opt.torus = {
                        package: Web3Bundle.Torus,
                    };
                }

                if (env.PORTIS_ID) {
                    opt.portis = {
                        package: Web3Bundle.Portis,
                        options: {
                            id: env.PORTIS_ID,
                        },
                    };
                }

                if (env.FORTMATIC_KEY) {
                    opt.fortmatic = {
                        package: Web3Bundle.Fortmatic,
                        options: {
                            key: env.FORTMATIC_KEY,
                        },
                    };
                }

                if (env.COINBASE && env.INFURA_ID) {
                    opt['custom-coinbase'] = {
                        display: {
                            logo: '/plugins/discourse-siwe-auth/images/siwe/coinbase.svg',
                            name: 'Coinbase',
                            description: 'Scan with WalletLink to connect',
                        },
                        options: {
                            appName: 'Sign-In with Ethereum',
                            networkUrl: `https://${env.network}.infura.io/v3/${env.INFURA_ID}`,
                            chainId: 1,
                            darkMode: false,
                        },
                        package: Web3Bundle.WalletLink,
                        connector: async (_, options) => {
                            const {
                                appName,
                                networkUrl,
                                chainId,
                                darkMode
                            } = options;
                            const walletLink = new Web3Bundle.WalletLink({
                                appName,
                                darkMode,
                            });
                            const provider = walletLink.makeWeb3Provider(networkUrl, chainId);
                            await provider.enable();
                            return provider;
                        },
                    };
                }
            } catch (err) {
                console.log(err);
            }
            return opt;
        })();

        this.web3Modal = new Web3Modal({
            network: env.network,
            cacheProvider: true,
            providerOptions,
        });
    },

    async loadScripts() {
        return Promise.all([
            loadScript("/plugins/discourse-siwe/javascripts/ethers-5.1.umd.min.js"),
            loadScript("/plugins/discourse-siwe/javascripts/web3bundle.min.js"),
            loadScript("/plugins/discourse-siwe/javascripts/web3modal.min.js"),
        ]);
    },


    async signMessage(message) {
        const walletProvider = await web3Modal.connect();
        const provider = new ethers.providers.Web3Provider(walletProvider);

        const [address] = await provider.listAccounts();
        if (!address) {
            throw new Error('Address not found.');
        }

        let ens, avatar;
        try {
            ens = await provider.lookupAddress(address);
            avatar = await provider.getAvatar();
        } catch (error) {
            console.error(error);
        }

        let {
            chainId
        } = await provider.getNetwork();

        const {
            message
        } = await ajax('/discourse-siwe/message', {
                data: {
                    eth_account: ethAccount,
                    chain_id: chainId,
                }
            })
            .catch(popupAjaxError);

        const signature = await provider.getSigner().signMessage(message);

        return [ens || address, message, signature, avatar];
    },

    async runSigningProcess() {
        return await this.signMessage(message, account);
    },
});

export default Web3Modal;