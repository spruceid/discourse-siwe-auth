import EthProvider from "./eth-provider";
import discourseComputed from "discourse-common/utils/decorators";
import loadScript from "discourse/lib/load-script";

export default EthProvider.extend({
  providerName: "metamask",
 
  @discourseComputed
  providerObject() {
    if(window.ethereum) {
      return window.ethereum;
    } else {
      bootbox.alert("Please install a Ethereum based browser extension to use this authentication method");
      throw new Error("Ethereum based browser extension not found");
    }
  }
});
