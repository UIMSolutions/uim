/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.http.classes.sessions.session;

import uim.http;

@safe:

/**
 * This class is a wrapper for the native UIM session functions. It provides
 * several defaults for the most common session configuration
 * via external handlers and helps with using session in CLI without any warnings.
 *
 * Sessions can be created from the defaults using `Session.create()` or you can get
 * an instance of a new session by just instantiating this class DAnd passing the complete
 * options you want to use.
 *
 * When specific options are omitted, this class will take its defaults from the configuration
 * values from the `session.*` directives in D.ini. This class will also alter such
 * directives when configuration values are provided.
 */
class DSession {
    /* 
    // The Session handler instance used as an engine for persisting the session data.
    protected ISessionHandler _engine = null;

    // Indicates whether the sessions has already started
    protected bool _started = false;

    // The time in seconds the session will be valid for
    protected int _lifetime;

    // Whether this session is running under a CLI environment
    protected bool _isCLI = false;

    /**
     * Info about where the headers were sent.
     *
     * @var array{filename: string, line: int}|null
     */
    protected Json[string] aHeaderSentInfo = null;

    /**
     * Returns a new instance of a session after building a configuration bundle for it.
     * This auto allows an options array which will be used for configuring the session
     * and the handler to be used. The most important key in the configuration array is
     * `defaults`, which indicates the set of configurations to inherit from, the possible
     * defaults are:
     *
     * - D: just use session as configured in D.ini
     * - cache: Use the UIM caching system as an storage for the session, you will need
     * to pass the `config` key with the name of an already configured Cache engine.
     * - database: Use the UIM ORM to persist and manage sessions. By default this requires
     * a table in your database named `sessions` or a `model` key in the configuration
     * to indicate which Table object to use.
     * - uim: Use files for storing the sessions, but let UIM manage them and decide
     * where to store them.
     *
     * The full list of options follows:
     *
     * - defaults: either "D", "database", "cache" or "uim" as explained above.
     * - handler: An array containing the handler configuration
     * - ini: A list of D.ini directives to set before the session starts.
     * - timeout: The time in minutes the session should stay active
     * Params:
     * Json[string] sessionConfig Session config.
     */
    static DSession create(Json[string] sessionConfig = null) {
        if (sessionConfig.hasKey("defaults")) {
            sessionConfig = sessionConfig.dup.merge(
                _defaultConfigData(sessionConfig.getMap("defaults")));
        }
        if (
            !sessionConfig.hasKey("ini.session.cookie_secure")
            && enviroment("HTTPS")
            && ini_get("session.cookie_secure") != 1
           ) {
            sessionConfig.set("ini.session.cookie_secure", 1);
        }
        if (
            !sessionConfig.hasKey("ini.session.name")
            && sessionConfig.hasKey("cookie")
           ) {
            sessionConfig.set("ini.session.name", sessionConfig["cookie"]);
        }
        if (!sessionConfig.hasKey("ini.session.use_strict_mode") && ini_get(
                "session.use_strict_mode") != 1) {
            sessionConfig.set("ini.session.use_strict_mode", 1);
        }
        if (!sessionConfig.hasKey("ini.session.cookie_httponly") && ini_get(
                "session.cookie_httponly") != 1) {
            sessionConfig.set("ini.session.cookie_httponly", 1);
        }
        // return new static(sessionConfig);
        return null; 
    }

    // Get one of the prebaked default session configurations.
    protected static Json[string] _defaultConfigData(string configName) {
        tmp = defined("TMP") ? TMP : sys_get_temp_dir() ~ DIRECTORY_SEPARATOR;
        Json[string] defaults = [
            "D": [
                "ini": [
                    "session.use_trans_sid": 0,
                ],
            ],
            "uim": [
                "ini": [
                    "session.use_trans_sid": 0,
                    "session.serialize_handler": "D",
                    "session.use_cookies": 1,
                    "session.save_path": tmp ~ "sessions",
                    "session.save_handler": "files",
                ],
            ],
            "cache": [
                "ini": [
                    "session.use_trans_sid": 0,
                    "session.use_cookies": 1,
                ],
                "handler": [
                    "engine": "CacheSession",
                    "config": "default",
                ],
            ],
            "database": [
                "ini": [
                    "session.use_trans_sid": 0,
                    "session.use_cookies": 1,
                    "session.serialize_handler": "D",
                ],
                "handler": [
                    "engine": "DatabaseSession",
                ],
            ],
        ];

        if (defaults.hasKey(configName)) {
            if (configName != "D" || ini_get("session.cookie_samesite").isEmpty) {
                defaults.set("D.ini.session.cookie_samesite", "Lax");
            }
            return defaults[configName];
        }
        return null;
    }

