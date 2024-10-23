/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.http.classes.adapters.curl;

import uim.http;

@safe:

/**
 * : sending UIM\Http\Client\Request via ext/curl.
 *
 * In addition to the standard curlOptions documented in {@link \UIM\Http\Client},
 * this adapter supports all available curl curlOptions. Additional curl curlOptions
 * can be set via the `curl` option key when making requests or configuring
 * a client.
 */
class DCurl { // }: IAdapter {
    Json[string] send(IRequest request, Json[string] curlOptions = null) {
        /* if (!extension_loaded("curl")) {
            throw new DClientException("curl extension is not loaded.");
        }
        ch = curl_initialize();
        curlOptions = this.buildOptions(request, curlOptions);
        curl_setopt_array(ch, curlOptions);

        body = this.exec(ch);
        assert(body != true);
        if (body == false) {
            errorCode = curl_errno(ch);
            error = curl_error(ch);
            curl_close(ch);

            string message = "cURL Error ({errorCode}) {error}";
            errorNumbers = [
                CURLE_FAILED_INIT,
                CURLE_URL_MALFORMAT,
                CURLE_URL_MALFORMAT_USER,
            ];
            if (isIn(errorCode, errorNumbers, true)) {
                throw new DRequestException(message, request);
            }
            throw new DNetworkException(message, request);
        }
        responses = this.createResponse(ch, body);
        curl_close(ch);

        return responses; */
        return null; 
    }
    
    // Convert client options into curl options.
    Json[string] buildOptions(IRequest request, Json[string] clientOptions = null) {
        /* string[] aHeaders = request.getHeaders().byKeyValue
            .map!(keyValues => aKey ~ ": " ~ someValues.join(", ")).array;

         result = [
            CURLOPT_URL: (string)request.getUri(),
            CURLOPT_HTTP_VERSION: getProtocolVersion(request),
            CURLOPT_RETURNTRANSFER: true,
            CURLOPT_HEADER: true,
            CURLOPT_HTTPHEADER:  aHeaders,
        ];
        switch (request.getMethod()) {
            case Request.METHOD_GET:
                 t(CURLOPT_HTTPGET, true);
                break;

            case Request.METHOD_POST:
                 t(CURLOPT_POST, true);
                break;

            case Request.METHOD_HEAD:
                 t(CURLOPT_NOBODY, true);
                break;

            default:
                 t(CURLOPT_POST, true);
                 t(CURLOPT_CUSTOMREQUEST, request.getMethod());
                break;
        }
        body = request.getBody();
        body.rewind();
         t(CURLOPT_POSTFIELDS, body.getContents());
        // GET requests with bodies require custom request to be used.
        if (result[CURLOPT_POSTFIELDS] != "" && result.hasKey(CURLOPT_HTTPGET))) {
            result.set(URLOPT_CUSTOMREQUEST, "get");
        }
        if (result.isEmpty(CURLOPT_POSTFIELDS)) {
            result.removeKey(CURLOPT_POSTFIELDS);
        }
        if (clientOptions.isEmpty("ssl_cafile")) {
            clientOptions.set("ssl_cafile", CaBundle.getBundledCaBundlePath());
        }
        if (!clientOptions.isEmpty("ssl_verify_host"))) {
            // Value of 1 or true is deprecated. Only 2 or 0 should be used now.
            clientoptions.get("ssl_verify_host"] = 2;
        }
        optionMap = [
            "timeout": CURLOPT_TIMEOUT,
            "ssl_verify_peer": CURLOPT_SSL_VERIFYPEER,
            "ssl_verify_host": CURLOPT_SSL_VERIFYHOST,
            "ssl_cafile": CURLOPT_CAINFO,
            "ssl_local_cert": CURLOPT_SSLCERT,
            "ssl_passphrase": CURLOPT_SSLCERTPASSWD,
        ];
        
        optionMap.byKeyValue
            .filter!(optionCurlOpt => clientOptions.hasKey(optionCurlOpt.key))
            .each!(optionCurlOpt => result[optionCurlOpt.value] = clientOptions.get(optionCurlOpt.key));
            
        if (clientOptions.hasKey("proxy.proxy")) {
             result[CURLOPT_PROXY] = clientoptions.get("proxy.proxy"];
        }
        if (clientOptions.hasKey("proxy.username")) {
            password = !clientOptions.isEmpty("proxy.password") ? clientoptions.get("proxy.password"] : "";
             result[CURLOPT_PROXYUSERPWD] = clientOptions.getString("proxy.username") ~ ": " ~ password;
        }
        if (clientOptions.hasKey("curl") && clientoptions.isArray("curl")) {
            // Can`t use array_merge() because keys will be re-ordered.
            clientoptions.get("curl"].byKeyValue
                .each!(kv => result.set(kv.key, kv.value));

        }
        return result; */
    
        return null; 
    }
    
    // Convert HTTP version number into curl value.
    protected int getProtocolVersion(IRequest request) {
        /* return match (request.getProtocolVersion()) {
            "1.0": CURL_HTTP_VERSION_1_0,
            "1.1": CURL_HTTP_VERSION_1_1,
            "2", "2.0": defined("CURL_HTTP_VERSION_2TLS")
                ? CURL_HTTP_VERSION_2TLS
                : (defined("CURL_HTTP_VERSION_2_0")
                    ? CURL_HTTP_VERSION_2_0
                    : throw new DHttpException("libcurl 7.33 or greater required for HTTP/2 support")
               ),
            default: CURL_HTTP_VERSION_NONE,
        }; */
        return 0;
    } 
    
    // Convert the raw curl response into an Http\Client\Response
    protected DResponse[] createResponse(CurlHandle handle, string responseData) {
        /* auto aHeaderSize = curl_getinfo(handle, CURLINFO_HEADER_SIZE);
        auto aHeaders = subString(responseData, 0,  aHeaderSize).strip;
        body = subString(responseData,  aHeaderSize);
        auto response = new DResponse(split("\r\n",  aHeaders), body);
        return [response]; */
        return null; 
    }
    
    // Execute the curl handle.
    /* protected string exec(CurlHandle ch) {
        return curl_exec(ch);
    } */
}
