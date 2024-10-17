/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.routings.classes.asset;

import uim.routings;

@safe:

// Class for generating asset URLs.
class DAsset {
    // Inflection type.
    protected static string _inflectionType = "underscore";

    /**
     * Set inflection type to use when inflecting plugin/theme name.
     * Params:
     * string ainflectionType Inflection type. Value should be a valid
     * method name of `Inflector` class like `"dasherize"` or `"underscore`"`.
     */
    static void setInflectionType(string anInflectionType) {
        _inflectionType = anInflectionType;
    }
    
    /**
     * Generates URL for given image file.
     *
     * Depending on options passed provides full URL with domain name. Also calls
     * `Asset.assetTimestamp()` to add timestamp to local files.
     */
    static string imageUrl(string path, Json[string] options = null) {
        return url(path, options.merge(createMap!(string, Json)
            .set("pathPrefix", configuration.get("App.imageBaseUrl"))));
    }
    
    /**
     * Generates URL for given CSS file.
     *
     * Depending on options passed provides full URL with domain name. Also calls
     * `Asset.assetTimestamp()` to add timestamp to local files.
     */
    static string cssUrl(string path, Json[string] options = null) {
        return url(path, options.merge(createMap!(string, Json)
            .set("pathPrefix", configuration.get("App.cssBaseUrl"))
            .set("ext", ".css")));
    }
    
