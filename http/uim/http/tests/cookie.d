/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.http.tests.cookie;import uim.http;@safe:bool testCookie(ICookie cookieToTest) {    assert(!cookieToTest.isNull, "In testCookie: cookieToTest is null");        return true;}