    /**
     .
     *
     * ### Configuration:
     *
     * - timeout: The time in minutes the session should be valid for.
     * - cookiePath: The url path for which session cookie is set. Maps to the
     * `session.cookie_path` D.ini config. Defaults to base path of app.
     * - ini: A list of D.ini directives to change before the session start.
     * - handler: An array containing at least the `engine` key. To be used as the session
     * engine for persisting data. The rest of the keys in the array will be passed as
     * the configuration array for the engine. You can set the `engine` key to an already
     * instantiated session handler object.
     */
    this(Json[string] initData = null) {
        configuration
            .setDefaults(["timeout", "cookie"], Json(null))
            .setDefaults(["ini", "handler"], Json.emptyArray);

        if (configuration.hasKey("timeout")) {
            configuration.set("ini.session.gc_maxlifetime", 60 * configuration.get("timeout"));
        }
        if (configuration.hasKey("cookie")) {
            configuration.set("ini.session.name", configuration.get("cookie"));
        }
        if (!configuration.hasKey("ini.session.cookie_path")) {
            cookiePath = configData.isEmpty("cookiePath") ? "/" : configuration.getString("cookiePath");
            configuration.set("ini.session.cookie_path", cookiePath);
        }
        options(configuration.get("ini"));

        if (!configData.isEmpty("handler")) {
            auto handlerEngineClassname = configuration.shift("handler.engine").getString;
            engine(handlerEngineClassname, configuration.get("handler"));
        }
        _lifetime = (int) ini_get("session.gc_maxlifetime");
        _isCLI = (UIM_SAPI == "cli" || UIM_SAPI == "Ddbg");
        session_register_shutdown();
    }

    /**
     * Sets the session handler instance to use for this session.
     * If a string is passed for the first argument, it will be treated as the
     * class name and the second argument will be passed as the first argument
     * in the constructor.
     *
     * If an instance of a !SessionHandler is provided as the first argument,
     * the handler will be set to it.
     *
     * If no arguments are passed it will return the currently configured handler instance
     * or null if none exists.
     * Params:
     * \!SessionHandler|string  classname The session handler to use
     */
    SessionHandler engine(
        /* !SessionHandler | */ string handleClassname = null,
        Json[string] options = null
   ) {
        if (handleClassname.isNull) {
            return _engine;
        }
        if (cast(DSessionHandler) handleClassname) {
            return _setEngine(handleClassname);
        }
        /** @var class-string<\!SessionHandler>|null  classname */
        handleClassname = App.classname(handleClassname, "Http/Session");
        if (handleClassname.isNull) {
            throw new DInvalidArgumentException(
                "The class `%s` does not exist and cannot be used as a session engine"
                    .format(handleClassname)
           );
        }
        return _setEngine(new handleClassname(options));
    }

    /**
     * Set the engine property and update the session handler in D.
     * Params:
     * \!SessionHandler handler The handler to set
     */
    /* protected ISessionHandler setEngine(!SessionHandlerhandler) : ! {
        if (!headers_sent() && session_status() != UIM_SESSION_ACTIVE) {
            session_set_save_handler(handler, false);
        }
        return _engine = handler;
    } */

    /**
     * Calls ini_set for each of the keys in `options` and set them
     * to the respective value in the passed array.
     *
     * ### Example:
     *
     * ```
     * session.options(["session.use_cookies": 1]);
     * ```
     * Params:
     * Json[string] options Ini options to set.
     */
    void options(Json[string] options = null) {
        if (session_status() == UIM_SESSION_ACTIVE || headers_sent()) {
            return;
        }
        foreach (setting, value; options) {
            if (ini_set(setting, to!string(value)) == false) {
                throw new UIMException(
                    "Unable to configure the session, setting %s failed.".format(setting)
               );
            }
        }
    }

    /**
     * Starts the Session.
     */
    bool start() {
        if (_started) {
            return true;
        }
        if (_isCLI) {
            _SESSION = null;
            this.id("cli");

            return _started = true;
        }
        if (session_status() == UIM_SESSION_ACTIVE) {
            throw new UIMException("Session was already started");
        }
        filename = line = null;
        if (ini_get("session.use_cookies") && headers_sent(filename, line)) {
            this.headerSentInfo = ["filename": filename, "line": line];

            return false;
        }
        if (!session_start()) {
            throw new UIMException("Could not start the session");
        }
        _started = true;

        if (_timedOut()) {
            destroy();

            return _start();
        }
        return _started;
    }

    /**
     * Write data and close the session
     */
    bool close() {
        if (!_started) {
            return true;
        }
        if (_isCLI) {
            _started = false;

            return true;
        }
        if (!session_write_close()) {
            throw new UIMException("Could not close the session");
        }
        _started = false;

        return true;
    }

    // Determine if Session has already been started.
    bool started() {
        return _started || session_status() == UIM_SESSION_ACTIVE;
    }

    // Returns true if given variable name is set in session.
    bool check(string variableName = null) {
        if (_hasSession() && !this.started()) {
            this.start();
        }
        if (_SESSION !is null) {
            return false;
        }

        if (name.isNull) {
            return /* (bool) */ _SESSION;
        }
        return Hash.get(_SESSION, variableName) !is null;
    }

