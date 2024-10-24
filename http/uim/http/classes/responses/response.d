/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.http.classes.responses.response;

import uim.http;

@safe:

/**
 * Responses contain the response text, status and headers of a HTTP response.
 *
 * There are external packages such as `fig/http-message-util` that provide HTTP
 * status code constants. These can be used with any method that accepts or
 * returns a status code integer. Keep in mind that these constants might
 * include status codes that are now allowed which will throw an
 * `\InvalidArgumentException`.
 */
class DResponse : UIMObject, IResponse {
  mixin TMessage;

  const int STATUS_CODE_MIN = 100;

  const int STATUS_CODE_MAX = 599;

  // Allowed HTTP status codes and their default description.
  protected string[int] _statusCodes = [
    100: "Continue",
    101: "switching Protocols",
    102: "Processing",
    200: "OK",
    201: "Created",
    202: "Accepted",
    203: "Non-Authoritative Information",
    204: "No Content",
    205: "Reset Content",
    206: "Partial Content",
    207: "Multi-status",
    208: "Already Reported",
    226: "IM used",
    300: "Multiple Choices",
    301: "Moved Permanently",
    302: "Found",
    303: "see Other",
    304: "Not Modified",
    305: "Use Proxy",
    306: "(Unused)",
    307: "Temporary Redirect",
    308: "Permanent Redirect",
    400: "Bad Request",
    401: "Unauthorized",
    402: "Payment Required",
    403: "Forbidden",
    404: "Not Found",
    405: "Method Not Allowed",
    406: "Not Acceptable",
    407: "Proxy Authentication Required",
    408: "Request Timeout",
    409: "Conflict",
    410: "Gone",
    411: "Length Required",
    412: "Precondition Failed",
    413: "Request Entity Too Large",
    414: "Request-URI Too Large",
    415: "Unsupported Media Type",
    416: "Requested range not satisfiable",
    417: "Expectation Failed",
    418: "I\"m a teapot",
    421: "Misdirected Request",
    422: "Unprocessable Entity",
    423: "Locked",
    424: "Failed Dependency",
    425: "Unordered Collection",
    426: "Upgrade Required",
    428: "Precondition Required",
    429: "Too Many Requests",
    431: "Request Header Fields Too Large",
    444: "Connection Closed Without Response",
    451: "Unavailable For Legal Reasons",
    499: "Client Closed Request",
    500: "Internal Server Error",
    501: "Not Implemented",
    502: "Bad Gateway",
    503: "service Unavailable",
    504: "Gateway Timeout",
    505: "Unsupported Version",
    506: "Variant Also Negotiates",
    507: "Insufficient Storage",
    508: "Loop Detected",
    510: "Not Extended",
    511: "Network Authentication Required",
    599: "Network Connect Timeout Error",
  ];

