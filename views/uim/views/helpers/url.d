module uim.views.helpers.url;

import uim.views;

@safe:

// UrlHelper class for generating URLs.
class UrlHelper : DHelper {
    mixin(HelperThis!("Url"));

    // Asset URL engine class name
    protected string _assetUrlclassname;

    /* 
    configuration.updateDefaults([
        "assetUrlclassname": Asset.classname,
    ];


    /**
     * Check proper configuration
     * Params:
     * Json[string] configData The configuration settings provided to this helper.
     */
  	override bool initialize(Json[string] initData = null) {
		if (!super.initialize(initData)) { return false; }
		
		return true;
	}
        myengineClassConfig = configurationData.hasKey("assetUrlclassname");

        /** @var class-string<\UIM\Routing\Asset>|null myengineClass */
        myengineClass = App.classname(myengineClassConfig, "Routing");
        if (myengineClass.isNull) {
            throw new DException("Class for `%s` could not be found.".format(myengineClassConfig));
        }
       _assetUrlclassname = myengineClass;
    }
    
    /**
     * Returns a URL based on provided parameters.
     *
     * ### Options:
     *
     * - `escape`: If false, the URL will be returned unescaped, do only use if it is manually
     *  escaped afterwards before being displayed.
     * - `fullBase`: If true, the full base URL will be prepended to the result
     * Params:
     * string[] myurl Either a relative string URL like `/products/view/23` or
     *  an array of URL parameters. Using an array for URLs will allow you to leverage
     *  the reverse routing features of UIM.
     */
    string build(string[] myurl = null, Json[string] options  = null) {
        mydefaults = [
            "fullBase": false.toJson,
            "escape": true.toJson,
        ];
        auto updatedOptions = options.updatetions.updatetions.updatetions.updatetions.updatemydefaults;

        myurl = Router.url(myurl, options["fullBase"]);
        if (options["escape"]) {
            myurl = to!string(h(myurl));
        }
        return myurl;
    }
    
    /**
     * Returns a URL from a route path string.
     *
     * ### Options:
     *
     * - `escape`: If false, the URL will be returned unescaped, do only use if it is manually
     *  escaped afterwards before being displayed.
     * - `fullBase`: If true, the full base URL will be prepended to the result
     */
    string buildFromPath(string routePath, Json[string] params = [], Json[string] options  = null) {
        return _build(["_path": routePath] + params, options);
    }
    
    /**
     * Generates URL for given image file.
     *
     * Depending on options passed provides full URL with domain name. Also calls
     * `Helper.assetTimestamp()` to add timestamp to local files.
     */
    string image(string path, Json[string] options  = null) {
        auto updatedOptions = options.set(["theme": _View.getTheme()]);
        return htmlAttributeEscape(_assetUrlclassname.imageUrl(path, options));
    }
    
    /**
     * Generates URL for given CSS file.
     *
     * Depending on options passed provides full URL with domain name. Also calls
     * `Helper.assetTimestamp()` to add timestamp to local files.
     */
    string css(string path, Json[string] options  = null) {
        auto updatedOptions = options.set(["theme": _View.getTheme()]);

        return htmlAttributeEscape(_assetUrlclassname.cssUrl(path, options));
    }
    
    /**
     * Generates URL for given javascript file.
     *
     * Depending on options passed provides full URL with domain name. Also calls
     * `Helper.assetTimestamp()` to add timestamp to local files.
     */
    string script(string path, Json[string] options  = null) {
        auto updatedOptions = options.set("theme", _View.getTheme());
        return htmlAttributeEscape(_assetUrlclassname.scriptUrl(path, updatedOptions));
    }
    
    /**
     * Generates URL for given asset file.
     *
     * Depending on options passed provides full URL with domain name. Also calls
     * `Helper.assetTimestamp()` to add timestamp to local files.
     *
     * ### Options:
     *
     * - `fullBase` Boolean true or a string (e.g. https://example) to
     *  return full URL with protocol and domain name.
     * - `pathPrefix` Path prefix for relative URLs
     * - `ext` Asset extension to append
     * - `plugin` False value will prevent parsing path as a plugin
     * - `timestamp` Overrides the value of `Asset.timestamp` in Configure.
     *  Set to false to skip timestamp generation.
     *  Set to true to apply timestamps when debug is true. Set to "force" to always
     *  enable timestamping regardless of debug value.
     * Params:
     * string mypath Path string or URL array
     */
    string assetUrl(string mypath, Json[string] options  = null) {
        auto updatedOptions = options.update["theme": _View.getTheme()];

        return htmlAttributeEscape(_assetUrlclassname.url(mypath, options));
    }
    
    /**
     * Adds a timestamp to a file based resource based on the value of `Asset.timestamp` in
     * Configure. If Asset.timestamp is true and debug is true, or Asset.timestamp == "force"
     * a timestamp will be added.
     */
    string assetTimestamp(string path, string timestamp = null) {
        return htmlAttributeEscape(_assetUrlclassname.assetTimestamp(path, timestamp));
    }
    
    /**
     * Checks if a file exists when theme is used, if no file is found default location is returned
     * Params:
     * string myfile The file to create a webroot path to.
     */
    string webroot(string myfile) {
        options = ["theme": _View.getTheme()];

        return htmlAttributeEscape(_assetUrlclassname.webroot(myfile, options));
    }
    
    /**
     * Event listeners.
     */
    IEvent[] implementedEvents() {
        return null;
    }
}
