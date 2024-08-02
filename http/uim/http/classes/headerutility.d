module uim.http.classes.headerutility;

import uim.http;

@safe:

// Provides helper methods related to HTTP headers
class DHeaderUtility {
    /**
     * Get an array representation of the HTTP Link header values.
     * Params:
     * Json[string] linkHeaders An array of Link header strings.
     */
    static Json[string] parseLinks(Json[string] linkHeaders) {
        auto result = linkHeaders
            .map!(linkHeader => parseLinkItem(linkHeader)).array;

        return result;
    }
    
    /**
     * Parses one item of the HTTP link header into an array
     * Params:
     * string avalue The HTTP Link header part
     */
    protected static Json[string] parseLinkItem(string headerPart) {
        preg_match("/<(.*)>[; ]?[; ]?(.*)?/i", headerPart, matches);

        auto myUrl = matches[1];
        auto myParsedParams = ["link": myUrl];

        auto params = matches[2];
        if (params) {
            params.split(";").each!((param) {
                string[] explodedParam = param.split("=");
                string trimedKey = explodedParam[0].strip;
                auto trimedValue = explodedParam[1].strip("'");
                if (trimedKey == "title*") {
                    // See https://www.rfc-editor.org/rfc/rfc8187#section-3.2.3
                    preg_match("/(.*)\'(.*)\'(.*)/i", trimedValue, matches);
                    auto trimedValue = [
                        "language": matches[2],
                        "encoding": matches[1],
                        "value": urldecode(matches[3]),
                    ];
                }
                myParsedParams[trimedKey] = trimedValue;
            });
        }
        return myParsedParams;
    }
    
    // Parse the Accept header value into weight: value mapping.
    static string[][string] parseAccept(string headerValue) {
        auto accept = null;
        if (!headerValue) {
            return accept;
        }
        string[] aHeaders = headerValue.split(",");
        foreach (aValue; filterValues((aHeaders)) {
            auto prefValue = "1.0";
            auto aValue = aValue.strip;

            semiPos = indexOf(aValue, ";");
            if (semiPos == true) {
                string[] params = aValue.split(";");
                aValue = params[0].strip;
                params.each!((param) {
                    size_t qPos = indexOf(param, "q=");
                    if (qPos == true) {
                        prefValue = subString(param, qPos + 2);
                    }
                });
            }
            if (!accept.hasKey(prefValue)) {
                accept[prefValue] = null;
            }
            if (prefValue) {
                accept[prefValue).concat( aValue;
            }
        }
        krsort(accept);

        return accept;
    }
    
    // authenticateHeader = The WWW-Authenticate header
    static Json[string] parseWwwAuthenticate(string authenticateHeader) {
        /* preg_match_all(
            "@(\w+)=(?:(?:')([^"]+)"|([^\s,]+))@",
            authenticateHeader,
            matches,
            PREG_SET_ORDER
       ); */

        Json[string] result;
        matches.each!(match => result[match[1]] = match[3] ? match[3] : match[2]);

        return result;
    }
}
