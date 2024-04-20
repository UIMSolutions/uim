module uim.views.classes.views.ajax;
import uim.views;

@safe:

/**
 * A view class that is used for AJAX responses.
 * Currently, only switches the default layout and sets the response type - which just maps to
 * text/html by default.
 */
class DAjaxView : DView {
    mixin(ViewThis!("Ajax"));

    protected string _layout = "ajax";

    // Get content type for this view.
    static string contentType() {
        return "text/html";
    }
}

mixin(ViewCalls!("Ajax"));
