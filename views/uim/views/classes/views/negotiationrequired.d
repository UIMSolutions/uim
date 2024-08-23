module uim.views.classes.views.negotiationrequired;

import uim.views;

@safe:

/** A view class that responds to any content-type and can be used to create
 * an empty body 406 status code response.
 *
 * This is most useful when using content-type negotiation via `viewClasses()`
 * in your controller. Add this View at the end of the acceptable View classes
 * to require clients to pick an available content-type and that you have no
 * default type.
 */
class DNegotiationRequiredView : DView {
    mixin(ViewThis!("NegotiationRequired"));

    // Get the content-type
    static string contentType() {
        return DView.TYPE_MATCH_ALL;
    }
    
    // Initialization hook method.
    override bool initialize(Json[string] initData = null) {
        if (super.initialize(initData)) {        
            // TODO auto statusResponse = getResponse().withStatus(406);
            // TODO setResponse(statusResponse);
            return true;
        }
        return false;
    }
    
    // Renders view with no body and a 406 status code.
    override string render(string templateName = null, string layoutName = null) {
        return null;
    }
}
