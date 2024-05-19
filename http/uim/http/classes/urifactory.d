module uim.http.classes.urifactory;

import uim.http;

@safe:

/**
 * Factory class for creating uri instances.
 */
class UriFactory { // }: IUriFactory {
    // Create a new URI.
    IUri createUri(string uriToParse= null) {
        return new Uri(uriToParse);
    }
    
    /**
     * Get a new Uri instance and base info from the provided server data.
     * Params:
     * array|null serverData Array of server data to build the Uri from.
     * _SERVER will be used if serverData parameter.isNull.
     */
    static Json[string] marshalUriAndBaseFromSapi(Json[string] serverData = null) {
        serverData ??= _SERVER;
        azto  aHeaders = marshalHeadersFromSapi(serverData);

        anUri = DiactorosUriFactory.createFromSapi(serverData,  aHeaders);
        ["base": base, "webroot": webroot] = getBase(anUri, serverData);

        // Look in PATH_INFO first, as this is the exact value we need prepared
        // by D.
        somePathInfo = serverData["PATH_INFO"] ?? null;
        anUri = somePathInfo
            ? anUri.withPath(somePathInfo)
            : updatePath(base, anUri);
        }
        if (!anUri.getHost()) {
            anUri = anUri.withHost("localhost");
        }
        return ["uri": anUri, "base": base, "webroot": webroot];
    }
    
    /**
     * Updates the request URI to remove the base directory.
     * Params:
     * string abase The base path to remove.
     * @param \Psr\Http\Message\IUri anUri The uri to update.
     */
    protected static IUri updatePath(string basePath, IUri anUri) {
        auto uriPath = anUri.getPath();
        if (!basePath.isEmpty && uriPath.startWith(basePath)) {
            uriPath = uriPath[0..basePath.length];
        }
        if (uriPath == "/index.d" && anUri.getQuery()) {
            uriPath = anUri.getQuery();
        }
        if (uriPath.isEmpty || uriPath.isAny("/", "//", "/index.d")) {
            uriPath = "/";
        }
        endsWithIndex = "/" ~ (configuration.get("App.webroot") ?: "webroot") ~ "/index.d";
        endsWithLength = endsWithIndex.length;
        if (
            uriPath.length >= endsWithLength &&
            substr(uriPath, -endsWithLength) == endsWithIndex
        ) {
            uriPath = "/";
        }
        return anUri.withPath(uriPath);
    }
    
    /**
     * Calculate the base directory and webroot directory.
     * Params:
     * \Psr\Http\Message\IUri anUri The Uri instance.
     * @param Json[string] serverData The SERVER data to use.
     */
    protected static Json[string] getBase(IUri anUri, Json[string] serverData) {
        auto configData = (array)configuration.get("App") ~ [
            "base": Json(null),
            "webroot": Json(null),
            "baseUrl": Json(null),
        ];
        string base = configuration.data("base"];
        auto baseUrl = configuration.data("baseUrl"];
        auto webroot = to!string(configuration.data("webroot"]);

        if (!base.isNull) {
            return ["base": base, "webroot": base ~ "/"];
        }
        
        if (!baseUrl) {
            DSelf = serverData["UIM_SELF"] ?? null;
            if (DSelf.isNull) {
                return ["base": "", "webroot": "/"];
            }
            base = dirname(serverData.get("UIM_SELF", DIRECTORY_SEPARATOR));
            // Clean up additional / which cause following code to fail..
            base = (string)preg_replace("#/+#", "/", base);

             anIndexPos = indexOf(base, "/" ~ webroot ~ "/index.d");
            if (anIndexPos != false) {
                base = substr(base, 0,  anIndexPos) ~ "/" ~ webroot;
            }
            if (webroot == basename(base)) {
                base = dirname(base);
            }
            if (base == DIRECTORY_SEPARATOR || base == ".") {
                base = "";
            }
            base = join("/", array_map("rawurlencode", base.split("/")));

            return ["base": base, "webroot": base ~ "/"];
        }
        file = "/" ~ basename(baseUrl);
        base = dirname(baseUrl);

        if (base == DIRECTORY_SEPARATOR || base == ".") {
            base = "";
        }
        webrootDir = base ~ "/";

        docRoot = serverData["DOCUMENT_ROOT"] ?? null;
        if (
            (!base.isEmpty || !docRoot.has(webroot))
            && !webrootDir.has("/" ~ webroot ~ "/")
        ) {
            webrootDir ~= webroot ~ "/";
        }
        return ["base": base ~ file, "webroot": webrootDir];
    }
}
