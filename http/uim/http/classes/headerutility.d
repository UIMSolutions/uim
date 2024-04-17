module uim.http.classes.headerutility;

import uim.http;

@safe:

// Provides helper methods related to HTTP headers
class DHeaderUtility {
    /**
     * Get an array representation of the HTTP Link header values.
     * Params:
     * array linkHeaders An array of Link header strings.
     * /
    static array parseLinks(array linkHeaders) {
        auto result = linkHeaders
            .map!(linkHeader => parseLinkItem(linkHeader)).array;

        return result;
    }
    
    /**
     * Parses one item of the HTTP link header into an array
     * Params:
     * string avalue The HTTP Link header part
     * /
    protected static IData[string] parseLinkItem(string headerPart) {
        preg_match("/<(.*)>[; ]?[; ]?(.*)?/i", headerPart, matches);

        auto myUrl = matches[1];
        auto myParsedParams = ["link": myUrl];

        auto params = matches[2];
        if (params) {
            params.split(";").each!((param) {
                auto explodedParam = param.split("=");
                auto trimedKey = trim(explodedParam[0]);
                auto trimedValue = trim(explodedParam[1], "'");
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
    
    /**
     * Parse the Accept header value into weight: value mapping.
     * Params:
     * string aheader The header value to parse
     * /
    static string[][string] parseAccept(string headerValue) {
        accept = null;
        if (!headerValue) {
            return accept;
        }
        string[] aHeaders = headerValue.split(",");
        foreach (array_filter(aHeaders) as aValue) {
            prefValue = "1.0";
            aValue = trim(aValue);

            semiPos = strpos(aValue, ";");
            if (semiPos != false) {
                string[] params = split(";", aValue);
                aValue = trim(params[0]);
                foreach (params as param) {
                    qPos = strpos(param, "q=");
                    if (qPos != false) {
                        prefValue = substr(param, qPos + 2);
                    }
                }
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
     * /
    static array parseWwwAuthenticate(string authenticateHeader) {
        preg_match_all(
            "@(\w+)=(?:(?:')([^"]+)"|([^\s,]+))@",
            authenticateHeader,
            matches,
            PREG_SET_ORDER
        );

        auto result;
        matches.each!(match => result[match[1]] = match[3] ? match[3] : match[2]);

        return result;
    } */
}
