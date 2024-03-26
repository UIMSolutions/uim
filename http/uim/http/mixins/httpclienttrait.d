module uim.http.mixins.httpclienttrait;

import uim.http;

@safe:

/*
 * Define mock responses and have mocks automatically cleared.
 * /
template HttpClientTemplate {
    /**
     * Resets mocked responses
     *
     * @after
     * /
    void cleanupMockResponses() {
        Client.clearMockResponses();
    }
    
    /**
     * Create a new response.
     * Params:
     * int code The response code to use. Defaults to 200
     * @param string[] aHeaders A list of headers for the response. Example `Content-Type: application/json`
     * @param string abody The body for the response.
     *  \UIM\Http\Client\Response
     * /
    Response newClientResponse(int code = 200, array  aHeaders = [], string abody= null) {
         aHeaders = chain(["HTTP/1.1 {code}"],  aHeaders);

        return new Response( aHeaders, body);
    }
    
    /**
     * Add a mock response for a POST request.
     * Params:
     * string aurl The URL to mock
     * @param \UIM\Http\Client\Response response The response for the mock.
     * @param IData[string] options Additional options. See Client.addMockResponse()
     * /
    void mockClientPost(string aurl, Response response, IData[string] options = null) {
        Client.addMockResponse("POST", url, response, options);
    }
    
    /**
     * Add a mock response for a GET request.
     * Params:
     * string aurl The URL to mock
     * @param \UIM\Http\Client\Response response The response for the mock.
     * @param IData[string] options Additional options. See Client.addMockResponse()
     * /
    void mockClientGet(string aurl, Response response, IData[string] options = null) {
        Client.addMockResponse("GET", url, response, options);
    }
    
    /**
     * Add a mock response for a PATCH request.
     * Params:
     * string aurl The URL to mock
     * @param \UIM\Http\Client\Response response The response for the mock.
     * @param IData[string] options Additional options. See Client.addMockResponse()
     * /
    void mockClientPatch(string aurl, Response response, IData[string] options = null) {
        Client.addMockResponse("PATCH", url, response, options);
    }
    
    /**
     * Add a mock response for a PUT request.
     * Params:
     * string aurl The URL to mock
     * @param \UIM\Http\Client\Response response The response for the mock.
     * @param IData[string] options Additional options. See Client.addMockResponse()
     * /
    void mockClientPut(string aurl, Response response, IData[string] options = null) {
        Client.addMockResponse("PUT", url, response, options);
    }
    
    /**
     * Add a mock response for a DELETE request.
     * Params:
     * string aurl The URL to mock
     * @param \UIM\Http\Client\Response response The response for the mock.
     * @param IData[string] options Additional options. See Client.addMockResponse()
     * /
    void mockClientDelete(string aurl, Response response, IData[string] options = null) {
        Client.addMockResponse("DELETE", url, response, options);
    }
}
*/
