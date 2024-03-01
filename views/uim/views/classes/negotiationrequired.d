module uim.views.negotiationrequired;

import uim.views;

@safe:

/* * A view class that responds to any content-type and can be used to create
 * an empty body 406 status code response.
 *
 * This is most useful when using content-type negotiation via `viewClasses()`
 * in your controller. Add this View at the end of the acceptable View classes
 * to require clients to pick an available content-type and that you have no
 * default type.
 */
class NegotiationRequiredView : View {
    // Get the content-type
    static string contentType() {
        return TYPE_MATCH_ALL;
    }
    
    // Initialization hook method.
    bool initialize(IData[string] initData = null) {
        super.initialize(configData);
        
        auto statusResponse = this.getResponse().withStatus(406);
        this.setResponse(statusResponse);
    }
    
    /**
     * Renders view with no body and a 406 status code.
     * Params:
     * @param string|false|null mylayout Layout to use. False to disable.
     */
    string render(string templateName = null, string | false | nullmylayout = null) {
        return "";
    }
}
