import EthProvider from "./eth-provider";
import discourseComputed from "discourse-common/utils/decorators";
import loadScript from "discourse/lib/load-script";

export default EthProvider.extend({
  providerName: "walletconnect",
  async loadScripts() {
    await this._super();
    await loadScript("/plugins/discourse-siwe/javascripts/walletconnect-provider.js");
    await loadScript("/plugins/discourse-siwe/javascripts/walletconnect-provider-global.js");
  },

  async providerInit() {
    await this._super();
    this.providerObject.enable();
  },

  @discourseComputed
  providerObject() {
    const provider = new WalletConnectProvider({
      infuraId: '8fcacee838e04f31b6ec145eb98879c8'
    });

    return provider;
  }
});
