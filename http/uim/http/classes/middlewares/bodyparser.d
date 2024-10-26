/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.http.classes.middlewares.bodyparser;

import uim.http;

@safe:

/**
 * Parse encoded request body data.
 *
 * Enables Json and XML request payloads to be parsed into the request`s body.
 * You can also add your own request body parsers using the `addParser()` method.
 */
class DBodyParserMiddleware : DMiddleware { // }: IMiddleware {
    mixin(MiddlewareThis!("BodyParser"));

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
    /* this(Json[string] options = null) {
        options
            .merge("Json", true)
            .merge("xml", false)
            .merge("methods", Json(null));

        if (options.hasKey("Json")) {
            addParser(
                ["application/Json", "text/Json"],
                // this.decodeJson(...)
           );
        }
        if (options.hasKey("xml")) {
            addParser(
                ["application/xml", "text/xml"],
                // this.decodeXml(...)
           );
        }
        if (options.hasKey("methods")) {
            setMethods(options.get("methods"));
        }
    } */

    // The HTTP methods to parse data on.
    protected string[] _methods = ["PUT", "POST", "PATCH", "DELETE"];
    /**
     * Set the HTTP methods to parse request bodies on.
     */
    void methods(string[] httpMethods) {
        _methods = httpMethods;
    }
    
    // Get the HTTP methods to parse request bodies on.
    string[] methods() {
        return _methods;
    }
    
    // Registered Parsers
    protected IClosure[] _parsers = null;

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
    /* void addParser(Json[string] contentTypeHeaders, Closure parserFunction) {
        types
            .map!(contentTypeHeaders => contentTypeHeaders.lower)
            .each!(contentTypeHeaders => _parsers[contentTypeHeaders] = parserFunction);
    } */
    
    // Get the current parsers
    IClosure[] getParsers() {
        return _parsers;
    }
    
    /**
     * Apply the middleware.
     * Will modify the request adding a parsed body if the content-type is known.
     */
    IResponse process(IServerRequest serverRequest, IRequestHandler requestHandler) {
        /* if (!isIn(serverRequest.getMethod(), this.methods, true)) {
            return requestHandler.handle(serverRequest);
        }
        [type] = serverRequest.getHeaderLine("Content-Type").split(";");
        type = type.lower;
        if (!_parsers.hasKey(type)) {
            return requestHandler.handle(serverRequest);
        }
        
        auto result = _parsers[type](serverRequest.getBody().getContents());
        if (!isArray(result)) {
            throw new BadRequestException();
        }
        return requestHandler.handle(
            ServerRequestFactoty.withParsedBody(serverRequest, result)); */
        return null;  
    }
    
    // Decode Json into an array.
    protected Json[string] decodeJson(string bodyToDecode) {
        if (bodyToDecode.isEmpty) {
            return null;
        }
        
        /* auto decodedBody = Json_decode(bodyToDecode, true);
        if (Json_last_error() != Json_ERROR_NONE) {
            return null;
        } * /
        return /* (array) * /decodedBody; */
        return null; 
        
    }
    
    // Decode XML into an array.
    protected Json[string] decodeXml(string bodyToDecode) {
        /* try {
            xml = Xml.build(bodyToDecode, ["return": "domdocument", "readFile": false.toJson]);
            // We might not get child nodes if there are nested inline entities.
            /** @var \DOMNodeList domNodeList * /
            domNodeList = xml.childNodes;
            return domNodeList.length > 0
                ? Xml.toArray(xml)
                : null;
        } catch (XmlException) {
            return null;
        } */
        return null; 
    }
}
