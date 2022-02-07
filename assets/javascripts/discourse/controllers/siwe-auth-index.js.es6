import Controller from "@ember/controller";
import { ajax } from "discourse/lib/ajax";
import { popupAjaxError } from "discourse/lib/ajax-error";

export default Controller.extend({
  init() {
    this._super(...arguments);
    if (window.ethereum) {
      this.verifySignature();
    } else {
      bootbox.alert("Please install a Ethereum based browser extension to use this authentication method");
    }
  },

  async verifySignature() {
    const [account, message, signature] = await this.runSigningProcess();

   
   document.getElementById("eth_account").value = account;
   document.getElementById("eth_message").value = message;
   document.getElementById("eth_signature").value = signature;
   document.getElementById("siwe-sign").submit();
  },

  async runSigningProcess() {
    const [ account ] = await this.initEthereum();
    const { message } = await this.getMessage(account);
    const signature = await this.signMessage(message, account);

    return [account, message, signature];
  },

  async initEthereum() {
    const accounts = await ethereum.request({ method: 'eth_requestAccounts' });
    return accounts;
  },

  async signMessage(message, account) {
    const signature = await ethereum.request({ method: 'personal_sign', params: [ message, account ] });
    return signature;
  },

  async getMessage(ethAccount) {
    return await ajax('/discourse-siwe/message', {
      data: {
        eth_account: ethAccount
      }
    })
    .catch(popupAjaxError);
  }
});
