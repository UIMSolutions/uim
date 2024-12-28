/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module http.uim.http.tests.cookie;

import uim.http;
@safe:

bool testCookie(ICookie cookie) {
    assert(cookie !is null, "Cookie is null");

    return true;
}
