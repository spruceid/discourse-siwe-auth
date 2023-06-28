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
    ethereumClient: null,
    async providerInit(env) {
        await this.loadScripts();
        const Web3Modal = window.Web3Modal;
        const chains = [window.WagmiCore.mainnet, window.WagmiCore.polygon];
        const projectId = env.PROJECT_ID;
        const { publicClient } = window.WagmiCore.configureChains(chains, [window.Web3ModalEth.w3mProvider({ projectId })]);
        const wagmiConfig = window.WagmiCore.createConfig({
            autoConnect: true,
            connectors: window.Web3ModalEth.w3mConnectors({ projectId, version: 1, chains }),
            publicClient
        });
        const EthereumClient = window.Web3ModalEth.EthereumClient;
        const ethereumClient = new EthereumClient(wagmiConfig, chains);
        this.ethereumClient = ethereumClient;
        window.ethereumClient = ethereumClient;
        
        const modal = new Web3Modal({ projectId, themeVariables: { '--w3m-z-index': '99999' } }, ethereumClient);
        this.web3Modal = modal;
        return modal;
    },

    async loadScripts() {
        return Promise.all([
            loadScript("/plugins/discourse-siwe/javascripts/web3bundle.min.js"),
        ]);
    },


    async signMessage(account) {
        const address = account.address;
        let name, avatar;
        try {
            name = await this.ethereumClient.fetchEnsName({ address });
            if (name) {
                avatar = await this.ethereumClient.fetchEnsAvatar({ name });
            }
        } catch (error) {
            console.error(error);
        }

        const {
            message
        } = await ajax('/discourse-siwe/message', {
            data: {
                eth_account: address,
                chain_id: await account.connector.getChainId(),
            }
        })
            .catch(popupAjaxError);

        try {
            const signature = await (
                await account.connector.getWalletClient()
            ).signMessage({
                account: address,
                message: message,
            });
            return [name || address, message, signature, avatar];

        } catch (e) {
            throw e;
        }
    },
    
    async runSigningProcess(cb) {
        window.WagmiCore.watchAccount(async (account) => {
            if (account.isConnected && account.address) {
                this.connected = true;
                cb(await this.signMessage(account));
            }
        });

        this.web3Modal.openModal();
    },
});

export default Web3Modal;
