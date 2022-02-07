import Route from "@ember/routing/route";
import { ajax } from "discourse/lib/ajax";
import { popupAjaxError } from "discourse/lib/ajax-error";

export default Route.extend({
  model() {
    return ajax('/discourse-siwe/message')
      .catch(popupAjaxError);
  }
});
