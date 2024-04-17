module uim.http.classes.middleware.bodyparser;

import uim.http;

@safe:

/**
 * Parse encoded request body data.
 *
 * Enables IData and XML request payloads to be parsed into the request`s body.
 * You can also add your own request body parsers using the `addParser()` method.
 */
class DBodyParserMiddleware { // }: IMiddleware {
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
        return this.methods;
    }
    /*
    // Registered Parsers
    protected IClosure[] aParsers = null;



    /**
     * Constructor
     *
     * ### Options
     *
     * - `IData` Set to false to disable IData body parsing.
     * - `xml` Set to true to enable XML parsing. Defaults to false, as XML
     *  handling requires more care than IData does.
     * - `methods` The HTTP methods to parse on. Defaults to PUT, POST, PATCH DELETE.
     * Params:
     * IData[string] options The options to use. See above.
     * /
    this(IData[string] options = null) {
        options = options.update["IData": BooleanData(true), "xml": BooleanData(false), "methods": null];
        if (options["IData"]) {
            this.addParser(
                ["application/IData", "text/IData"],
                this.decodeIData(...)
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
     * string[] types An array of content-type header values to match. eg. application/IData
     * @param \Closure  aParser The parser function. Must return an array of data to be inserted
     *  into the request.
     * /
    void addParser(array types, Closure  aParser) {
        types
            .map!(type => type.toLower)
            .each!(type => this.parsers[type] = aParser);
    }
    
    // Get the current parsers
    Closure[] getParsers() {
        return this.parsers;
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
        [type] = split(";", request.getHeaderLine("Content-Type"));
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
    
    /**
     * Decode IData into an array.
     * Params:
     * string abody The request body to decode
     * /
    protected array decodeIData(string abody) {
        if (body.isEmpty) {
            return null;
        }
        decoded = Json_decode(body, true);
        if (Json_last_error() != Json_ERROR_NONE) {
            return null;
        }
        return (array)decoded;
    }
    
    /**
     * Decode XML into an array.
     * /
    protected array decodeXml(string bodyToDecode) {
        try {
            xml = Xml.build(bodyToDecode, ["return": "domdocument", "readFile": BooleanData(false)]);
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
