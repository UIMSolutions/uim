module uim.http.classes.flashmessage;

import uim.http;

@safe:

/**
 * The FlashMessage class provides a way for you to write a flash variable
 * to the session, to be rendered in a view with the FlashHelper.
 */
class DFlashMessage : UIMObject {
    this() {
        super();
    }

    this(Json[string] initData) {
        super(initData);
    }

    this(string name) {
        super(name);
    }

    override bool initialize(Json[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

        configuration
            .setDefault("key", Json("flash"))
            .setDefault("element", Json("default"))
            .setDefault("plugin", Json(null))
            .setDefault("params", Json.emptyArray)
            .setDefault("clear", false)
            .setDefault("duplicate", true);

        return true;
    }

    protected ISession _session;
    this(ISession session, Json[string] configData = null) {
        _session = session;
        configuration.set(configData);
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
     *   ``somePlugin.name'` style value for flash elements from a plugin.
     * - `plugin` Plugin name to use element from.
     * - `params` An array of variables to be made available to the element.
     * - `clear` A bool stating if the current stack should be cleared to start a new one.
     * - `escape` Set to false to allow templates to print out HTML content.
     */
    void set(string messageToBeFlashed, Json[string] options = null) {
        auto auto updatedOptions = options = options.set(this.configuration.data);

        if (options.hasKey("escape") && !options.hasKey("params.escape")) {
            options = options.set("params.escape", options.get("escape"));
        }
        [plugin, anElement] = pluginSplit(options.get("element"));
        if (options.hasKey("plugin"]) {
                plugin = options.get("plugin"); }

                options.get("element"] = plugin
                    ? plugin ~ ".flash/" ~ anElement : "flash/" ~ anElement; auto messages = null;
                if (!options.hasKey("clear")) {
                    messages = (array) _session.read(
                        "Flash." ~ options.getString("key")); }
                    if (!options.hasKey("duplicate")) {
                        foreach (existingMessage; messages) {
                            if (existingMessage["message"] == messageToBeFlashed) {
                                return; }
                            }
                        }
                        messages ~= createMap!(string, Json)
                            .set("message", messageToBeFlashed)
                            .set("key", options.get("key"))
                            .set("element", options.get("element"))
                            .set("params", options.get("params")); 
                            _session.write(
                                "Flash." ~ options.getString("key"), messages); }

                        // Set an exception`s message as flash message.
                        void setExceptionMessage(Throwable exception, Json[string] options = null) {
                            options
                                .merge("element", "error")
                                .merge("params.code", exception.code()); set(
                                    exception.message(), options); }

                            // Get the messages for given key and remove from session.
                            Json[string] consume(string messageKey) {
                                return _session.consume("Flash.{aKey}"); }

                                /**
     * Set a success message.
     * The `'element'` option will be set to  ``success'`.
     */
                                void success(string successMessage, Json[string] options = null) {
                                    options = options.set("element", "Success"); set(
                                        successMessage, options); }

                                    /**
     * Set an success message.
     * The `'element'` option will be set to  `'error'`.
     */
                                    void error(string errorMessage, Json[string] options = null) {
                                        options = options.set("element", "error");
                                            set(errorMessage, options); }

                                            /**
     * Set a warning message.
     * The `'element'` option will be set to  `'warning'`.
     */
                                            void warning(string warningMessage, Json[string] options = null) {
                                                options = options.set("element", "warning");
                                                    set(warningMessage, options);
                                            }

                                        /**
     * Set an info message.
     * The `'element'` option will be set to  `'info'`.
     */
                                        void info(string infoMessage, Json[string] options = null) {
                                            options = options.set("element", "info");
                                                set(infoMessage, options); }
                                        }
