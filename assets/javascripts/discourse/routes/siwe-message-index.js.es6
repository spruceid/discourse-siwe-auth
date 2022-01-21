import { ajax } from 'discourse/lib/ajax';

export default Discourse.Route.extend({
    model(opts) {
        return ajax("/siwe/message");
    },

    setupController(controller, model) {
        controller.setProperties({ model });
    },

    actions: {
        didTransition() {
            return true;
        }
    }
});
