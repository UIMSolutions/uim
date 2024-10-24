/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
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
     * Only qualifiers will be extracted, any other accept extensions will be
     * discarded as they are not frequently used.
     */
    Json[string] parseAccept(IRequest request) {
        auto acceptHeader = request.getHeaderLine("Accept");

        return _parseQualifiers(acceptHeader);
    }
    
    /**
     * Parse the Accept-Language header
     *
     * Only qualifiers will be extracted, other extensions will be ignored
     * as they are not frequently used.
     * Params:
     * \Psr\Http\Message\IRequest request The request to get an accept from.
     */
    Json[string] parseAcceptLanguage(IRequest request) {
        auto langHeader = request.getHeaderLine("Accept-Language");
        return _parseQualifiers(langHeader);
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
     */
    string preferredType(IRequest request, string[] supportedContenttypeChoices = null) {
        auto parsed = this.parseAccept(request);
        if (parsed.isEmpty) {
            return null;
        }

        if (supportedChoices.isEmpty) {
            auto preferred = parsed.shift;
            return preferred[0];
        }

        foreach (acceptTypes; parsed) {
            if (auto common = intersect(acceptTypes, supportedContenttypeChoices)) {
                return common.shift;
            }
        }
        return null;
    }
    
    /**
     * Get the normalized list of accepted languages
     *
     * Language codes in the request will be normalized to lower case and have
     * `_` replaced with `-`.
     */
    string[] acceptedLanguages(IRequest request) {
        auto raw = this.parseAcceptLanguage(request);
        auto accept = null;
        foreach (languages; raw) {
            foreach (ref lan; languages) {
                if (lang.contains("_")) {
                    lang = lang.replace("_", "-");
                }
                lang = lang.lower;
            }
            accept = chain(accept, languages);
        }
        return accept;
    }
    
    /**
     * Check if the request accepts a given language code.
     * Language codes in the request will be normalized to lower case and have `_` replaced with `-`.
     */
    bool acceptLanguage(IRequest request, string langCode) {
        auto accept = acceptedLanguages(request);
        return isIn(langCode.lower, accept, true);
    }
}
