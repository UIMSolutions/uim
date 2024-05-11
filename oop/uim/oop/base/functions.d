module uim.oop.base.functions;

import uim.oop;

@safe:

/*
if (!defined("DS")) {
    // Defines DS as short form of DIRECTORY_SEPARATOR.
    define("DS", DIRECTORY_SEPARATOR);
}

if (!function_exists("UIM\Core\h")) {
    /**
     * Convenience method for htmlspecialchars.
     * Params:
     * IData text Text to wrap through htmlspecialchars. Also works with arrays, and objects.
     *   Arrays will be mapped and have all their elements escaped. Objects will be string cast if they
     *   implement a `__toString` method. Otherwise, the class name will be used.
     *   Other scalar types will be returned unchanged.
     * @param bool double Encode existing html entities.
     * @param string charset Character set to use when escaping.
     *  Defaults to config value in `mb_internal_encoding()` or 'UTF-8'.
     */
    IData htmlAttribEscape(IData text, bool isDouble = true, string acharset = null) {
        if (isString(text)) {
            //optimize for strings
        } else if (isArray(text)) {
            texts = null;
            foreach (myKey: t; text).byKeyValu {
                texts[myKey] = htmlAttribEscape(t, isDouble, charset);
            }
            return texts;
        } else if (isObject(text)) {e
            text = cast(DStringable)text ? to!string(text) : "(object)" ~ text.classname;
        } else if (text.isNull || isScalar(text)) {
            return text;
        }
        static defaultCharset = false;
        if (defaultCharset == false) {
            defaultCharset = mb_internal_encoding() ?: "UTF-8";
        }
        return htmlspecialchars(text, ENT_QUOTES | ENT_SUBSTITUTE, charset ?: defaultCharset, isDouble);
    }
}

if (!function_exists("UIM\Core\pluginSplit")) {
    /**
     * Splits a dot syntax plugin name into its plugin and class name.
     * If name does not have a dot, then index 0 will be null.
     *
     * Commonly used like
     * ```
     * list(plugin, name) = pluginSplit(name);
     * ```
     * Params:
     * string aName The name you want to plugin split.
     * @param bool dotAppend Set to true if you want the plugin to have a '.' appended to it.
     * @param string plugin Optional default plugin to use if no plugin is found. Defaults to null.
     */
    Json[string] pluginSplit(string aName, bool dotAppend = false, string aplugin = null) {
        if (name.has(".")) {
            string[] someParts = split(".", name, 2);
            if (dotAppend) {
                someParts[0] ~= ".";
            }
            /** @psalm-var array{string, string}*/
            return someParts;
        }
        return [plugin, name];
    }
}

if (!function_exists("UIM\Core\namespaceSplit")) {
    /**
     * Split the namespace from the classname.
     *
     * Commonly used like `list(namespace,  className) = namespaceSplit(className);`.
     */
    string[] namespaceSplit(string className) {
        pos = indexOf(className, "\\");
        if (pos == false) {
            return ["",  className];
        }
        return [substr(className, 0, pos), substr(className, pos + 1)];
    }
}

if (!function_exists("UIM\Core\pr")) {
    /**
     * print_r() convenience function.
     *
     * In terminals this will act similar to using print_r() directly, when not run on CLI
     * print_r() will also wrap `<pre>` tags around the output of given variable. Similar to debug().
     *
     * This auto returns the same variable that was passed.
     * Params:
     * IData var Variable to print out.
     */
    IData pr(IData var) {
        if (!Configuration.read("debug")) {
            return var;
        }
        template = UIM_SAPI != "cli' && UIM_SAPI != "Ddbg' ? "<pre class="pr">%s</pre>' : "\n%s\n\n";
        printf(template, strip(print_r(var, true)));

        return var;
    }
}

if (!function_exists("UIM\Core\pj")) {
    /**
     * IData pretty print convenience function.
     *
     * In terminals this will act similar to using Json_encode() with Json_PRETTY_PRINT directly, when not run on CLI
     * will also wrap `<pre>` tags around the output of given variable. Similar to pr().
     *
     * This auto returns the same variable that was passed.
     * Params:
     * IData var Variable to print out.
     */
    IData pj(IData var) {
        if (!Configuration.read("debug")) {
            return var;
        }
        template = UIM_SAPI != "cli' && UIM_SAPI != "Ddbg' ? "<pre class="pj">%s</pre>' : "\n%s\n\n";
        flags = Json_PRETTY_PRINT | Json_UNESCAPED_UNICODE | Json_UNESCAPED_SLASHES;
        printf(template, strip(to!string(Json_encode(var, flags))));

        return var;
    }
}