    /**
     * Generates URL for given javascript file.
     *
     * Depending on options passed provides full URL with domain name. Also calls
     * `Asset.assetTimestamp()` to add timestamp to local files.
     */
    static string scriptUrl(string path, Json[string] options = null) {
        return url(path, options.merge(createMap!(string, Json)
            .set("pathPrefix", configuration.get("App.jsBaseUrl"))
            .set("assetExtension", ".js")));
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
     *  return full URL with protocol and domain name.
     * - `pathPrefix` Path prefix for relative URLs
     * - `ext` Asset extension to append
     * - `plugin` False value will prevent parsing path as a plugin
     * - `theme` Optional theme name
     * - `timestamp` Overrides the value of `Asset.timestamp` in Configure.
     *  Set to false to skip timestamp generation.
     *  Set to true to apply timestamps when debug is true. Set to "force" to always
     *  enable timestamping regardless of debug value.
     */
    static string url(string urlPath, Json[string] options = null) {
        /* if (preg_match("/^data:[a-z]+\/[a-z]+;/", somePath)) {
            return somePath;
        }
        if (somePath.contains(": //") || preg_match("/^[a-z]+:/i", somePath)) {
            return stripLeft(Router.url(somePath), "/");
        }
        if (!hasKey("plugin", options) || options.get("plugin") == true) {
            [plugin, somePath] = pluginSplit(somePath);
        } */
        /* if (options.hasKey("pathPrefix") && somePath[0] != "/") {
            somePathPrefix = options.get("pathPrefix");
            placeHolderVal = "";
            /* if (options.hasKey("theme")) {
                placeHolderVal = inflectString(options.getString("theme")) ~ "/";
            } else if (plugin !is null) {
                placeHolderVal = inflectString(plugin) ~ "/";
            }
            somePath = .replace("{plugin}", placeHolderVal, somePathPrefix) ~ somePath; * /
        } */
        if (
            options.hasKey("ext") &&
            !somePath.contains("?") &&
            !somePath.endsWith(options.getString("ext"))
       ) {
            somePath ~= options.getString("ext");
        }
        // Check again if path has protocol as `pathPrefix` could be for CDNs.
        if (preg_match("|^([a-z0-9]+:)?//|", somePath)) {
            return Router.url(somePath);
        }
        /* if (plugin !is null) {
            somePath = inflectString(plugin) ~ "/" ~ somePath;
        } */
        auto optionTimestamp = null;
        if (hasKey("timestamp", options)) {
            optionTimestamp = options.get("timestamp");
        }
        auto webPath = assetTimestamp(
            webroot(somePath, options),
            optionTimestamp
       );

        auto somePath = encodeUrl(webPath);
        if (options.hasKey("fullBase")) {
            fullBaseUrl = options.isString("fullBase")
                ? options.getString("fullBase")
                : Router.fullBaseUrl();
            somePath = fullBaseUrl.stripRight("/") ~ "/" ~ somePath.stripLeft("/");
        }
        return somePath;
    }
    
    // Encodes URL parts using rawUrlEncode().
    protected static string encodeUrl(string urlToEncode) {
        auto somePath = parse_url(urlToEncode, UIM_URL_PATH);
        if (somePath == false || somePath.isNull) {
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
     */
    static string assetTimestamp(string timestampPath, string timestamp = null) {
        if (somePath.contains("?")) {
            return somePath;
        }
        auto timestamp = timestamp.ifNull(configuration.getString("Asset.timestamp"));
        auto timestampEnabled = timestamp == "force" || (timestamp == true && configuration.get("debug"));
        if (timestampEnabled) {
            string filepath = /* (string) */preg_replace(
                "/^" ~ preg_quote(requestWebroot(), "/") ~ "/", "", urldecode(somePath)
           );
            
            string webrootPath = configuration.getString("App.wwwRoot") ~ filepath.replace("/", DIRECTORY_SEPARATOR);
            if (isFile(webrootPath)) {
                return somePath ~ "?" ~ filemtime(webrootPath);
            }
            // Check for plugins and org prefixed plugins.
            string[] segments = stripLeft(filepath, "/").split("/");
            plugin = Inflector.camelize(segments[0]);
            if (!Plugin.isLoaded(plugin) && count(segments) > 1) {
                string plugin = join("/", [plugin, segments[1].camelize]);
                removeKey(segments[1]);
            }
            if (Plugin.isLoaded(plugin)) {
                removeKey(segments[0]);
                auto pluginPath = Plugin.path(plugin)
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
     * - `theme` Optional theme name
     */
    static string webroot(string fileName, Json[string] options = null) {
        auto options = options.merge(["theme": Json(null)]);
        auto requestWebroot = requestWebroot();

        string[] asset = fileName.split("?");
        asset[1] = asset.has(1) ? "?" ~ asset[1] : "";
        webPath = requestWebroot ~ asset[0];
        auto file = asset[0];

        auto themeName = options.getString("theme");
        if (themeName) {
            file = file.strip("/");
            auto theme = inflectString(themeName) ~ "/";

            if (DIRECTORY_SEPARATOR == "\\") {
                file = file.replace("/", "\\");
            }
            if (isFile(configuration.getString("App.wwwRoot") ~ theme ~ file)) {
                webPath = requestWebroot ~ theme ~ asset[0];
            } else {
                themePath = Plugin.path(themeName);
                somePath = themePath ~ "webroot/" ~ file;
                if (isFile(somePath)) {
                    webPath = requestWebroot ~ theme ~ asset[0];
                }
            }
        }
        return webPath.contains("//")
            ? (webPath ~ asset[1]).replace("//", "/")
            : webPath ~ asset[1];
    }
    
    // Inflect the theme/plugin name to type set using `Asset.setInflectionType()`.
    protected static string inflectString(string inflectedString) {
        // return Inflector.{anInflectionType}(inflectedString);
        return null; 
    }
    
    // Get webroot from request.
    protected static string requestWebroot() {
        request = Router.getRequest();
        return request.isNull
            ? "/"
            : request.getAttribute("webroot");
    }
    
    /**
     * Splits a dot syntax plugin name into its plugin and filename.
     * If name does not have a dot, then index 0 will be null.
     * It checks if the plugin is loaded, else filename will stay unchanged for filenames containing dot.
     */
    protected static Json[string] pluginSplit(string nameToSplit) {
        auto plugin = null;
        [first, second] = pluginSplit(nameToSplit);
        if (first && Plugin.isLoaded(first)) {
            name = second;
            plugin = first;
        }
        return [plugin, name];
    }
}
