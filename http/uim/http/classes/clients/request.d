module uim.http.classes.clients.request;

import uim.http;

@safe:

/**
 * : methods for HTTP requests.
 *
 * Used by UIM\Http\Client to contain request information
 * for making requests.
 */
class DRequest { // }: Message, IRequest {
    // TODO mixin TRequest;

    /**
     * Constructor
     *
     * Provides backwards compatible defaults for some properties.
     *
     * @Dstan-param array<non-empty-string, non-empty-string>  aHeaders
     * @param \Psr\Http\Message\IUri|string aurl The request URL
     * @param string amethod The HTTP method to use.
     * @param Json[string]  aHeaders The HTTP headers to set.
     * @param string[] someData The request body to use.
     * /
    this(
        IUri|string aurl = "",
        string amethod = self.METHOD_GET,
        Json[string]  aHeaders = [],
        string[] someData = null
    ) {
        this.setMethod(method);
        this.uri = this.createUri(url);
         aHeaders += [
            "Connection": "close",
            "User-Agent": ini_get("user_agent") ?: "UIM",
        ];
        this.addHeaders(aHeaders);

        if (someData.isNull) {
            this.stream = new DStream("D://memory", "rw");
        } else {
            this.setContent(someData);
        }
    }
    
    /**
     * Add an array of headers to the request.
     * @param STRINGAA  aHeaders The headers to add.
     * /
    protected void addHeaders(STRINGAA headersToAdd) {
        headersToAdd.byKeyValue
            .each!(kv => addHeader(kv.key, kv.value));
    }

    protected void addHeader(string key, string value) {
        string normalized = key.toLower;
        this.headers[key] = value;
        this.headerNames[normalized] = key;
    }
    
    /**
     * Set the body/payload for the message.
     *
     * Array data will be serialized with {@link \UIM\Http\FormData},
     * and the content-type will be set.
     * Params:
     * string[] requestBody The body for the request.
     * /
    protected void setContent(string[] requestBody) {
        if (isArray(content)) {
            formData = new DFormData();
            formData.addMany(requestBody);
            /** @Dstan-var array<non-empty-string, non-empty-string>  aHeaders *
            /
             aHeaders = ["Content-Type": formData.contentType()];
            this.addHeaders(aHeaders);
            auto myFormData = (string)formData;
        }
        stream = new DStream("D://memory", "rw");
        stream.write(myFormData);
        this.stream = stream;
    } */
}