  // Holds type key to mime type mappings for known mime types.
  protected STRINGAA _mimeTypes = [
    "html": ["text/html", "*/*"],
    "Json": "application/Json",
    "xml": ["application/xml", "text/xml"],
    "xhtml": ["application/xhtml+xml", "application/xhtml", "text/xhtml"],
    "webp": "image/webp",
    "rss": "application/rss+xml",
    "ai": "application/postscript",
    "bcpio": "application/x-bcpio",
    "bin": "application/octet-stream",
    "ccad": "application/clariscad",
    "cdf": "application/x-netcdf",
    "class": "application/octet-stream",
    "cpio": "application/x-cpio",
    "cpt": "application/mac-compactpro",
    "csh": "application/x-csh",
    "csv": ["text/csv", "application/vnd.ms-excel"],
    "dcr": "application/x-director",
    "dir": "application/x-director",
    "dms": "application/octet-stream",
    "doc": "application/msword",
    "docx": "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
    "drw": "application/drafting",
    "dvi": "application/x-dvi",
    "dwg": "application/acad",
    "dxf": "application/dxf",
    "dxr": "application/x-director",
    "eot": "application/vnd.ms-fontobject",
    "eps": "application/postscript",
    "exe": "application/octet-stream",
    "ez": "application/andrew-inset",
    "flv": "video/x-flv",
    "gtar": "application/x-gtar",
    "gz": "application/x-gzip",
    "bz2": "application/x-bzip",
    "7z": "application/x-7z-compressed",
    "hal": ["application/hal+xml", "application/vnd.hal+xml"],
    "halJson": ["application/hal+Json", "application/vnd.hal+Json"],
    "halxml": ["application/hal+xml", "application/vnd.hal+xml"],
    "hdf": "application/x-hdf",
    "hqx": "application/mac-binhex40",
    "ico": "image/x-icon",
    "ips": "application/x-ipscript",
    "ipx": "application/x-ipix",
    "js": "application/javascript",
    "Jsonapi": "application/vnd.api+Json",
    "latex": "application/x-latex",
    "Jsonld": "application/ld+Json",
    "kml": "application/vnd.google-earth.kml+xml",
    "kmz": "application/vnd.google-earth.kmz",
    "lha": "application/octet-stream",
    "lsp": "application/x-lisp",
    "lzh": "application/octet-stream",
    "man": "application/x-troff-man",
    "me": "application/x-troff-me",
    "mif": "application/vnd.mif",
    "ms": "application/x-troff-ms",
    "nc": "application/x-netcdf",
    "oda": "application/oda",
    "otf": "font/otf",
    "pdf": "application/pdf",
    "pgn": "application/x-chess-pgn",
    "pot": "application/vnd.ms-powerpoint",
    "pps": "application/vnd.ms-powerpoint",
    "ppt": "application/vnd.ms-powerpoint",
    "pptx": "application/vnd.openxmlformats-officedocument.presentationml.presentation",
    "ppz": "application/vnd.ms-powerpoint",
    "pre": "application/x-freelance",
    "prt": "application/pro_eng",
    "ps": "application/postscript",
    "roff": "application/x-troff",
    "scm": "application/x-lotusscreencam",
    "set": "application/set",
    "sh": "application/x-sh",
    "shar": "application/x-shar",
    "sit": "application/x-stuffit",
    "skd": "application/x-koan",
    "skm": "application/x-koan",
    "skp": "application/x-koan",
    "skt": "application/x-koan",
    "smi": "application/smil",
    "smil": "application/smil",
    "sol": "application/solids",
    "spl": "application/x-futuresplash",
    "src": "application/x-wais-source",
    "step": "application/STEP",
    "stl": "application/SLA",
    "stp": "application/STEP",
    "sv4cpio": "application/x-sv4cpio",
    "sv4crc": "application/x-sv4crc",
    "svg": "image/svg+xml",
    "svgz": "image/svg+xml",
    "swf": "application/x-shockwave-flash",
    "t": "application/x-troff",
    "tar": "application/x-tar",
    "tcl": "application/x-tcl",
    "tex": "application/x-tex",
    "texi": "application/x-texinfo",
    "texinfo": "application/x-texinfo",
    "tr": "application/x-troff",
    "tsp": "application/dsptype",
    "ttc": "font/ttf",
    "ttf": "font/ttf",
    "unv": "application/i-deas",
    "ustar": "application/x-ustar",
    "vcd": "application/x-cdlink",
    "vda": "application/vda",
    "xlc": "application/vnd.ms-excel",
    "xll": "application/vnd.ms-excel",
    "xlm": "application/vnd.ms-excel",
    "xls": "application/vnd.ms-excel",
    "xlsx": "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
    "xlw": "application/vnd.ms-excel",
    "zip": "application/zip",
    "aif": "audio/x-aiff",
    "aifc": "audio/x-aiff",
    "aiff": "audio/x-aiff",
    "au": "audio/basic",
    "kar": "audio/midi",
    "mid": "audio/midi",
    "midi": "audio/midi",
    "mp2": "audio/mpeg",
    "mp3": "audio/mpeg",
    "mpga": "audio/mpeg",
    "ogg": "audio/ogg",
    "oga": "audio/ogg",
    "spx": "audio/ogg",
    "ra": "audio/x-realaudio",
    "ram": "audio/x-pn-realaudio",
    "rm": "audio/x-pn-realaudio",
    "rpm": "audio/x-pn-realaudio-plugin",
    "snd": "audio/basic",
    "tsi": "audio/TSP-audio",
    "wav": "audio/x-wav",
    "aac": "audio/aac",
    "asc": "text/plain",
    "c": "text/plain",
    "cc": "text/plain",
    "css": "text/css",
    "etx": "text/x-setext",
    "f": "text/plain",
    "f90": "text/plain",
    "h": "text/plain",
    "hh": "text/plain",
    "htm": ["text/html", "*/*"],
    "ics": "text/calendar",
    "m": "text/plain",
    "rtf": "text/rtf",
    "rtx": "text/richtext",
    "sgm": "text/sgml",
    "sgml": "text/sgml",
    "tsv": "text/tab-separated-values",
    "tpl": "text/template",
    "txt": "text/plain",
    "text": "text/plain",
    "avi": "video/x-msvideo",
    "fli": "video/x-fli",
    "mov": "video/quicktime",
    "movie": "video/x-sgi-movie",
    "mpe": "video/mpeg",
    "mpeg": "video/mpeg",
    "mpg": "video/mpeg",
    "qt": "video/quicktime",
    "viv": "video/vnd.vivo",
    "vivo": "video/vnd.vivo",
    "ogv": "video/ogg",
    "webm": "video/webm",
    "mp4": "video/mp4",
    "m4v": "video/mp4",
    "f4v": "video/mp4",
    "f4p": "video/mp4",
    "m4a": "audio/mp4",
    "f4a": "audio/mp4",
    "f4b": "audio/mp4",
    "gif": "image/gif",
    "ief": "image/ief",
    "jpg": "image/jpeg",
    "jpeg": "image/jpeg",
    "jpe": "image/jpeg",
    "pbm": "image/x-portable-bitmap",
    "pgm": "image/x-portable-graymap",
    "png": "image/png",
    "pnm": "image/x-portable-anymap",
    "ppm": "image/x-portable-pixmap",
    "ras": "image/cmu-raster",
    "rgb": "image/x-rgb",
    "tif": "image/tiff",
    "tiff": "image/tiff",
    "xbm": "image/x-xbitmap",
    "xpm": "image/x-xpixmap",
    "xwd": "image/x-xwindowdump",
    "psd": [
      "application/photoshop",
      "application/psd",
      "image/psd",
      "image/x-photoshop",
      "image/photoshop",
      "zz-application/zz-winassoc-psd",
    ],
    "ice": "x-conference/x-cooltalk",
    "iges": "model/iges",
    "igs": "model/iges",
    "mesh": "model/mesh",
    "msh": "model/mesh",
    "silo": "model/mesh",
    "vrml": "model/vrml",
    "wrl": "model/vrml",
    "mime": "www/mime",
    "pdb": "chemical/x-pdb",
    "xyz": "chemical/x-pdb",
    "javascript": "application/javascript",
    "form": "application/x-www-form-urlencoded",
    "file": "multipart/form-data",
    "xhtml-mobile": "application/vnd.wap.xhtml+xml",
    "atom": "application/atom+xml",
    "amf": "application/x-amf",
    "wap": ["text/vnd.wap.wml", "text/vnd.wap.wmlscript", "image/vnd.wap.wbmp"],
    "wml": "text/vnd.wap.wml",
    "wmlscript": "text/vnd.wap.wmlscript",
    "wbmp": "image/vnd.wap.wbmp",
    "woff": "application/x-font-woff",
    "appcache": "text/cache-manifest",
    "manifest": "text/cache-manifest",
    "htc": "text/x-component",
    "rdf": "application/xml",
    "crx": "application/x-chrome-extension",
    "oex": "application/x-opera-extension",
    "xpi": "application/x-xpinstall",
    "safariextz": "application/octet-stream",
    "webapp": "application/x-web-app-manifest+Json",
    "vcf": "text/x-vcard",
    "vtt": "text/vtt",
    "mkv": "video/x-matroska",
    "pkpass": "application/vnd.apple.pkpass",
    "ajax": "text/html",
    "bmp": "image/bmp",
  ];

