import Controller from "@ember/controller";
import { ajax } from "discourse/lib/ajax";
import { popupAjaxError } from "discourse/lib/ajax-error";
import discourseComputed from "discourse-common/utils/decorators";
import { empty } from "@ember/object/computed";
import MetamaskProvider from "../lib/eth-provider-metamask";
import WalletconnectProvider from "../lib/eth-provider-walletconnect";
import { capitalize, camelize } from "@ember/string";

export default Controller.extend({
  init() {
    this._super(...arguments);
  },

  @discourseComputed
  providers() {
    return ["walletconnect", "metamask"];
  },

  @discourseComputed
  providerList() {
    return this.providers.map((provider) => {
      return {
        id: provider,
        label: I18n.t(`eth_providers.${provider}`) 
      }
    });
  },

  noProviderSelected: empty("selectedProvider"),

  verifySignature(account, message, signature) {
   document.getElementById("eth_account").value = account;
   document.getElementById("eth_message").value = message;
   document.getElementById("eth_signature").value = signature;
   document.getElementById("siwe-sign").submit();
  },

  actions: {
    async initAuth() {
      const selectedProvider = this.get("selectedProvider");
      let provider;
      switch(selectedProvider) {
        case "metamask":
          provider = MetamaskProvider.create();
          break;
        case "walletconnect":
          provider = WalletconnectProvider.create();
          break;
      }

      await provider.providerInit();
      const [ account, message, signature ] = await provider.runSigningProcess();
      this.verifySignature(account, message, signature);
    }
  }
});
