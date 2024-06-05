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
                string trimedKey = strip(explodedParam[0]);
                auto trimedValue = strip(explodedParam[1], "'");
                if (trimedKey == "title*") {
                    // See https://www.rfc-editor.org/rfc/rfc8187#section-3.2.3
                    preg_match("/(.*)\'(.*)\'(.*)/i", trimedValue, matches);
                    trimedValue = [
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
        accept = null;
        if (!headerValue) {
            return accept;
        }
        string[] aHeaders = headerValue.split(",");
        foreach (array_filter(aHeaders) as aValue) {
            prefValue = "1.0";
            aValue = strip(aValue);

            semiPos = indexOf(aValue, ";");
            if (semiPos != false) {
                string[] params = aValue.split(";");
                aValue = strip(params[0]);
                params.each!((param) {
                    size_t qPos = indexOf(param, "q=");
                    if (qPos != false) {
                        prefValue = substr(param, qPos + 2);
                    }
                });
            }
            if (!isSet(accept[prefValue])) {
                accept[prefValue] = null;
            }
            if (prefValue) {
                accept[prefValue] ~= aValue;
            }
        }
        krsort(accept);

        return accept;
    }
    
    /**
     * authenticateHeader = The WWW-Authenticate header
     */
    static Json[string] parseWwwAuthenticate(string authenticateHeader) {
        preg_match_all(
            "@(\w+)=(?:(?:')([^"]+)"|([^\s,]+))@",
            authenticateHeader,
            matches,
            PREG_SET_ORDER
       );

        auto result;
        matches.each!(match => result[match[1]] = match[3] ? match[3] : match[2]);

        return result;
    }
}