  // Status code to send to the client
  protected int _status = 200;

  // File object for file to be read out as response
  protected ISplFileInfo _file = null;

  // File range. Used for requesting ranges of files.
  protected Json[string] _fileRange = null;

  // The charset the response body is encoded with
  protected string _charset = "UTF-8";

  /**
     * Holds all the cache directives that will be converted
     * into headers when sending the request
     */
  protected Json[string] _cacheDirectives = null;

  // Collection of cookies to send to the client
  protected ICookieCollection _cookies;

  // Reason Phrase
  protected string _reasonPhrase = "OK";

  // Stream mode options.
  protected string _streamMode = "wb+";

  /**
     * Stream target or resource object.
     *
     * @var resource|string
     */
  protected string _streamTarget = "d://memory";

  /**
     
     * Params:
     * Json[string] options list of parameters to setup the response. Possible values are:
     *
     * - body: the response text that should be sent to the client
     * - status: the HTTP status code to respond with
     * - type: a complete mime-type string or an extension mapped in this class
     * - charset: the charset for the response body
     */
  this(Json[string] options = null) {
    _streamTarget = options.get("streamTarget", _streamTarget);
    _streamMode = options.get("streamMode", _streamMode);
    if (options.hasKey("stream")) {
      if (!cast(IStream) options.get("stream")) {
        throw new DInvalidArgumentException("Stream option must be an object that : IStream");
      }
      _stream = options.get("stream");
    } else {
      _createStream();
    }
    if (options.hasKey("body")) {
      _stream.write(options.get("body"));
    }
    if (options.hasKey("status")) {
      _setStatus(options.get("status"));
    }
    if (!options.hasKey("charset")) {
      options.set("charset", configuration.get("App.encoding"));
    }
    _charset = options.get("charset");
    auto type = "text/html";
    if (options.hasKey("type")) {
      type = this.resolveType(options.get("type"));
    }
    _setContentType(type);
    _cookies = new DCookieCollection();
  }

