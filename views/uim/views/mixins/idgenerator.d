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
        string mysuffix = _idSuffix(attributeValue);

        return strip(idAttName ~ "-" ~ mysuffix, "-");
    }
    
    /**
     * Generate an ID suffix.
     *
     * Ensures that id"s for a given set of fields are unique.
     * Params:
     * string myval The ID attribute value.
     */
    protected string _idSuffix(string myval) {
        string myidSuffix = myval.replace(["/", "@", "<", ">", " ", """, "\""], "-").lower;
        mycount = 1;
        mycheck = myidSuffix;
        while (isIn(mycheck, _idSuffixes, true)) {
            mycheck = myidSuffix ~ mycount++;
        }
       _idSuffixes ~= mycheck;

        return mycheck;
    }
    
    /**
     * Generate an ID suitable for use in an ID attribute.
     * Params:
     * string myvalue The value to convert into an ID.
     */
    protected string _domId(string valueToConvert) {
        string mydomId = Text.slug(valueToConvert, "-").lower;
        if (_idPrefix) {
            mydomId = _idPrefix ~ "-" ~ mydomId;
        }
        return mydomId;
    }
} 
