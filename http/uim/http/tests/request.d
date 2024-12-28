/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module http.uim.http.tests.request;

import uim.http;
@safe:

bool testHTTPRequest(IHTTPRequest request) {
    assert(request !is null, "HTTPRequest is null");

    return true;
}