  // Creates the stream object.
  protected void _createStream() {
    _stream = new DStream(_streamTarget, _streamMode);
  }

  /**
     * Formats the Content-Type header based on the configured contentType and charset
     * the charset will only be set in the header if the response is of type text/*  * Params:
     * string atype The type to set.
     */
  protected void _setContentType(string atype) {
    if (isIn(_status, [304, 204], true)) {
      _clearHeader("Content-Type");

      return;
    }

    auto allowed = [
      "application/javascript", "application/xml", "application/rss+xml",
    ];

    auto charset = false;
    if (
      _charset &&
      (
        type.startsWith("text/") ||
        isIn(type, allowed, true)
      )
      ) {
      charset = true;
    }
    if (charset && !type.contains(";")) {
      _setHeader("Content-Type", "{type}; charset={_charset}");
    } else {
      _setHeader("Content-Type", type);
    }
  }

  /**
     * Return an instance with an updated location header.
     *
     * If the current status code is 200, it will be replaced
     * with 302.
     * Params:
     * string aurl The location to redirect to.
     */
  static withLocation(string aurl) {
    auto newResponse = this.withHeader("Location", url);
    if (newResponse._status == 200) {
      newResponse._status = 302;
    }
    return newResponse;
  }

  // Sets a header.
  protected void _setHeader(string key, string value) {
    auto normalized = key.lower;
    _headerNames[normalized] = key;
    _headers[key] = [value];
  }

  // Clear header
  protected void _clearHeader(string name) {
    string normalized = name.lower;
    if (!_headerNames.hasKey(normalized)) {
      return;
    }

    auto original = _headerNames[normalized];
    _headerNames.removeKey(normalized);
    _headers.removeKey(original);
  }

  /**
     * Gets the response status code.
     *
     * The status code is a 3-digit integer result code of the server`s attempt
     * to understand and satisfy the request.
     */
  @property int statusCode() {
    return _status;
  }

  /**
     * Return an instance with the specified status code and, optionally, reason phrase.
     *
     * If no reason phrase is specified, implementations MAY choose to default
     * to the RFC 7231 or IANA recommended reason phrase for the response`s
     * status code.
     *
     * This method MUST be implemented in such a way as to retain the
     * immutability of the message, and MUST return an instance that has the
     * updated status and reason phrase.
     *
     * If the status code is 304 or 204, the existing Content-Type header
     * will be cleared, as these response codes have no body.
     *
     * There are external packages such as `fig/http-message-util` that provide HTTP
     * status code constants. These can be used with any method that accepts or
     * returns a status code integer. However, keep in mind that these constants
     * might include status codes that are now allowed which will throw an
     * `\InvalidArgumentException`.
     */
  static auto withStatus(int statusCode, string reasonPhrase = "") {
    auto newResponse = clone();
    newResponse._setStatus(statusCode, reasonPhrase);

    return newResponse;
  }

  // Modifier for response status
  protected auto _setStatus(int statusCode, string reasonPhrase = "") {
    if (code < STATUS_CODE_MIN || statusCode > STATUS_CODE_MAX) {
      throw new DInvalidArgumentException(
        "Invalid status code: %s. Use a valid HTTP status code in range 1xx - 5xx."
          .format(statusCode)
      );
    }
    _status = statusCode;
    if (reasonPhrase is null && _statusCodes.hasKey(statusCode)) {
      reasonPhrase = _statusCodes[statusCode];
    }
    _reasonPhrase = reasonPhrase;

    // These status codes don`t have bodies and can`t have content-types.
    if (isIn(statusCode, [304, 204], true)) {
      _clearHeader("Content-Type");
    }
  }

  /**
     * Gets the response reason phrase associated with the status code.
     *
     * Because a reason phrase is not a required element in a response
     * status line, the reason phrase value MAY be null. Implementations MAY
     * choose to return the default RFC 7231 recommended reason phrase (or those
     * listed in the IANA HTTP Status Code Registry) for the response`s
     * status code.
     */
  string getReasonPhrase() {
    return _reasonPhrase;
  }

  /**
     * Sets a content type definition into the map.
     *
     * E.g.: setTypeMap("xhtml", ["application/xhtml+xml", "application/xhtml"])
     * This is needed for RequestHandlerComponent and recognition of types.
     */
  void setTypeMap(string contentType, string mimeType) {
    _mimeTypes.set(contentType, mimeType);
  }

  void setTypeMap(string contentType, string[] mimeTypes) {
    _mimeTypes.set(contentType, mimeTypes);
  }

  // Returns the current content type.
  string[] getType() {
    string headerLine = getHeaderLine("Content-Type");

    return headerLine.contains(";")
      ? headerLine.split(";")[0] : headerLine;
  }

