module uim.http.classes.contenttypenegotiation;

import uim.http;

@safe:

/**
 * Negotiates the prefered content type from what the application
 * provides and what the request has in its Accept header.
 */
class DContentTypeNegotiation {
    /**
     * Parse Accept* headers with qualifier options.
     *
     * Only qualifiers will be extracted, any other accept extensions will be
     * discarded as they are not frequently used.
     * Params:
     * \Psr\Http\Message\IRequest request The request to get an accept from.
     * /
    array<string, string[]> parseAccept(IRequest request) {
         aHeader = request.getHeaderLine("Accept");

        return _parseQualifiers(aHeader);
    }
    
    /**
     * Parse the Accept-Language header
     *
     * Only qualifiers will be extracted, other extensions will be ignored
     * as they are not frequently used.
     * Params:
     * \Psr\Http\Message\IRequest request The request to get an accept from.
     * /
    array<string, string[]> parseAcceptLanguage(IRequest request) {
         aHeader = request.getHeaderLine("Accept-Language");

        return _parseQualifiers(aHeader);
    }
    
    // Parse a header value into preference: value mapping
    protected string[][string] parseQualifiers(string headerValue) {
        return HeaderUtility.parseAccept(headerValue);
    }
    
    /**
     * Get the most preferred content type from a request.
     *
     * Parse the Accept header preferences and return the most
     * preferred type. If multiple types are tied in preference
     * the first type of that preference value will be returned.
     *
     * You can expect null when the request has no Accept header.
     * Params:
     * \Psr\Http\Message\IRequest request The request to use.
     * /
    string preferredType(IRequest request, string[] supportedContenttypeChoices = []) {
        auto parsed = this.parseAccept(request);
        if (parsed.isEmpty) {
            return null;
        }
        if (supportedChoices.isEmpty) {
            auto preferred = array_shift(parsed);
            return preferred[0];
        }
        foreach (acceptTypes; parsed ) {
            auto common = array_intersect(acceptTypes, supportedContenttypeChoices);
            if (common) {
                return array_shift(common);
            }
        }
        return null;
    }
    
    /**
     * Get the normalized list of accepted languages
     *
     * Language codes in the request will be normalized to lower case and have
     * `_` replaced with `-`.
     * Params:
     * \Psr\Http\Message\IRequest request The request to read headers from.
     * /
    string[] acceptedLanguages(IRequest request) {
        auto raw = this.parseAcceptLanguage(request);
        auto accept = null;
        foreach (languages; raw) {
            foreach (languages as &lang) {
                if (lang.has("_")) {
                    lang = lang.replace("_", "-");
                }
                lang = lang.toLower;
            }
            accept = chain(accept, languages);
        }
        return accept;
    }
    
    /**
     * Check if the request accepts a given language code.
     *
     * Language codes in the request will be normalized to lower case and have `_` replaced
     * with `-`.
     * Params:
     * \Psr\Http\Message\IRequest request The request to read headers from.
     * @param string alang The language code to check.
     * /
    bool acceptLanguage(IRequest request, string alang) {
        accept = this.acceptedLanguages(request);

        return in_array(lang.toLower, accept, true);
    } */
}
