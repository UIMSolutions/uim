module uim.http.mixins.httpclienttrait;

import uim.http;

@safe:

// Define mock responses and have mocks automatically cleared.
mixin template THttpClient() {
    // Resets mocked responses
    void cleanupMockResponses() {
        Client.clearMockResponses();
    }
    
    // Create a new response.
    DResponse newClientResponse(int responseCode = 200, Json[string] responseHeaders = null, string responseBody= null) {
        auto responseHeaders = chain(["HTTP/1.1 {code}"],  responseHeaders);
        return new DResponse(responseHeaders, responseBody);
    }
    
    // Add a mock response for a POST request.
    void mockClientPost(string url, Response responseToMock, Json[string] additionalOptions = null) {
        Client.addMockResponse("POST", url, responseToMock, additionalOptions);
    }
    
    // Add a mock response for a GET request.
    void mockClientGet(string url, Response response, Json[string] options = null) {
        Client.addMockResponse("GET", url, response, options);
    }
    
    // Add a mock response for a PATCH request.
    void mockClientPatch(string url, Response response, Json[string] options = null) {
        Client.addMockResponse("PATCH", url, response, options);
    }
    
    // Add a mock response for a PUT request.
    void mockClientPut(string url, DResponse response, Json[string] options = null) {
        Client.addMockResponse("PUT", url, response, options);
    }
    
    // Add a mock response for a DELETE request.
    void mockClientDelete(string url, DResponse response, Json[string] options = null) {
        Client.addMockResponse("DELETE", url, response, options);
    }
}

