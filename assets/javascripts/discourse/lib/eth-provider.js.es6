import EmberObject from "@ember/object";
import discourseComputed from "discourse-common/utils/decorators";
import loadScript from "discourse/lib/load-script";
import { ajax } from "discourse/lib/ajax";
import { popupAjaxError } from "discourse/lib/ajax-error";

const EthProvider = EmberObject.extend({
  providerName: "",
  // override and adjust init logic
  async providerInit() {
    await this.loadScripts();
  },

  async loadScripts() {
    await loadScript("/plugins/discourse-siwe/javascripts/ethers-5.1.umd.min.js");
  },

  @discourseComputed
  providerObject() {

  },

  @discourseComputed
  provider() {
    return new ethers.providers.Web3Provider(this.providerObject);
  },

  async signMessage(message, account) {
    const signature = await this.provider.send(
      'personal_sign',
      [ ethers.utils.hexlify(ethers.utils.toUtf8Bytes(message)), account.toLowerCase() ]
    );

    return signature;
  },

  async getMessage(ethAccount) {
    return await ajax('/discourse-siwe/message', {
      data: {
        eth_account: ethAccount,
        chain_id: await this.provider.getNetwork().then(({ chainId }) => chainId)
      }
    })
    .catch(popupAjaxError);
  },

  async runSigningProcess() {
    const [ account ] = await this.provider.listAccounts();
    const { message } = await this.getMessage(account);
    const signature = await this.signMessage(message, account);
    
    return [account, message, signature];
  },
});

export default EthProvider;
