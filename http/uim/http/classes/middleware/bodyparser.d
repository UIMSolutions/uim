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
     * /
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
     * Constructor
     *
     * ### Options
     *
     * - `Json` Set to false to disable Json body parsing.
     * - `xml` Set to true to enable XML parsing. Defaults to false, as XML
     *  handling requires more care than Json does.
     * - `methods` The HTTP methods to parse on. Defaults to PUT, POST, PATCH DELETE.
     * Params:
     * Json[string] options The options to use. See above.
     * /
    this(Json[string] options = null) {
        options = options.update["Json": Json(true), "xml": Json(false), "methods": null];
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
            this.setMethods(options["methods"]);
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
     *  aParser.addParser(["text/csv"], auto (body) {
     *  return str_getcsv(body);
     * });
     * ```
     * Params:
     * string[] types An array of content-type header values to match. eg. application/Json
     * @param \Closure  aParser The parser function. Must return an array of data to be inserted
     *  into the request.
     * /
    void addParser(Json[string] types, Closure  aParser) {
        types
            .map!(type => type.toLower)
            .each!(type => this.parsers[type] = aParser);
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
     * @param \Psr\Http\Server\IRequestHandler handler The request handler.
     * /
    IResponse process(IServerRequest serverRequest, IRequestHandler handler) {
        if (!in_array(request.getMethod(), this.methods, true)) {
            return handler.handle(request);
        }
        [type] = request.getHeaderLine("Content-Type").split(";");
        type = type.toLower;
        if (!this.parsers.isSet(type)) {
            return handler.handle(request);
        }
         aParser = this.parsers[type];
        result = aParser(request.getBody().getContents());
        if (!isArray(result)) {
            throw new BadRequestException();
        }
        request = request.withParsedBody(result);

        return handler.handle(request);
    }
    
    // Decode Json into an array.
    // TODO protected array Json[string] decodeJson(string bodyToDecode) {
        if (bodyToDecode.isEmpty) {
            return null;
        }
        
        auto decodedBody = Json_decode(bodyToDecode, true);
        if (Json_last_error() != Json_ERROR_NONE) {
            return null;
        }
        return (array)decodedBody;
    }
    
    // Decode XML into an array.
    // TODO protected array Json[string] decodeXml(string bodyToDecode) {
        try {
            xml = Xml.build(bodyToDecode, ["return": "domdocument", "readFile": Json(false)]);
            // We might not get child nodes if there are nested inline entities.
            /** @var \DOMNodeList domNodeList * /
            domNodeList = xml.childNodes;
            if ((int)domNodeList.length > 0) {
                return Xml.toArray(xml);
            }
            return null;
        } catch (XmlException) {
            return null;
        }
    } */
}
