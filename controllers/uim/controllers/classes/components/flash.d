module uim.controllers.classes.components.flash;

import uim.controllers;

@safe:

/**
 * The UIM FlashComponent provides a way for you to write a flash variable
 * to the session from your controllers, to be rendered in a view with the
 * FlashHelper.
 *
 * @method void success(string amessage, Json[string] options = null) Set a message using "success" element
 * @method void info(string amessage, Json[string] options = null) Set a message using "info" element
 * @method void warning(string amessage, Json[string] options = null) Set a message using "warning" element
 * @method void error(string amessage, Json[string] options = null) Set a message using "error" element
 */
class DFlashComponent : DComponent {
    override bool initialize(Json[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

        configuration.updateDefaults([
            "key": Json("flash"),
            "element": Json("default"),
            "params": Json.emptyArray,
            "clear": Json(false),
            "duplicate": Json(true)
        ]);

        return true;
    }

    /**
     * Used to set a session variable that can be used to output messages in the view.
     * If you make consecutive calls to this method, the messages will stack (if they are
     * set with the same flash key)
     *
     * In your controller: this.Flash.set("This has been saved");
     *
     * ### Options:
     *
     * - `key` The key to set under the session`s Flash key
     * - `element` The element used to render the flash message. Default to "default".
     * - `params` An array of variables to make available when using an element
     * - `clear` A bool stating if the current stack should be cleared to start a new one
     * - `escape` Set to false to allow templates to print out HTML content
     * Params:
     * \Throwable|string amessage Message to be flashed. If an instance
     *  of \Throwable the throwable message will be used and code will be set
     *  in params.
     * @param Json[string] options An array of options
     * /
    void set(Throwable | string amessage, Json[string] options = null) {
        if (cast(Throwable) aMessage) {
            this.flash().setExceptionMessage(message, options);
        } else {
            this.flash().set(message, options);
        }
    }

    // Get flash message utility instance.
    protected DFlashMessage flash() {
        return _getController().getRequest().getFlash();
    }

    /**
     * Proxy method to FlashMessage instance.
     * Params:
     * Json[string]|string aKey The key to set, or a complete array of configs.
     * @param bool  merge Whether to recursively merge or overwrite existing config, defaults to true.

     * @throws \UIM\Core\Exception\UimException When trying to set a key that is invalid.
     * /
    void setConfig(string[] aKey, Json valueToSet = null, bool merge = true) {
    }

    void setConfig(string[] aKey, Json valueToSet = null, bool merge = true) {
        this.flash().setConfig(aKey, valueToSet, merge);
    }

    /**
     * Proxy method to FlashMessage instance.
     * Params:
     * string|null aKey The key to get or null for the whole config.
     * /
    Json getConfig(string aKey = null, Json defaultValue = Json(null)) {
        return _flash().configuration.get(aKey, default);
    }

    /**
     * Proxy method to FlashMessage instance.
    Json getConfigOrFail(string aKey) {
        return _flash().getConfigOrFail(aKey);
    }
    
    //  Proxy method to FlashMessage instance.
     * Params:
     * Json[string]|string aKey The key to set, or a complete array of configs.
     * /
    void configShallow(string aKey, Json valueToSet = null) {
        this.flash().configShallow(aKey, valueToSet);
    }

    void configShallow(string[] keys, Json valueToSet = null) {
        this.flash().configShallow(keys, valueToSet);
    }

    /**
     * Magic method for verbose flash methods based on element names.
     *
     * For example: this.Flash.success("My message") would use the
     * `success.d` element under `templates/element/flash/` for rendering the
     * flash message.
     *
     * If you make consecutive calls to this method, the messages will stack (if they are
     * set with the same flash key)
     *
     * Note that the parameter `element` will be always overridden. In order to call a
     * specific element from a plugin, you should set the `plugin` option in someArguments.
     *
     * For example: `this.Flash.warning("My message", ["plugin": 'PluginName"])` would
     * use the `warning.d` element under `plugins/PluginName/templates/element/flash/` for
     * rendering the flash message.
     * /
    void __call(string elementName, Json[string] someArguments) {
        auto anElement = Inflector.underscore(elementName);

        if (count(someArguments) == 0) {
            throw new DInternalErrorException("Flash message missing.");
        }
        auto options = ["element": anElement];

        if (!someArguments[1].isEmpty) {
            if (!empty(someArguments[1]["plugin"])) {
                options = [
                    "element": someArguments[1]["plugin"] ~ "." ~ anElement
                ];
                someArguments[1].remove("plugin");
            }
            options = options.update(array) someArguments[1];
        }
        this.set(someArguments[0], options);
    } */
}
