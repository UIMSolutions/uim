/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.views.helpers.url;

import uim.views;

@safe:

// UrlHelper class for generating URLs.
class UrlHelper : DHelper {
  mixin(HelperThis!("Url"));

  // Asset URL engine class name
  protected string _assetUrlclassname;

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    // auto myengineClassConfig = configurationData.hasKey("assetUrlclassname");

    /** @var class-string<\UIM\Routing\Asset>|null myengineClass * /
        auto myengineClass = App.classname(myengineClassConfig, "Routing");
        if (myengineClass.isNull) {
            throw new UIMException("Class for `%s` could not be found.".format(myengineClassConfig));
        }

        _assetUrlclassname = myengineClass;
        configuration.setDefault("assetUrlclassname", Asset.classname);
        */
    return true;
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
  static string build(string[] myurl = null, Json[string] options = new Json[string]) {
    /*         options
            .merge("fullBase", false)
            .merge("escape", true);

 */
    string buildUrl;
    /*        auto myurl = Router.url(myurl, options.get("fullBase"));
        if (options.getBoolean("escape")) {
            myurl = to!string(h(myurl));
        } */
    return buildUrl;
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
  static string buildFromPath(string routePath, Json[string] params = null, Json[string] options = new Json[string]) {
    /*         return _build(["_path": routePath] + params, options); */
    return null;
  }

  /**
     * Generates URL for given image file.
     *
     * Depending on options passed provides full URL with domain name. Also calls
     * `Helper.assetTimestamp()` to add timestamp to local files.
     */
  static string image(string path, Json[string] options = new Json[string]) {
    /*         options.merge("theme", _view.theme());
        return htmlAttributeEscape(
            _assetUrlclassname.imageUrl(path, options)); */
    return null;
  }

  /**
     * Generates URL for given CSS file.
     *
     * Depending on options passed provides full URL with domain name. Also calls
     * `Helper.assetTimestamp()` to add timestamp to local files.
     */
  static string css(string path, Json[string] options = new Json[string]) {
/*     options.merge("theme", _view.theme());
    return htmlAttributeEscape(_assetUrlclassname.cssUrl(path, options));
 */    return null;
  }

  /**
     * Generates URL for given javascript file.
     *
     * Depending on options passed provides full URL with domain name. Also calls
     * `Helper.assetTimestamp()` to add timestamp to local files.
     */
  static string script(string path, Json[string] options = new Json[string]) {
    /*         auto options = options.set("theme", _view.theme());
        return htmlAttributeEscape(
            _assetUrlclassname.scriptUrl(path, options)); */
    return null;
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
     */
  static string assetUrl(string path, Json[string] options = new Json[string]) {
    /* options
            .merge("theme", _view.theme()); */

    // return htmlAttributeEscape(_assetUrlclassname.url(path, options));
    return null;
  }

  /**
     * Adds a timestamp to a file based resource based on the value of `Asset.timestamp` in
     * Configure. If Asset.timestamp is true and debug is true, or Asset.timestamp == "force"
     * a timestamp will be added.
     */
  static string assetTimestamp(string path, string timestamp = null) {
    /*         return htmlAttributeEscape(
            _assetUrlclassname.assetTimestamp(path, timestamp)); */
    return null;
  }

  // Checks if a file exists when theme is used, if no file is found default location is returned
  static string webroot(string filename) {
    /*         options.merge("theme", _view.theme());
        return htmlAttributeEscape(
            _assetUrlclassname.webroot(filename, options)); */
    return null;
  }
}
