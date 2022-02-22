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
        }

        const providerOptions = (() => {
            const opt = {};
            try {
                if (env.INFURA_ID) {
                    opt.walletconnect = {
                        package: Web3Bundle.WalletConnectProvider,
                        options: {
                            infuraId: env.INFURA_ID,
                        }
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


    async signMessage() {
        const walletProvider = await this.web3Modal.connect();
        const provider = new ethers.providers.Web3Provider(walletProvider);

        const [address] = await provider.listAccounts();
        if (!address) {
            throw new Error('Address not found.');
        }

        let ens, avatar;
        try {
            ens = await provider.lookupAddress(address);
            // avatar = await provider.getAvatar();
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
                    eth_account: address.toLowerCase(),
                    chain_id: chainId,
                }
            })
            .catch(popupAjaxError);

        const signature = await provider.send(
            'personal_sign',
            [ethers.utils.hexlify(ethers.utils.toUtf8Bytes(message)), address.toLowerCase()]
        );

        return [ens || address, message, signature, avatar];
    },

    async runSigningProcess() {
        return await this.signMessage();
    },
});

export default Web3Modal;