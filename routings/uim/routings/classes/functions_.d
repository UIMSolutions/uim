module uim.routings.classes.functions_;

import uim.routings;

@safe:

// Returns an array URL from a route path string.
Json[string] urlArray(string path, Json[string] params= null) {
    auto url = Router.parseRoutePath(somePath);
    url += [
        "plugin": false.toJson,
        "prefix": false.toJson,
    ];

    return url + params;
}

// Convenience wrapper for Router.url().
string url(/* IUri| */string[] url = null, bool isFull = false) {
    return Router.url(url, isFull);
}