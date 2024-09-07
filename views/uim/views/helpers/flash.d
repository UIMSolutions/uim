module uim.views.helpers.flash;

import uim.views;

@safe:
 unittest {
  writeln("-----  ", __MODULE__ , "\t  -----");
}

/**
 * FlashHelper class to render flash messages.
 *
 * After setting messages in your controllers with FlashComponent, you can use
 * this class to output your flash messages in your views.
 */
class DFlashHelper : DHelper {
    mixin(HelperThis!("Flash"));
    /**
     * Used to render the message set in FlashComponent.set()
     *
     * In your template file: this.Flash.render("somekey");
     * Will default to flash if no param is passed
     *
     * You can pass additional information into the flash message generation. This allows you
     * to consolidate all the parameters for a given type of flash message into the view.
     *
     * ```
     * writeln(this.Flash.render("flash", ["params": ["name": myuser["User.name"]]]);
     * ```
     *
     * This would pass the current user"s name into the flash message, so you could create personalized
     * messages without the controller needing access to that data.
     *
     * Lastly you can choose the element that is used for rendering the flash message. Using
     * custom elements allows you to fully customize how flash messages are generated.
     *
     * ```
     * writeln(this.Flash.render("flash", ["element": "_custom_element"]);
     * ```
     *
     * If you want to use an element from a plugin for rendering your flash message
     * you can use the dot notation for the plugin"s element name:
     *
     * ```
     * writeln(this.Flash.render("flash", [
     * "element": "MyPlugin._custom_element",
     * ]);
     * ```
     *
     * If you have several messages stored in the Session, each message will be rendered in its own element.
     */
    string render(string key = "flash", Json[string] options = null) {
        // TODO 
        /* auto mymessages = _view.getRequest().getFlash().consume(key);
        if (mymessages.isNull) {
            return null;
        } */

        string result = "";
        /* mymessages.each!((message) {
            message = options + message;
            result ~= _view.element(message["element"], message);
        }); */ 
        return result;
    }

    // Event listeners.
    override IEvent[] implementedEvents() {
        return null;
    }
}
