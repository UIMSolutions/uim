module uim.http.classes.middleware.bodyparser;

import uim.http;

@safe:

/**
 * Parse encoded request body data.
 *
 * Enables Json and XML request payloads to be parsed into the request`s body.
 * You can also add your own request body parsers using the `addParser()` method.
 */
class DBodyParserMiddleware { // }: IHttpMiddleware {
    // The HTTP methods to parse data on.
    protected string[] someMethods = ["PUT", "POST", "PATCH", "DELETE"];
    /**
     * Set the HTTP methods to parse request bodies on.
     * Params:
     * string[] someMethods The methods to parse data on.
     */
    void setMethods(string[] methodsToParseData) {
        this.methods = methodsToParseData;
    }
    
    // Get the HTTP methods to parse request bodies on.
    string[] getMethods() {
        return _methods;
    }
    /*
    // Registered Parsers
    protected IClosure[] aParsers = null;



    /**
     
     *
     * ### Options
     *
     * - `Json` Set to false to disable Json body parsing.
     * - `xml` Set to true to enable XML parsing. Defaults to false, as XML
     * handling requires more care than Json does.
     * - `methods` The HTTP methods to parse on. Defaults to PUT, POST, PATCH DELETE.
     * Params:
     * Json[string] options The options to use. See above.
     */
    this(Json[string] options = null) {
        auto updatedOptions = options.update["Json": true.toJson, "xml": false.toJson, "methods": Json(null)];
        if (options["Json"]) {
            this.addParser(
                ["application/Json", "text/Json"],
                this.decodeJson(...)
            );
        }
        if (options["xml"]) {
            this.addParser(
                ["application/xml", "text/xml"],
                this.decodeXml(...)
            );
        }
        if (options["methods"]) {
            setMethods(options["methods"]);
        }
    }
    

    
    /**
     * Add a parser.
     *
     * Map a set of content-type header values to be parsed by the  aParser.
     *
     * ### Example
     *
     * An naive CSV request body parser could be built like so:
     *
     * ```
     * aParser.addParser(["text/csv"], auto (body) {
     * return str_getcsv(body);
     * });
     * ```
     */
    void addParser(Json[string] contentTypeHeaders, Closure parserFunction) {
        types
            .map!(contentTypeHeaders => contentTypeHeaders.lower)
            .each!(contentTypeHeaders => this.parsers[contentTypeHeaders] = parserFunction);
    }
    
    // Get the current parsers
    IClosure[] getParsers() {
        return _parsers;
    }
    
    /**
     * Apply the middleware.
     *
     * Will modify the request adding a parsed body if the content-type is known.
     * Params:
     * \Psr\Http\Message\IServerRequest serverRequest The request.
     */
    IResponse process(IServerRequest serverRequest, IRequestHandler requestHandler) {
        if (!isIn(request.getMethod(), this.methods, true)) {
            return requestHandler.handle(request);
        }
        [type] = request.getHeaderLine("Content-Type").split(";");
        type = type.lower;
        if (!this.parsers.hasKey(type)) {
            return requestHandler.handle(request);
        }
         aParser = this.parsers[type];
        result = aParser(request.getBody().getContents());
        if (!isArray(result)) {
            throw new BadRequestException();
        }
        request = request.withParsedBody(result);

        return requestHandler.handle(request);
    }
    
    // Decode Json into an array.
    protected Json[string] decodeJson(string bodyToDecode) {
        if (bodyToDecode.isEmpty) {
            return null;
        }
        
        auto decodedBody = Json_decode(bodyToDecode, true);
        if (Json_last_error() != Json_ERROR_NONE) {
            return null;
        }
        return /* (array) */decodedBody;
    }
    
    // Decode XML into an array.
    protected Json[string] decodeXml(string bodyToDecode) {
        try {
            xml = Xml.build(bodyToDecode, ["return": "domdocument", "readFile": false.toJson]);
            // We might not get child nodes if there are nested inline entities.
            /** @var \DOMNodeList domNodeList */
            domNodeList = xml.childNodes;
            return domNodeList.length > 0
                ? Xml.toArray(xml)
                : null;
        } catch (XmlException) {
            return null;
        }
    }
}