  /**
     * Get an updated response with the content type set.
     *
     * If you attempt to set the type on a 304 or 204 status code response, the
     * content type will not take effect as these status codes do not have content-types.
     * Params:
     * string acontentType Either a file extension which will be mapped to a mime-type or a concrete mime-type.
     */
  static auto withType(string acontentType) {
    mappedType = this.resolveType(contentType);
    DResponse newResponse = this.clone;
    newResponse._setContentType(mappedType);

    return newResponse;
  }

  /**
     * Translate and validate content-types.
     * Params:
     * string acontentType The content-type or type alias.
     */
  protected string resolveType(string acontentType) {
    auto mapped = getMimeType(contentType);
    if (mapped) {
      return mapped.isArray ? currentValue(mapped) : mapped;
    }
    if (!contentType.contains("/")) {
      throw new DInvalidArgumentException("`%s` is an invalid content type.".format(contentType));
    }
    return contentType;
  }

  /**
     * Returns the mime type definition for an alias
     *
     * e.g `getMimeType("pdf"); // returns "application/pdf"`
     * Params:
     * string aalias the content type alias to map
     */
  string[] getMimeType(string aliasName) {
    return _mimeTypes.get(aliasName, false);
  }

  /**
     * Maps a content-type back to an alias
     *
     * e.g `mapType("application/pdf"); // returns "pdf"`
     * Params:
     * string[] actype Either a string content type to map, or an array of types.
     */
  string[] mapType(string[] actype) {
    if (ctype.isArray) {
      // return array_map(this.mapType(...), ctype);
    }
    foreach (aliasName, types; _mimeTypes) {
      if (isIn(ctype, /* (array) */ types, true)) {
        return aliasName;
      }
    }
    return null;
  }

  // Returns the current charset.
  string getCharset() {
    return _charset;
  }

  // Get a new instance with an updated charset.
  static withCharset(string acharset) {
    auto newResponse = this.clone;
    newResponse._charset = charset;
    newResponse._setContentType(getType());

    return newResponse;
  }

  // Create a new instance with headers to instruct the client to not cache the response
  static withDisabledCache() {
    return _withHeader("Expires", "Mon, 26 Jul 1997 05:00:00 GMT")
      .withHeader("Last-Modified", gmdate(DATE_RFC7231))
      .withHeader("Cache-Control", "no-store, no-cache, must-revalidate, post-check=0, pre-check=0");
  }

  // Create a new instance with the headers to enable client caching.
  static withCache( /* string */ int sinceModified, /* int */ timeExpiry = "+1 day") {
    if (!isInteger(timeExpiry)) {
      timeExpiry = strtotime(timeExpiry);
      if (timeExpiry == false) {
        throw new DInvalidArgumentException(
          "Invalid time parameter. Ensure your time value can be parsed by strtotime"
        );
      }
    }
    return _withHeader("Date", gmdate(DATE_RFC7231, timeExpiry()))
      .withModified(sinceModified)
      .withExpires(timeExpiry)
      .withSharable(true)
      .withMaxAge(timeExpiry - timeExpiry());
  }

  //Create a new instace with the public/private Cache-Control directive set.
  static withSharable(bool isPublic, int maxAge = 0) {
    IResponse newResponse = this.clone;
    newResponse._cacheDirectivesremoveKey("private", "public");

    newResponse._cacheDirectives.set(isPublic ? "public" : "private", true);

    if (maxAge > 0) {
      newResponse._cacheDirectives.set("max-age", maxAge);
    }
    newResponse._setCacheControl();

    return newResponse;
  }

  /**
     * Create a new instance with the Cache-Control s-maxage directive.
     *
     * The max-age is the number of seconds after which the response should no longer be considered
     * a good candidate to be fetched from a shared cache (like in a proxy server).
     * Params:
     * int seconds The number of seconds for shared max-age
     */
  static DResponse withSharedMaxAge(int seconds) {
    auto newResponse = this.clone;
    newResponse._cacheDirectives.set("s-maxage", seconds);
    newResponse._setCacheControl();

    return newResponse;
  }

  /**
     * Create an instance with Cache-Control max-age directive set.
     *
     * The max-age is the number of seconds after which the response should no longer be considered
     * a good candidate to be fetched from the local (client) cache.
     * Params:
     * int seconds The seconds a cached response can be considered valid
     */
  static withMaxAge(int seconds) {
    auto newResponse = this.clone;
    newResponse._cacheDirectives["max-age"] = seconds;
    newResponse._setCacheControl();

    return newResponse;
  }

