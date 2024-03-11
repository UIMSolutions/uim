module uim.orm.uim.orm.mixins.associationsnormalizertrait;

import uim.orm;

@safe:

/**
 * Contains methods for parsing the associated tables array that is typically
 * passed to a save operation
 */
template AssociationsNormalizerTemplate {
    /**
     * Returns an array out of the original passed associations list where dot notation
     * is transformed into nested arrays so that they can be parsed by other routines
     * Params:
     * string[] myassociations The array of included associations.
     */
    protected array _normalizeAssociations(string[] myassociations) {
        auto result;
        foreach ((array)myassociations as mytable: options) {
            mypointer = &result;

            if (mytable.isInt) {
                mytable = options;
                options = [];
            }
            if (!my.has(e, ".")) {
                result[mytable] = options;
                continue;
            }
            string[] mypath = mytable.splits(".");
            mytable = array_pop(mypath);
            myfirst = array_shift(mypath);
            assert(myfirst.isString);

            mypointer += [myfirst: []];
            mypointer = &mypointer[myfirst];
            mypointer += ["associated": []];

            mypath.each!((myt) {
                mypointer += ["associated": []];
                mypointer["associated"] += [myt: []];
                mypointer["associated"][myt] += ["associated": []];
                mypointer = &mypointer["associated"][myt];
            });
            mypointer["associated"] += [mytable: []];
            mypointer["associated"][mytable] = options + mypointer["associated"][mytable];
        }
        return result["associated"] ?? result;
    }
}
