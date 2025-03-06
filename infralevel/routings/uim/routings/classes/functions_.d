/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.routings.classes.functions_;

import uim.routings;

@safe:

// Returns an array URL from a route path string.
Json[string] urlArray(string path, Json[string] params= null) {
/*     auto url = Router.parseRoutePath(somePath);
    url
        .merge("plugin", false)
        .merge("prefix", false);

    return url + params;
 */
 return null; 
 }

// Convenience wrapper for Router.url().
string url(/* IUri| */string[] url = null, bool isFull = false) {
    return Router.url(url, isFull);
}