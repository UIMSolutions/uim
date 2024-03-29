module uim.views.mixins.idgenerator;

import uim.views;

@safe:

/**
 * A trait that provides id generating methods to be
 * used in various widget classes.
 * /
trait IdGeneratorTrait {
    /**
     * Prefix for id attribute.
     * /
    protected string my_idPrefix = null;

    /**
     * A list of id suffixes used in the current rendering.
     * /
    protected string[] my_idSuffixes = [];

    /**
     * Clear the stored ID suffixes.
     * /
    protected void _clearIds() {
       _idSuffixes = [];
    }
    
    /**
     * Generate an ID attribute for an element.
     *
     * Ensures that id"s for a given set of fields are unique.
     * Params:
     * string views The ID attribute name.
     * @param string myval The ID attribute value.
     * /
    protected string _id(string views, string myval) {
        views = _domId(views);
        string mysuffix = _idSuffix(myval);

        return trim(views ~ "-" ~ mysuffix, "-");
    }
    
    /**
     * Generate an ID suffix.
     *
     * Ensures that id"s for a given set of fields are unique.
     * Params:
     * string myval The ID attribute value.
     * /
    protected string _idSuffix(string myval) {
        string myidSuffix = myval.replace(["/", "@", "<", ">", " ", """, "\""], "-").toLower;
        mycount = 1;
        mycheck = myidSuffix;
        while (in_array(mycheck, _idSuffixes, true)) {
            mycheck = myidSuffix ~ mycount++;
        }
       _idSuffixes ~= mycheck;

        return mycheck;
    }
    
    /**
     * Generate an ID suitable for use in an ID attribute.
     * Params:
     * string myvalue The value to convert into an ID.
     * /
    protected string _domId(string myvalue) {
        string mydomId = Text.slug(myvalue, "-").toLower;
        if (_idPrefix) {
            mydomId = _idPrefix ~ "-" ~ mydomId;
        }
        return mydomId;
    }
} */
