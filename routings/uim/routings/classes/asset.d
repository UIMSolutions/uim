module source.uim.myname.classes.asset;

ynamemodule uim.uim.routings;

import uim.routings;

@safe:

/**
 * Class for generating asset URLs.
 */
class DAsset
{
    /**
     * Inflection type.
     * /
    protected static string ainflectionType = "underscore";

    /**
     * Set inflection type to use when inflecting plugin/theme name.
     * Params:
     * string ainflectionType Inflection type. Value should be a valid
     * method name of `Inflector` class like `"dasherize"` or `"underscore`"`.
     * /
    static void setInflectionType(string ainflectionType) {
        anInflectionType = anInflectionType;
    }
    
    /**
     * Generates URL for given image file.
     *
     * Depending on options passed provides full URL with domain name. Also calls
     * `Asset.assetTimestamp()` to add timestamp to local files.
     * Params:
     * string aPath Path string.
     * @param IData[string] options Options array. Possible keys:
     *  `fullBase` Return full URL with domain name
     *  `pathPrefix` Path prefix for relative URLs
     *  `plugin` False value will prevent parsing path as a plugin
     *  `timestamp` Overrides the value of `Asset.timestamp` in Configure.
     *       Set to false to skip timestamp generation.
     *       Set to true to apply timestamps when debug is true. Set to "force" to always
     *       enable timestamping regardless of debug value.
     * /
    static string imageUrl(string aPath, IData[string] options = null) {
        somePathPrefix = Configure.read("App.imageBaseUrl");

        return url(somePath, options + compact("pathPrefix"));
    }
    
    /**
     * Generates URL for given CSS file.
     *
     * Depending on options passed provides full URL with domain name. Also calls
     * `Asset.assetTimestamp()` to add timestamp to local files.
     * Params:
     * string aPath Path string.
     * @param IData[string] options Options array. Possible keys:
     *  `fullBase` Return full URL with domain name
     *  `pathPrefix` Path prefix for relative URLs
     *  `ext` Asset extension to append
     *  `plugin` False value will prevent parsing path as a plugin
     *  `timestamp` Overrides the value of `Asset.timestamp` in Configure.
     *       Set to false to skip timestamp generation.
     *       Set to true to apply timestamps when debug is true. Set to "force" to always
     *       enable timestamping regardless of debug value.
     * /
    static string cssUrl(string aPath, IData[string] options = null) {
        somePathPrefix = Configure.read("App.cssBaseUrl");
        ext = ".css";

        return url(somePath, options + compact("pathPrefix", "ext"));
    }
    
    /**
     * Generates URL for given javascript file.
     *
     * Depending on options passed provides full URL with domain name. Also calls
     * `Asset.assetTimestamp()` to add timestamp to local files.
     * Params:
     * string aPath Path string.
     * @param IData[string] options Options array. Possible keys:
     *  `fullBase` Return full URL with domain name
     *  `pathPrefix` Path prefix for relative URLs
     *  `ext` Asset extension to append
     *  `plugin` False value will prevent parsing path as a plugin
     *  `timestamp` Overrides the value of `Asset.timestamp` in Configure.
     *       Set to false to skip timestamp generation.
     *       Set to true to apply timestamps when debug is true. Set to "force" to always
     *       enable timestamping regardless of debug value.
     * /
    static string scriptUrl(string aPath, IData[string] options = null) {
        somePathPrefix = Configure.read("App.jsBaseUrl");
        auto assetExtension = ".js";

        return url(somePath, options + compact("pathPrefix", assetExtension));
    }
    
    /**
     * Generates URL for given asset file.
     *
     * Depending on options passed provides full URL with domain name. Also calls
     * `Asset.assetTimestamp()` to add timestamp to local files.
     *
     * ### Options:
     *
     * - `fullBase` Boolean true or a string (e.g. https://example) to
     *   return full URL with protocol and domain name.
     * - `pathPrefix` Path prefix for relative URLs
     * - `ext` Asset extension to append
     * - `plugin` False value will prevent parsing path as a plugin
     * - `theme` Optional theme name
     * - `timestamp` Overrides the value of `Asset.timestamp` in Configure.
     *   Set to false to skip timestamp generation.
     *   Set to true to apply timestamps when debug is true. Set to "force" to always
     *   enable timestamping regardless of debug value.
     * Params:
     * string aPath Path string or URL array
     * @param IData[string] options Options array.
     * /
    static string url(string aPath, IData[string] options = null) {
        if (preg_match("/^data:[a-z]+\/[a-z]+;/", somePath)) {
            return somePath;
        }
        if (somePath.has("://") || preg_match("/^[a-z]+:/i", somePath)) {
            return ltrim(Router.url(somePath), "/");
        }
        if (!array_key_exists("plugin", options) || options["plugin"] != false) {
            [plugin, somePath] = pluginSplit(somePath);
        }
        if (!empty(options["pathPrefix"]) && somePath[0] != "/") {
            somePathPrefix = options["pathPrefix"];
            placeHolderVal = "";
            if (!empty(options["theme"])) {
                placeHolderVal = inflectString(options["theme"]) ~ "/";
            } else if (isSet(plugin)) {
                placeHolderVal = inflectString(plugin) ~ "/";
            }
            somePath = .replace("{plugin}", placeHolderVal, somePathPrefix) ~ somePath;
        }
        if (
            !empty(options["ext"]) &&
            !somePath.has("?") &&
            !somePath.endsWith(options["ext"])
        ) {
            somePath ~= options["ext"];
        }
        // Check again if path has protocol as `pathPrefix` could be for CDNs.
        if (preg_match("|^([a-z0-9]+:)?//|", somePath)) {
            return Router.url(somePath);
        }
        if (isSet(plugin)) {
            somePath = inflectString(plugin) ~ "/" ~ somePath;
        }
        optionTimestamp = null;
        if (array_key_exists("timestamp", options)) {
            optionTimestamp = options["timestamp"];
        }
        webPath = assetTimestamp(
            webroot(somePath, options),
            optionTimestamp
        );

        somePath = encodeUrl(webPath);

        if (!empty(options["fullBase"])) {
            fullBaseUrl = isString(options["fullBase"])
                ? options["fullBase"]
                : Router.fullBaseUrl();
            somePath = rtrim(fullBaseUrl, "/") ~ "/" ~ ltrim(somePath, "/");
        }
        return somePath;
    }
    
    /**
     * Encodes URL parts using rawurlencode().
     * Params:
     * string aurl The URL to encode.
     * /
    protected static string encodeUrl(string urlToEncode) {
        auto somePath = parse_url(urlToEncode, UIM_URL_PATH);
        if (somePath == false || somePath is null) {
            somePath = urlToEncode;
        }
        auto someParts = array_map("rawurldecode", somePath.split("/"));
        someParts = array_map("rawurlencode", someParts);
        
        string encoded = someParts.join("/");
        return urlToEncode.replace(somePath, encoded);
    }
    
    /**
     * Adds a timestamp to a file based resource based on the value of `Asset.timestamp` in
     * Configure. If Asset.timestamp is true and debug is true, or Asset.timestamp == "force"
     * a timestamp will be added.
     * Params:
     * string aPath The file path to timestamp, the path must be inside `App.wwwRoot` in Configure.
     * @param string|bool timestamp If set will overrule the value of `Asset.timestamp` in Configure.
     * /
    static string assetTimestamp(string aPath, string|bool|null timestamp = null) {
        if (somePath.has("?")) {
            return somePath;
        }
        timestamp ??= Configure.read("Asset.timestamp");
        timestampEnabled = timestamp == "force" || (timestamp == true && Configure.read("debug"));
        if (timestampEnabled) {
            filepath = (string)preg_replace(
                "/^" ~ preg_quote(requestWebroot(), "/") ~ "/",
                "",
                urldecode(somePath)
            );
            webrootPath = Configure.read("App.wwwRoot") ~ filepath.replace("/", DIRECTORY_SEPARATOR);
            if (isFile(webrootPath)) {
                return somePath ~ "?" ~ filemtime(webrootPath);
            }
            // Check for plugins and org prefixed plugins.
            segments = split("/", ltrim(filepath, "/"));
            plugin = Inflector.camelize(segments[0]);
            if (!Plugin.isLoaded(plugin) && count(segments) > 1) {
                string plugin = join("/", [plugin, Inflector.camelize(segments[1])]);
                unset(segments[1]);
            }
            if (Plugin.isLoaded(plugin)) {
                unset(segments[0]);
                pluginPath = Plugin.path(plugin)
                    ~ "webroot"
                    ~ DIRECTORY_SEPARATOR
                    ~ join(DIRECTORY_SEPARATOR, segments);
                if (isFile(pluginPath)) {
                    return somePath ~ "?" ~ filemtime(pluginPath);
                }
            }
        }
        return somePath;
    }
    
    /**
     * Checks if a file exists when theme is used, if no file is found default location is returned.
     *
     * ### Options:
     *
     * - `theme` Optional theme name
     * Params:
     * string afile The file to create a webroot path to.
     * @param IData[string] options Options array.
     * /
    static string webroot(string afile, IData[string] options = null) {
        options = options.update["theme": null];
        requestWebroot = requestWebroot();

        string[] asset = file.split("?");
        asset[1] = isSet(asset[1]) ? "?" ~ asset[1] : "";
        webPath = requestWebroot ~ asset[0];
        file = asset[0];

        themeName = options["theme"];
        if (themeName) {
            file = trim(file, "/");
            theme = inflectString(themeName) ~ "/";

            if (DIRECTORY_SEPARATOR == "\\") {
                file = file.replace("/", "\\");
            }
            if (isFile(Configure.read("App.wwwRoot") ~ theme ~ file)) {
                webPath = requestWebroot ~ theme ~ asset[0];
            } else {
                themePath = Plugin.path(themeName);
                somePath = themePath ~ "webroot/" ~ file;
                if (isFile(somePath)) {
                    webPath = requestWebroot ~ theme ~ asset[0];
                }
            }
        }
        if (webPath.has("//")) {
            return (webPath ~ asset[1]).replace("//", "/");
        }
        return webPath ~ asset[1];
    }
    
    /**
     * Inflect the theme/plugin name to type set using `Asset.setInflectionType()`.
     * Params:
     * string astring String inflected.
     * /
    protected static string inflectString(string astring) {
        return Inflector.{anInflectionType}(string);
    }
    
    /**
     * Get webroot from request.
     * /
    protected static string requestWebroot() {
        request = Router.getRequest();
        if (request is null) {
            return "/";
        }
        return request.getAttribute("webroot");
    }
    
    /**
     * Splits a dot syntax plugin name into its plugin and filename.
     * If name does not have a dot, then index 0 will be null.
     * It checks if the plugin is loaded, else filename will stay unchanged for filenames containing dot.
     * Params:
     * string aName The name you want to plugin split.
     * /
    protected static array pluginSplit(string aName) {
        plugin = null;
        [first, second] = pluginSplit(name);
        if (first && Plugin.isLoaded(first)) {
            name = second;
            plugin = first;
        }
        return [plugin, name];
    } */
}
