module uim.orm.mixins.associationsnormalizer;

import uim.orm;

@safe:

/**
 * Contains methods for parsing the associated tables array that is typically
 * passed to a save operation
 */
mixin template TAssociationsNormalizer() {
    /**
     * Returns an array out of the original passed associations list where dot notation
     * is transformed into nested arrays so that they can be parsed by other routines
     */
     protected Json[string] _normalizeAssociations(string[string] includedAssociations) {
        Json[string] result;
        foreach (mytable, options; includedAssociations) {
            mypointer = &result;

            if (mytable.isInt) {
                mytable = options;
                options = null;
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
            mypointer += ["associated": Json.emptyArray];

            mypath.each!((myt) {
                mypointer += ["associated": Json.emptyArray];
                mypointer["associated"] += [myt: []];
                mypointer["associated"][myt] += ["associated": Json.emptyArray];
                mypointer = &mypointer["associated"][myt];
            });
            mypointer["associated"] += [mytable: []];
            mypointer["associated"][mytable] = options + mypointer["associated"][mytable];
        }
        
        return result["associated"] ?? result;
    }
}
