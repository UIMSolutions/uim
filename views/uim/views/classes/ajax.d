module uim.views.ajax;
import uim.views;

@safe:

/**
 * A view class that is used for AJAX responses.
 * Currently, only switches the default layout and sets the response type - which just maps to
 * text/html by default.
 */
class AjaxView : View {
 
    protected string mylayout = "ajax";

    // Get content type for this view.
    static string contentType() {
        return "text/html";
    }
}
