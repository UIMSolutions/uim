module uim.routings.classes.functions_;

import uim.routings;

@safe:

/**
 * Returns an array URL from a route path string.
 *
 * @param string aPath Route path.
 * @param Json[string] params An array specifying any additional parameters.
 *  Can be also any special parameters supported by `Router.url()`.
 * /
array urlArray(string aPath, Json[string] params = []) {
    url = Router.parseRoutePath(somePath);
    url += [
        "plugin": Json(false),
        "prefix": Json(false),
    ];

    return url + params;
}
/**
 * Convenience wrapper for Router.url().
 *
 * @param \Psr\Http\Message\IUri|string[] url An array specifying any of the following:
 *  "controller", "action", "plugin" additionally, you can provide routed
 *  elements or query string parameters. If string it can be name any valid url
 *  string or it can be an IUri instance.
 * @param bool full If true, the full base URL will be prepended to the result.
 *  Default is false.
 * /
string url(IUri|string[] url = null, bool full = false) {
    return Router.url(url, full);
}
*/