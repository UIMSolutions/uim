/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.http.classes.requests.requestfactory;import uim.http;@safe:// Factory for creating request instances.class DRequestFactory { //} : IRequestFactory {    // Create a new request.    IRequest createRequest(string httpMethod, string requestUri) {        return new DRequest(requestUri, httpMethod);    }}