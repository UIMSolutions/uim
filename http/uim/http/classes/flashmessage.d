module uim.http.classes.flashmessage;

import uim.http;

@safe:

/**
 * The FlashMessage class provides a way for you to write a flash variable
 * to the session, to be rendered in a view with the FlashHelper.
 */
class DFlashMessage {
    mixin TConfigurable;
    
    this() {
        initialize;
    }

    this(Json[string] initData) {
        initialize(initData);
    }

    this(string name) {
        this().name(name);
    }

    // Hook method
    bool initialize(Json[string] initData = null) {
        configuration(MemoryConfiguration);
        configuration.data(initData);

        return true;
    }

    mixin(TProperty!("string", "name"));
    /* 

    // Default configuration
    configuration.updateDefaults([
        "key": Json("flash"),
        "element": Json("default"),
        "plugin": null,
        "params": Json.emptyArray,
        "clear": Json(false),
        "duplicate": Json(true),
    ];

    protected ISession _session;

    this(ISession session, Json[string] configData = null) {
        _session = session;
        configuration.update(configData);
    }
    
    /**
     * Store flash messages that can be output in the view.
     *
     * If you make consecutive calls to this method, the messages will stack
     * (if they are set with the same flash key)
     *
     * ### Options:
     *
     * - `key` The key to set under the session`s Flash key.
     * - `element` The element used to render the flash message. You can use
     *    ``somePlugin.name'` style value for flash elements from a plugin.
     * - `plugin` Plugin name to use element from.
     * - `params` An array of variables to be made available to the element.
     * - `clear` A bool stating if the current stack should be cleared to start a new one.
     * - `escape` Set to false to allow templates to print out HTML content.
     *
     * messageToBeFlashed - Message to be flashed.
     * @param Json[string] options An array of options
     * @see FlashMessage._defaultConfigData For default values for the options.
     * /
    void set(string messageToBeFlashed, Json[string] options = null) {
        auto options = options.update(this.configuration.data);

        if (isSet(options["escape"]) && !isSet(options["params"]["escape"])) {
            options["params"]["escape"] = options["escape"];
        }
        [plugin, anElement] = pluginSplit(options["element"]);
        if (options["plugin"]) {
            plugin = options["plugin"];
        }

        options["element"] = plugin 
            ? plugin ~ ".flash/" ~ anElement
            : "flash/" ~ anElement;

        auto messages = null;
        if (!options["clear"]) {
            messages = (array)this.session.read("Flash." ~ options["key"]);
        }
        if (!options["duplicate"]) {
            foreach (existingMessage; messages) {
                if (existingMessage["message"] == messageToBeFlashed) {
                    return;
                }
            }
        }
        messages ~= [
            "message": messageToBeFlashed,
            "key": options["key"],
            "element": options["element"],
            "params": options["params"],
        ];

        this.session.write("Flash." ~ options["key"], messages);
    }
    
    /**
     * Set an exception`s message as flash message.
     *
     * The following options will be set by default if unset:
     * ```
     * 'element": 'error",
     * `params": ["code": exception.getCode()]
     * ```
     * Params:
     * \Throwable exception Exception instance.
     * @param Json[string] options An array of options.
     * /
    void setExceptionMessage(Throwable exception, Json[string] options = null) {
        options["element"] ??= "error";
        options["params"]["code"] ??= exception.getCode();

        message = exception.getMessage();
        this.set(message, options);
    }
    
    // Get the messages for given key and remove from session.
    array consume(string messageKey) {
        return _session.consume("Flash.{aKey}");
    }
    
    /**
     * Set a success message.
     * The `'element'` option will be set to  ``success'`.
     * @see FlashMessage.set() For list of valid options
     * /
    void success(string successMessage, Json[string] options = null) {
        options["element"] = "Success";
        this.set(successMessage, options);
    }
    
    /**
     * Set an success message.
     * The `'element'` option will be set to  `'error'`.
     * @see FlashMessage.set() For list of valid options
     * /
    void error(string errorMessage, Json[string] options = null) {
        options["element"] = "error";
        this.set(errorMessage, options);
    }
    
    /**
     * Set a warning message.
     * The `'element'` option will be set to  `'warning'`.
     * /
    void warning(string warningMessage, Json[string] options = null) {
        options["element"] = "warning";
        this.set(warningMessage, options);
    }
    
    /**
     * Set an info message.
     * The `'element'` option will be set to  `'info'`.
     * /
    void info(string infoMessage, Json[string] options = null) {
        options["element"] = "info";
        this.set(infoMessage, options);
    } */
}