  /**
     * Create an instance with Cache-Control must-revalidate directive set.
     *
     * Sets the Cache-Control must-revalidate directive.
     * must-revalidate indicates that the response should not be served
     * stale by a cache under any circumstance without first revalidating
     * with the origin.
     * Params:
     * bool enable If boolean sets or unsets the directive.
     */
  static withMustRevalidate(bool enable) {
    auto newResponse = this.clone;
    if (enable) {
      newResponse._cacheDirectives["must-revalidate"] = true;
    } else {
      removeKey(newResponse._cacheDirectives["must-revalidate"]);
    }
    newResponse._setCacheControl();

    return newResponse;
  }

  /**
     * Helper method to generate a valid Cache-Control header from the options set
     * in other methods
     */
  protected void _setCacheControl() {
    auto control = "";
    foreach (key, value; _cacheDirectives) {
      control ~= value == true ? key : "%s=%s".format(key, value);
      control ~= ", ";
    }
    control = stripRight(control, ", ");
    _setHeader("Cache-Control", control);
  }

  /**
     * Create a new instance with the Expires header set.
     *
     * ### Examples:
     *
     * ```
     * Will Expire the response cache now
     * response.withExpires("now")
     *
     * Will set the expiration in next 24 hours
     * response.withExpires(new DateTime("+1 day"))
     * ```
     */
  static withExpires(Json time) {
    auto date = _getUTCDate(time);
    return _withHeader("Expires", date.format(DATE_RFC7231));
  }

  /**
     * Create a new instance with the Last-Modified header set.
     *
     * ### Examples:
     *
     * ```
     * Will Expire the response cache now
     * response.withModified("now")
     *
     * Will set the expiration in next 24 hours
     * response.withModified(new DateTime("+1 day"))
     * ```
     * Params:
     * \Jsontime Valid time string or \DateTime instance.
     */
  static withModified(Jsontime) {
    auto date = _getUTCDate(time);
    return _withHeader("Last-Modified", date.format(DATE_RFC7231));
  }

  /**
     * Create a new instance as "not modified"
     *
     * This will remove any body contents set the status code
     * to "304" and removing headers that describe
     * a response body.
     */
  static auto withNotModified() {
    auto newResponse = this.withStatus(304);
    newResponse._createStream();
    auto removeHeaders = [
      "Allow",
      "Content-Encoding",
      "Content-Language",
      "Content-Length",
      "Content-MD5",
      "Content-Type",
      "Last-Modified",
    ];
    foreach (header; removeHeaders) {
      newResponse = newResponse.withoutHeader(header);
    }
    return newResponse;
  }

  /**
     * Create a new instance with the Vary header set.
     *
     * If an array is passed values will be imploded into a comma
     * separated string. If no parameters are passed, then an
     * Json[string] with the current Vary header value is returned
     * Params:
     * string[]|string acacheVariances A single Vary string or an array
     * containing the list for variances.
     */
  static withVary(string[] acacheVariances) {
    return _withHeader("Vary", /* (array) */ cacheVariances);
  }

  /**
     * Create a new instance with the Etag header set.
     *
     * Etags are a strong indicative that a response can be cached by a
     * HTTP client. A bad way of generating Etags is creating a hash of
     * the response output, instead generate a unique hash of the
     * unique components that identifies a request, such as a
     * modification time, a resource Id, and anything else you consider it
     * that makes the response unique.
     *
     * The second parameter is used to inform clients that the content has
     * changed, but semantically it is equivalent to existing cached values. Consider
     * a page with a hit counter, two different page views are equivalent, but
     * they differ by a few bytes. This permits the Client to decide whether they should
     * use the cached data.
     */
  static withEtag(string hash, bool isWeak = false) {
    hash = "%s\"%s\"".format(isWeak ? "W/" : "", hash);

    return _withHeader("Etag", hash);
  }

  /**
     * Returns a DateTime object initialized at the time param and using UTC
     * as timezone
     * Params:
     * \Jsontime Valid time string or \IDateTime instance.
     */
  protected IDateTime _getUTCDate(Json time = Json(null)) {
    if (cast(IDateTime) time) {
      result = time.clone;
    } else if (isInteger(time)) {
      result = new DateTime(date("Y-m-d H:i:s", time));
    } else {
      result = new DateTime(time ? time : "now");
    }
    /**
         * @psalm-suppress UndefinedInterfaceMethod
         * @Dstan-ignore-next-line
         */
    return result.setTimezone(new DateTimeZone("UTC"));
  }

  /**
     * Sets the correct output buffering handler to send a compressed response. Responses will
     * be compressed with zlib, if the extension is available.
     */
  bool compress() {
    return ini_get("zlib.output_compression") != "1" &&
      extension_loaded("zlib") &&
       /* (string) */
      enviroment("HTTP_ACCEPT_ENCODING").contains("gzip") &&
      ob_start("ob_gzhandler");
  }

  // Returns whether the resulting output will be compressed by D
  bool outputCompressed() {
    return  /* (string) */ enviroment("HTTP_ACCEPT_ENCODING").contains("gzip")
      && (ini_get("zlib.output_compression") == "1" || isIn("ob_gzhandler", ob_list_handlers(), true));
  }

