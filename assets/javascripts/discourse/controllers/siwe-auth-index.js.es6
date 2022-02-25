import Controller from "@ember/controller";
import Web3Modal from "../lib/web3modal";

export default Controller.extend({
  init() {
    this._super(...arguments);
    this.initAuth();
  },

  verifySignature(account, message, signature, avatar) {
    document.getElementById("eth_account").value = account;
    document.getElementById("eth_message").value = message;
    document.getElementById("eth_signature").value = signature;
    document.getElementById("eth_avatar").value = avatar;
    document.getElementById("siwe-sign").submit();
  },
  async initAuth() {
    let provider = Web3Modal.create();
    await provider.providerInit();
    const [account, message, signature, avatar] = await provider.runSigningProcess();
    this.verifySignature(account, message, signature, avatar);
  },
  actions: {
    async initAuth() {
      let provider = Web3Modal.create();
      await provider.providerInit();
      const [account, message, signature, avatar] = await provider.runSigningProcess();
      this.verifySignature(account, message, signature, avatar);
    }
  }
});