import { ajax } from 'discourse/lib/ajax';
import loadScript from "discourse/lib/load-script";

export default Discourse.Route.extend({
    model(opts) {
        return ajax("/siwe/message");
    },

    setupController(controller, model) {
        controller.setProperties({ model });
    },

    actions: {
        didTransition() {
            loadScript('/javascripts/../../providers/metamask.js.es6');
            return true;
        }
    }
});
