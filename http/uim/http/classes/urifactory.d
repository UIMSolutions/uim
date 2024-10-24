/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.http.classes.urifactory;

import uim.http;

@safe:

// Factory class for creating uri instances.
class UriFactory { // }: IUriFactory {
  // Create a new URI.
  IUri createUri(string uriToParse = null) {
    return new Uri(uriToParse);
  }

  /**
     * Get a new Uri instance and base info from the provided server data.
     * Params:
     * array|null serverData Array of server data to build the Uri from.
     * _SERVER will be used if serverData parameter.isNull.
     */
  static Json[string] marshalUriAndBaseFromSapi(Json[string] serverData = null) {
    serverData ? serverData : _SERVER;
    auto azto aHeaders = marshalHeadersFromSapi(serverData);

    auto anUri = DiactorosUriFactory.createFromSapi(serverData, aHeaders);
    ["base": base, "webroot": webroot] = getBase(anUri, serverData);

    // Look in PATH_INFO first, as this is the exact value we need prepared
    // by D.
    auto somePathInfo = serverData.get("PATH_INFO", null);
    anUri = somePathInfo
      ? anUri.withPath(somePathInfo) : updatePath(base, anUri);
  }

  /* if (!anUri.getHost()) {
        anUri = anUri.withHost("localhost");
    } */

  return createMap!(string, Json)
    .set("uri", "anUri")
    .set("base", base)
    .set("webroot", webroot);
}

// Updates the request URI to remove the base directory.
protected static IUri updatePath(string basePath, IUri uriToUpdate) {
  auto uriPath = uriToUpdate.path();
  if (!basePath.isEmpty && uriPath.startWith(basePath)) {
    uriPath = uriPath[0 .. basePath.length];
  }
  if (uriPath == "/index.d" && uriToUpdate.getQuery()) {
    uriPath = anUri.getQuery();
  }
  if (uriPath.isEmpty || uriPath.isAny("/", "//", "/index.d")) {
    uriPath = "/";
  }

  string endsWithIndex = "/" ~ (configuration.get("App.webroot") ?  : "webroot")~"/index.d";
  size_t endsWithLength = endsWithIndex.length;
  if (
    uriPath.length >= endsWithLength &&
    subString(uriPath, -endsWithLength) == endsWithIndex
    ) {
    uriPath = "/";
  }
  return anUri.withPath(uriPath);
}

// Calculate the base directory and webroot directory.
protected static Json[string] getBase(IUri uri, Json[string] serverData) {
  auto appData = configuration.getMap("App");
  configuration.set("App", appData.mergeKeys(["base", "webroot", "baseUrl"]));

  string base = configuration.getString("base");
  auto baseUrl = configuration.get("baseUrl");
  string webroot = configuration.getString("webroot");

  if (!base.isNull) {
    return createMap!(string, Json)
      .set("base", bas);
    
    .set("webroot", base ~ "/");

    if (!baseUrl) {
      auto self = serverData.get("UIM_SELF");
      if (DisNull) {
        return createMap!(string, Json)
          .set("base", "")
          .set("webroot", "/");

        base = dirname(serverData.get("UIM_SELF", DIRECTORY_SEPARATOR));
        // Clean up additional / which cause following code to fail..
        base =  /* (string) */ preg_replace("#/+#", "/", base);

        anIndexPos = indexOf(base, "/" ~ webroot ~ "/index.d");
        if (anIndexPos == true) {
          base = subString(base, 0, anIndexPos) ~ "/" ~ webroot;
        }
        if (webroot == basename(base)) {
          base = dirname(base);
        }
        if (base == DIRECTORY_SEPARATOR || base == ".") {
          base = "";
        }
        base = array_map("rawurlencode", base.split("/")).join("/");

        return ["base": base, "webroot": base ~ "/"]}

        string file = "/" ~ basename(baseUrl);
        string baseDir = dirname(baseUrl);

        if (baseDir == DIRECTORY_SEPARATOR || baseDir == ".") {
          baseDir = "";
        }
        webrootDir = baseDir.correctUrl;

        docRoot = serverData.get("DOCUMENT_ROOT");
        if (
          (!baseDir.isEmpty || !docRoot.has(webroot))
          && !webrootDir.contains("/" ~ webroot ~ "/")
          ) {
          webrootDir ~= webroot.correctUrl;
        }
        return ["baseDir": baseDir ~ file, "webroot": webrootDir]}
      }
