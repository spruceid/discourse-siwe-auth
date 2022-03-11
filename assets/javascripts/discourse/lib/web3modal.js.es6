import EmberObject from "@ember/object";
import {
    ajax
} from "discourse/lib/ajax";
import {
    popupAjaxError
} from "discourse/lib/ajax-error";
import loadScript from "discourse/lib/load-script";


const Web3Modal = EmberObject.extend({
    web3Modal: null,

    async providerInit(env) {
        await this.loadScripts();
        const Web3Modal = window.Web3Modal.default;
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
                console.error(err);
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
            loadScript("/plugins/discourse-siwe/javascripts/ethers-5.5.4.umd.min.js"),
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
            avatar = await provider.getAvatar(ens);
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
                eth_account: address,
                chain_id: chainId,
            }
        })
            .catch(popupAjaxError);

        try {
            const signature = await provider.send(
                'personal_sign',
                [ethers.utils.hexlify(ethers.utils.toUtf8Bytes(message)), address]
            );
            return [ens || address, message, signature, avatar];

        } catch (e) {
            await this.web3Modal.clearCachedProvider();
            throw e;
        }
    },

    async runSigningProcess() {
        return await this.signMessage();
    },
});

export default Web3Modal;