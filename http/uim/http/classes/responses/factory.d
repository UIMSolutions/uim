/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.http.classes.responses.factory;

import uim.http;

@safe:

// Factory class for creating response instances.
class DResponseFactory /* : IResponseFactory */ {
    // Create a new response.
    IResponse createResponse(int httpStatusCode = 200, string reasonPhrase = "") {
        return (new DResponse()).withStatus(httpStatusCode, reasonPhrase);
    }
}
