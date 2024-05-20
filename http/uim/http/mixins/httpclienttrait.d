module uim.http.mixins.httpclienttrait;

import uim.http;

@safe:

// Define mock responses and have mocks automatically cleared.
mixin template THttpClient() {
    /**
     * Resets mocked responses
     *
     * @after
     */
    void cleanupMockResponses() {
        Client.clearMockResponses();
    }
    
    /**
     * Create a new response.
     * Params:
     * int code The response code to use. Defaults to 200
     * @param string[] aHeaders A list of headers for the response. Example `Content-Type: application/Json`
     * @param string abody The body for the response.
     * \UIM\Http\Client\Response
     */
    Response newClientResponse(int code = 200, Json[string] aHeaders = null, string abody= null) {
         aHeaders = chain(["HTTP/1.1 {code}"],  aHeaders);

        return new DResponse(aHeaders, body);
    }
    
    // Add a mock response for a POST request.
    void mockClientPost(string urlToMock, Response responseToMock, Json[string] additionalOptions = null) {
        Client.addMockResponse("POST", urlToMock, responseToMock, additionalOptions);
    }
    
    /**
     * Add a mock response for a GET request.
     * Params:
     * string aurl The URL to mock
     * @param \UIM\Http\Client\Response response The response for the mock.
     * @param Json[string] options Additional options. See Client.addMockResponse()
     */
    void mockClientGet(string aurl, Response response, Json[string] options = null) {
        Client.addMockResponse("GET", url, response, options);
    }
    
    /**
     * Add a mock response for a PATCH request.
     * Params:
     * string aurl The URL to mock
     * @param \UIM\Http\Client\Response response The response for the mock.
     * @param Json[string] options Additional options. See Client.addMockResponse()
     */
    void mockClientPatch(string aurl, Response response, Json[string] options = null) {
        Client.addMockResponse("PATCH", url, response, options);
    }
    
    /**
     * Add a mock response for a PUT request.
     * Params:
     * string aurl The URL to mock
     * @param \UIM\Http\Client\Response response The response for the mock.
     * @param Json[string] options Additional options. See Client.addMockResponse()
     */
    void mockClientPut(string aurl, Response response, Json[string] options = null) {
        Client.addMockResponse("PUT", url, response, options);
    }
    
    /**
     * Add a mock response for a DELETE request.
     * Params:
     * @param \UIM\Http\Client\Response response The response for the mock.
     * @param Json[string] options Additional options. See Client.addMockResponse()
     */
    void mockClientDelete(string UrlToMock, Response response, Json[string] options = null) {
        Client.addMockResponse("DELETE", UrlToMock, response, options);
    }
}