  // Create a new instance with the Content-Disposition header set.
  static withDownload(string filename) {
    return _withHeader("Content-Disposition", "attachment; filename=\"" ~ filename ~ "\"");
  }

  // Create a new response with the Content-Length header set.
  // static auto withLength(string|int bytes) {
  static auto withLength(string bytes) {
    return _withHeader("Content-Length", bytes);
  }

  /**
     * Create a new response with the Link header set.
     *
     * ### Examples
     *
     * ```
     * response = response.withAddedLink("http://example.com?page=1", ["rel": "prev"])
     *   .withAddedLink("http://example.com?page=3", ["rel": "next"]);
     * ```
     *
     * Will generate:
     *
     * ```
     * Link: <http://example.com?page=1>; rel="prev"
     * Link: <http://example.com?page=3>; rel="next"
     * ```
     */
  static withAddedLink(string linkHeaderUrl, Json[string] options = null) {
    string[] params = options.byKeyValue
      .map!(kv => `%s="%s"`.format(kv.key, kv.value.getString))
      .array;
    return _withAddedHeader("Link", "<" ~ linkHeaderUrl ~ ">" ~ (!params.isEmpty ? "; " ~ params.join(
        "; ") : ""));
  }

  /**
     * Checks whether a response has not been modified according to the "If-None-Match"
     * (Etags) and "If-Modified-Since" (last modification date) request
     * headers.
     *
     * In order to interact with this method you must mark responses as not modified.
     * You need to set at least one of the `Last-Modified` or `Etag` response headers
     * before calling this method. Otherwise, a comparison will not be possible.
     */
  bool isNotModified(DServerRequest serverRequest) {
    // auto etags = preg_split(r"/\s*,\s*/", serverRequest.getHeaderLine("If-None-Match"), 0, PREG_SPLIT_NO_EMPTY) ?: [];
    string[] eTags;
    auto responseTag = getHeaderLine("Etag");
    auto etagMatches = null;
    if (responseTag) {
      etagMatches = isIn("*", etags, true) || isIn(responseTag, etags, true);
    }
    auto modifiedSince = serverRequest.getHeaderLine("If-Modified-Since");
    auto timeMatches = null;
    if (modifiedSince && this.hasHeader("Last-Modified")) {
      timeMatches = strtotime(getHeaderLine("Last-Modified")) == strtotime(modifiedSince);
    }

    return etagMatches.isNull && timeMatches.isNull
      ? false : etagMatches == true && timeMatches == true;
  }

  /**
     * String conversion. Fetches the response body as a string.
     * Does *not* send headers.
     * If body is a callable, a blank string is returned.
     */
  override string toString() {
    _stream.rewind();
    return _stream.getContents();
  }

  /**
     * Create a new response with a cookie set.
     *
     * ### Example
     *
     * ```
     * add a cookie object
     * response = response.withCookie(new DCookie("remember_me", 1));
     * ```
     */
  static auto withCookie(ICookie cookie) {
    auto newResponse = this.clone;
    newResponse._cookies = new._cookies.add(cookie);

    return newResponse;
  }

  /**
     * Create a new response with an expired cookie set.
     *
     * ### Example
     *
     * ```
     * add a cookie object
     * response = response.withExpiredCookie(new DCookie("remember_me"));
     * ```
     */
  static auto withExpiredCookie(ICookie cookie) {
    cookie = cookie.withExpired();

    auto newResponse = this.clone;
    newResponse._cookies = newResponse._cookies.add(cookie);

    return newResponse;
  }

  /**
     * Read a single cookie from the response.
     *
     * This method provides read access to pending cookies. It will
     * not read the `Set-Cookie` header if set.
     * Params:
     * string aName The cookie name you want to read.
     */
  Json[string] getCookie(string aName) {
    return !_cookies.has(name)
      ? null : _cookies.get(name).toJString();
  }

  /**
     * Get all cookies in the response.
     *
     * Returns an associative array of cookie name: cookie data.
     */
  Json[string] getCookies() {
    Json[string] result;
    _cookies.each!(cookie => result[cookie.name] = cookie.toJString());
    return result;
  }

  /**
     * Get the CookieCollection from the response
     */
  DCookieCollection getCookieCollection() {
    return _cookies;
  }

  // Get a new instance with provided cookie collection.
  static withCookieCollection(CookieCollection cookieCollection) {
    auto newResponse = this.clone;
    newResponse._cookies = cookieCollection;

    return newResponse;
  }

  // Get a CorsBuilder instance for defining CORS headers.
  DCorsBuilder cors(IServerRequest serverRequest) {
    auto origin = serverRequest.getHeaderLine("Origin");
    auto https = serverRequest.isType("https");
    return new DCorsBuilder(this, origin, https);
  }