    // Returns given session variable, or all of them, if no parameters given.
    Json read(string variableName = null, Json defaultValue = Json(null)) {
        if (_hasSession() && !this.started()) {
            this.start();
        }
        if (_SESSION !is null) {
            return defaultValue;
        }
        if (variableName.isNull) {
            return _SESSION ? _SESSION : [];
        }
        return Hash.get(_SESSION, variableName, defaultValue);
    }

    // Returns given session variable, or throws Exception if not found.
    Json readOrFail(string sessionName) {
        if (!this.check(sessionName)) {
            throw new UIMException("Expected session key `%s` not found.".format(sessionName));
        }
        return _read(sessionName);
    }

    // Reads and deletes a variable from session.
    Json consume(string key) {
        if (isEmpty(key)) {
            return null;
        }
        
        Json result = this.read(key);
        if (!result.isNull) {
            /** @psalm-suppress InvalidScalarArgument */
            _overwrite(_SESSION, Hash.removeKey(_SESSION, key));
        }
        return result;
    }

    // Writes value to given session variable name.
    void write(string variableName, Json value = Json(null)) {
        write([variableName: value], value);
    }
    void write(string[string] variables, Json value = Json(null)) {
        bool started = this.started() || this.start();
        if (!started) {
            auto message = "Could not start the session";
            if (_headerSentInfo !is null) {
                message ~=
                    ", headers already sent in file `%s` on line `%s`"
                    .format(Debugger.trimPath(_headerSentInfo.getString("filename")),
                        _headerSentInfo["line"]
                   );
            }
            throw new UIMException(message);
        }

        auto someData = _SESSION ?  _SESSION : [];
        name.byKeyValue
            .each(kv => someData = Hash.insert(someData, kv.key, kv.value));

        _overwrite(_SESSION, someData);
    }

    /**
     * Returns the session ID.
     * Calling this method will not auto start the session. You might have to manually
     * assert a started session.
     *
     * Passing an ID into it, you can also replace the session ID if the session
     * has not already been started.
     * Note that depending on the session handler, not all characters are allowed
     * within the session ID. For example, the file session handler only allows
     * characters in the range a-z A-Z 0-9 , (comma) and - (minus).
     * Params:
     * string  anId ID to replace the current session ID.
     */
    string id(string aid = null) {
        if (anId!is null && !headers_sent()) {
            session_id(anId);
        }
        return to!string(session_id());
    }

    // Removes a variable from session.
    bool removeKey(string sessionName) {
        if (this.check(sessionName)) {
            /** @psalm-suppress InvalidScalarArgument */
            _overwrite(_SESSION, Hash.removeKey(_SESSION, sessionName));
        }
    }

    // Used to write new data to _SESSION, since UIM doesn`t like us setting the _SESSION var it
/*    protected void _overwrite(Json[string] oldValues, Json[string] newValues) {
       ) {
            oldValues.byKeyValue
                .filter!(kv => newValues.isNull(kv.key))
                .each!(kv => removeKey(oldValues[kv.key]));

            newValues.byKeyValue
                .each!(kv => oldValues[kv.key] = kv.value);
        }
 */
        // Helper method to destroy invalid sessions.
        void destroy() {
            if (_hasSession() && !this.started()) {
                this.start();
            }
            if (!_isCLI && session_status() == UIM_SESSION_ACTIVE) {
                session_destroy();
            }
            _SESSION = null;
            _started = false;
        }

        /**
     * Clears the session.
     * Optionally it also clears the session id and renews the session.
     */
        void clear(bool shouldRenewed = false) {
            _SESSION = null;
            if (shouldRenewed) {
                this.renew();
            }
        }

        // Returns whether a session exists
        protected bool _hasSession() {
            return !ini_get("session.use_cookies")
                || _COOKIE.hasKey(session_name())
                || _isCLI
                || (ini_get("session.use_trans_sid") && _GET.hasKey(session_name()));
        }

        // Restarts this session.
        void renew() {
            if (!_hasSession() || _isCLI) {
                return;
            }
            this.start();
            params = session_get_cookie_params();
            setcookie(
                to!string(session_name()),
                "",
                time() - 42000,
                params["path"],
                params["domain"],
                params["secure"],
                params["httponly"]
           );

            if (!session_id().isEmpty) {
                session_regenerate_id(true);
            }
        }

        /**
     * Returns true if the session is no longer valid because the last time it was
     * accessed was after the configured timeout.
     */
        protected bool _timedOut() {
            time = this.read("Config.time");
            result = false;

            checkTime = time!is null && _lifetime > 0;
            if (checkTime && (time() - (int)time > _lifetime)) {
                result = true;
            }
            this.write("Config.time", time());

            return result;
        }
}
