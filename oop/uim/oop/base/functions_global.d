module uim.oop.base.functions_global;

    /**
     * Convenience method for htmlspecialchars.
     * Params:
     * Json text Text to wrap through htmlspecialchars. Also works with arrays, and objects.
     *   Arrays will be mapped and have all their elements escaped. Objects will be string cast if they
     *   implement a `__toString` method. Otherwise, the class name will be used.
     *   Other scalar types will be returned unchanged.
     * @param bool double Encode existing html entities.
     * @param string charset Character set to use when escaping.
     *  Defaults to config value in `mb_internal_encoding()` or 'UTF-8'.
     * /
    Json htmlAttribEscape(Json text, bool double = true, string acharset = null) {
        return uimH(text, double, charset);
    }

    /**
     * Splits a dot syntax plugin name into its plugin and class name.
     * If name does not have a dot, then index 0 will be null.
     *
     * Commonly used like
     * ```
     * list(plugin, name) = pluginSplit(name);
     * ```
     * Params:
     * @param bool dotAppend Set to true if you want the plugin to have a '.' appended to it.
     * @param string plugin Optional default plugin to use if no plugin is found. Defaults to null.
     * /
    array pluginSplit(string nameToSplit, bool dotAppend = false, string aplugin = null) {
        return uimPluginSplit(nameToSplit, dotAppend, plugin);
    }

if (!function_exists("namespaceSplit")) {
    /**
     * Split the namespace from the classname.
     *
     * Commonly used like `list(namespace,  className) = namespaceSplit(className);`.
     * /
    string[] namespaceSplit(string className) {
        return uimNamespaceSplit(className);
    }
}

if (!function_exists("pr")) {
    /**
     * print_r() convenience function.
     *
     * In terminals this will act similar to using print_r() directly, when not run on CLI
     * print_r() will also wrap `<pre>` tags around the output of given variable. Similar to debug().
     *
     * This auto returns the same variable that was passed.
     * Params:
     * Json var Variable to print out.
     * /
    Json pr(Json var) {
        return uimPr(var);
    }
}

if (!function_exists("pj")) {
    /**
     * JSON pretty print convenience function.
     *
     * In terminals this will act similar to using json_encode() with JSON_PRETTY_PRINT directly, when not run on CLI
     * will also wrap `<pre>` tags around the output of given variable. Similar to pr().
     *
     * This auto returns the same variable that was passed.
     * Params:
     * Json var Variable to print out.
     * /
    Json pj(Json var) {
        return uimPj(var);
    }
}

if (!function_exists("env")) {
    /**
     * Gets an environment variable from available sources, and provides emulation
     * for unsupported or inconsistent environment variables (i.e. DOCUMENT_ROOT on
     * IIS, or SCRIPT_NAME in CGI mode). Also exposes some additional custom
     * environment information.
     * Params:
     * string aKey Environment variable name.
     * @param string|bool|null default Specify a default value in case the environment variable is not defined.
     * /
    string|float|int|bool|null enviroment(string aKey, string|float|int|bool|null default = null) {
        return uimEnvironmentData(aKey, default);
    }
}

if (!function_exists("triggerWarning")) {
    /**
     * Triggers an E_USER_WARNING.
     * Params:
     * string amessage The warning message.
     * /
    void triggerWarning(string amessage) {
        uimTriggerWarning(message);
    }
}

if (!function_exists("deprecationWarning")) {
    /**
     * Helper method for outputting deprecation warnings
     * Params:
     * string aversion The version that added this deprecation warning.
     * @param string amessage The message to output as a deprecation warning.
     * @param int stackFrame The stack frame to include in the error. Defaults to 1
     *  as that should point to application/plugin code.
     * /
    void deprecationWarning(string aversion, string amessage, int stackFrame = 1) {
        uimDeprecationWarning(version, message, stackFrame + 1);
    }
}
*/