  /**
     * Create a new instance that is based on a file.
     *
     * This method will augment both the body and a number of related headers.
     *
     * If ` _SERVER["HTTP_RANGE"]` is set, a slice of the file will be
     * returned instead of the entire file.
     *
     * ### Options keys
     *
     * - name: Alternate download name
     * - download: If `true` sets download header and forces file to
     * be downloaded rather than displayed inline.
     */
  static withFile(string path, Json[string] options = null) {
    auto file = validateFile(path);
    auto options = options.setPath([
        "name": StringData,
        "download": Json(null)
      ]);

    auto fileExtension = file.getExtension().lower;
    auto mapped = getMimeType(fileExtension);
    if ((!fileExtension || !mapped) && options.isNull("download")) {
      options.get("download") = true;
    }
    auto newResponse = this.clone;
    if (mapped) {
      newResponse = newResponse.withType(fileExtension);
    }
    fileSize = file.getSize();
    if (options.hasKey("download")) {
      agent =  /* (string) */ enviroment("HTTP_USER_AGENT");

      if (agent && preg_match(r"%Opera([/ ])([0-9].[0-9]{1,2})%", agent)) {
        contentType = "application/octet-stream";
      } else if (agent && preg_match(r"/MSIE ([0-9].[0-9]{1,2})/", agent)) {
        contentType = "application/force-download";
      }
      if (contentType !is null) {
        newResponse = new.withType(contentType);
      }
      name = options.getString("name", file.getFileName);
      newResponse = new.withDownload(name)
        .withHeader("Content-Transfer-Encoding", "binary");
    }
    newResponse = newResponse.withHeader("Accept-Ranges", "bytes");
    httpRange =  /* (string) */ enviroment("HTTP_RANGE");
    if (httpRange) {
      newResponse._fileRange(file, httpRange);
    } else {
      newResponse = new.withHeader("Content-Length", to!string(fileSize));
    }
    newResponse._file = file;
    newResponse.stream = new DStream(file.getPathname(), "rb");
    return newResponse;
  }

  // Convenience method to set a string into the response body
  static withStringBody(string stringToSent) {
    auto newResponse = this.clone;
    newResponse._createStream();
    newResponse.stream.write(stringToSent);
    return newResponse;
  }

  // Validate a file path is a valid response body.
  protected ISplFileInfo validateFile(string filePath) {
    if (filePath.contains("../") || somefilePathPath.contains("..\\")) {
      throw new DNotFoundException(__d("uim", "The requested file contains `..` and will not be read."));
    }

    auto file = new DFileInfo(filePath);
    if (!file.isFile() || !file.isReadable()) {
      if (configuration.hasKey("debug")) {
        throw new DNotFoundException(
          "The requested file %s was not found or not readable".format(filePath));
      }
      throw new DNotFoundException(__d("uim", "The requested file was not found"));
    }

    return file;
  }

  // Get the current file if one exists.
  ISplFileInfo getFile() {
    return _file;
  }

  /**
     * Apply a file range to a file and set the end offset.
     *
     * If an invalid range is requested a 416 Status code will be used
     * in the response.
     */
  protected void _fileRange(DFileInfo file, string httpRange) {
    size_t fileSize = file.getSize();
    lastByte = fileSize - 1;
    string start = 0;
    string end = lastByte;

    // TODO preg_match(r"/^bytes\s*=\s*(\d+)?\s*-\s*(\d+)?/", httpRange, matches);
    if (matches) {
      start = matches[1];
      end = !matches[2].ifEmpty("");
    }
    if (start.isEmpty) {
      start = fileSize -  /* (int) */ end;
      end = lastByte;
    }
    if (end is null) {
      end = lastByte;
    }
    if (start > end || end > lastByte || start > lastByte) {
      _setStatus(416);
      _setHeader("Content-Range", "bytes 0-" ~ lastByte ~ "/" ~ fileSize);

      return;
    }
    _setHeader("Content-Length", /* (string) */ ( /* (int) */ end -  /* (int) */ start + 1));
    _setHeader("Content-Range", "bytes " ~ start ~ "-" ~ end ~ "/" ~ fileSize);
    _setStatus(206);
    /**
         * @var int start
         * @var int end
         */
    _fileRange = [start, end];
  }

  // Returns an array that can be used to describe the internal state of this object.
  Json[string] debugInfo() {
    return super.debugInfo()
      .set("status", _status)
      .set("contentType", getType())
      .set("headers", _headers)
      .set("file", _file)
      .set("fileRange", _fileRange)
      .set("cookies", _cookies)
      .set("cacheDirectives", _cacheDirectives)
      .set("body", getBody());
  }
}
