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
     * @param string[] aHeaders A list of headers for the response. Example `Content-Type: application/Json`
     * @param string abody The body for the response.
     */
    Response newClientResponse(int responseCode = 200, Json[string] aHeaders = null, string abody= null) {
         aHeaders = chain(["HTTP/1.1 {code}"],  aHeaders);

        return new DResponse(aHeaders, body);
    }
    
    // Add a mock response for a POST request.
    void mockClientPost(string urlToMock, Response responseToMock, Json[string] additionalOptions = null) {
        Client.addMockResponse("POST", urlToMock, responseToMock, additionalOptions);
    }
    
    // Add a mock response for a GET request.
    void mockClientGet(string urlToMock, Response response, Json[string] responseOptions = null) {
        Client.addMockResponse("GET", urlToMock, response, responseOptions);
    }
    
    // Add a mock response for a PATCH request.
    void mockClientPatch(string urlToMock, Response response, Json[string] responseOptions = null) {
        Client.addMockResponse("PATCH", urlToMock, response, responseOptions);
    }
    
    /**
     * Add a mock response for a PUT request.
     * Params:
     * string aurl The URL to mock
     * @param \UIM\Http\Client\Response response The response for the mock.
     * @param Json[string] options Additional options. See Client.addMockResponse()
     */
    void mockClientPut(string urlToMock, Response response, Json[string] responseOptions = null) {
        Client.addMockResponse("PUT", urlToMock, response, responseOptions);
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

