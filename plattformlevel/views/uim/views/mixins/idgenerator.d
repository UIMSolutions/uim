/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.views.mixins.idgenerator;

import uim.views;

@safe:

/**
 * A mixin template that provides id generating methods to be
 * used in various widget classes.
 */
mixin template TIdGenerator() {
    // Prefix for id attribute.
    protected string _idPrefix = null;

    // A list of id suffixes used in the current rendering.
    protected string[] _idSuffixes;

    // Clear the stored ID suffixes.
    protected void _clearIds() {
       _idSuffixes = null;
    }
    
    /**
     * Generate an ID attribute for an element.
     * Ensures that id"s for a given set of fields are unique.
     */
    protected string _id(string attributename, string attributeValue) {
        auto idAttName = _domId(attributename);
        string suffix = _idSuffix(attributeValue);

        return (idAttName ~ "-" ~ suffix).strip("-");
    }
    
    /**
     * Generate an ID suffix.
     *
     * Ensures that id"s for a given set of fields are unique.
     */
    protected string _idSuffix(string idAttribute) {
        string suffix = idAttribute.replace(["/", "@", "<", ">", " ", "\"", "'"], "-").lower;
        auto counter = 1;
        auto value = suffix;
        while (_idSuffixes.has(value)) {
            value = suffix ~ to!string(counter++);
        }
       _idSuffixes ~= value;

        return value; 
    }
    
    // Generate an ID suitable for use in an ID attribute.
    protected string _domId(string valueToConvert) {
        /* string mydomId = Text.slug(valueToConvert, "-").lower;
        if (_idPrefix) {
            mydomId = _idPrefix ~ "-" ~ mydomId;
        }
        return mydomId; */
        return null;
    }
} 