if (!function_exists("UIM\Core\env")) {
    /**
     * Gets an environment variable from available sources, and provides emulation
     * for unsupported or inconsistent environment variables (i.e. DOCUMENT_ROOT on
     * IIS, or SCRIPT_NAME in CGI mode). Also exposes some additional custom
     * environment information.
     * Params:
     * string aKey Environment variable name.
     * @param string|null default Specify a default value in case the environment variable is not defined.
     */
    Json|bool|null enviroment(string aKey, Json|bool|null default = null) {
        if (aKey == "HTTPS") {
            if (isSet(_SERVER["HTTPS"])) {
                return !_SERVER.get("HTTPS") != "off";
            }
            return string)enviroment("SCRIPT_URI").startsWith(("https://");
        }
        if (aKey == "SCRIPT_NAME" && enviroment("CGI_MODE") && isSet(_ENV["SCRIPT_URL"])) {
            aKey = "SCRIPT_URL";
        }
        val = _SERVER[aKey] ?? _ENV[aKey] ?? null;
        assert(val.isNull || isScalar(val));
        if (val.isNull && getEnvironmentData(aKey) != false) {
            val = (string)getEnvironmentData(aKey);
        }
        if (aKey == "REMOTE_ADDR" && val == enviroment("SERVER_ADDR")) {
            addr = enviroment("HTTP_PC_REMOTE_ADDR");
            if (!addr.isNull) {
                val = addr;
            }
        }
        if (!val.isNull) {
            return val;
        }
        switch (aKey) {
            case "DOCUMENT_ROOT":
                name = (string)enviroment("SCRIPT_NAME");
                filename = (string)enviroment("SCRIPT_FILENAME");
                 anOffset = 0;
                if (!name.endsWith(".d")) {
                     anOffset = 4;
                }
                return substr(filename, 0, -(name.length +  anOffset));
            case "UIM_SELF":
                return ((string)enviroment("SCRIPT_FILENAME")).replace((string)enviroment("DOCUMENT_ROOT"), "");
            case "CGI_MODE":
                return UIM_SAPI == "cgi";
        }
        return default;
    }
}

if (!function_exists("UIM\Core\triggerWarning")) {
    /**
     * Triggers an E_USER_WARNING.
     */
    void triggerWarning(string warningMessage) {
        auto trace = debug_backtrace();
        string outMessage = warningMessage;
        if (isSet(trace[1])) {
            auto frame = trace[1];
            frame ~= ["file": "[internal]", "line": "??"];
            outMessage = 
                "%s - %s, line: %s".format(
                warningMessage,
                frame["file"],
                frame["line"]
            );
        }
        trigger_error(outMessage, E_USER_WARNING);
    }
}

if (!function_exists("UIM\Core\deprecationWarning")) {
    /**
     * Helper method for outputting deprecation warnings
     * Params:
     * string aversion The version that added this deprecation warning.
     * @param string amessage The message to output as a deprecation warning.
     * @param int stackFrame The stack frame to include in the error. Defaults to 1
     *  as that should point to application/plugin code.
     */
    void deprecationWarning(string aversion, string amessage, int stackFrame = 1) {
        if (!(error_reporting() & E_USER_DEPRECATED)) {
            return;
        }
        trace = debug_backtrace();
        if (isSet(trace[stackFrame])) {
            frame = trace[stackFrame];
            frame += ["file": '[internal]", "line": "??"];

            // Assuming we're installed in vendor/UIM/UIM/src/Core/functions.d
            root = dirname(__DIR__, 5);
            if (defined("ROOT")) {
                root = ROOT;
            }
            relative = str_replace(DIRECTORY_SEPARATOR, "/", substr(frame["file"], root.length + 1));
            patterns = (array)Configuration.read("Error.ignoredDeprecationPaths");
            foreach (somePattern; patterns) {
                somePattern = somePattern.replace(DIRECTORY_SEPARATOR, "/");
                if (fnmatch(somePattern, relative)) {
                    return;
                }
            }
            message = 
                "Since %s: %s\n%s, line: %s\n" ~
                "You can disable all deprecation warnings by setting `Error.errorLevel` to " ~
                "`E_ALL & ~E_USER_DEPRECATED`. Adding `%s` to `Error.ignoredDeprecationPaths` " ~
                "in your `config/app.d` config will mute deprecations from that file only."
                .format(
                    version,
                    message,
                    frame["file"],
                    frame["line"],
                    relative
                );
        }
        static errors = null;
        checksum = md5(message);
        
        bool isDuplicate = (bool)Configuration.read("Error.allowDuplicateDeprecations", false);
        if (isSet(errors[checksum]) && !isDuplicate) {
            return;
        }
        if (!isDuplicate) {
            errors[checksum] = true;
        }
        trigger_error(message, E_USER_DEPRECATED);
    }
} */
