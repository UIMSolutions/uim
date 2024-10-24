/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
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
  // mixin TRequest;

  this(
    /* IUri| */
    string requestUrl = "",
    string httpMethod = cast(string) HTTPMETHODS.METHOD_GET,
    Json[string] httpHeaders = null,
    string[] requestBodyData = null
  ) {
    setMethod(httpMethod);
    _uri = createUri(requestUrl);
    addHeaders(httpHeaders.merge([
        "Connection": "close",
        "User-Agent": ini_get("user_agent") ? ini_get("user_agent"): "UIM",
      ]));

    if (requestBodyData.isNull) {
      _stream = new DStream("d://memory", "rw");
    } else {
      setContent(requestBodyData);
    }
  }

  // Add an array of headers to the request.
  protected void addHeaders(string[string] headersToAdd) {
    headersToAdd.byKeyValue
      .each!(kv => addHeader(kv.key, kv.value));
  }

  protected void addHeader(string key, string value) {
    string normalized = key.lower;
    _headers[key] = value;
    _headerNames[normalized] = key;
  }

  /**
     * Set the body/payload for the message.
     *
     * Array data will be serialized with {@link \UIM\Http\FormData},
     * and the content-type will be set.
     */
  protected void setContent(string[] requestBody) {
    if (content.isArray) {
      formData = new DFormData();
      formData.addMany(requestBody);
      /** @Dstan-var array<non-empty-string, non-empty-string>  aHeaders *
            /
             aHeaders = ["Content-Type": formData.contentType()];
            this.addHeaders(aHeaders);
            auto myFormData = (string)formData; */
    }
    stream = new DStream("d://memory", "rw");
    stream.write(myFormData);
    _stream = stream;
  }
}
