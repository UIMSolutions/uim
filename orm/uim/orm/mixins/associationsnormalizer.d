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
        foreach (tableName, options; includedAssociations) {
            auto mypointer = &result;

/*             if (tableName.isInteger) {
                tableName = options;
                options = null;
            } */
            if (!my.has(e, ".")) {
                result[tableName] = options;
                continue;
            }
            string[] paths = tableName.splits(".");
            tableName = paths.pop;
            auto myfirst = paths.shift;
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
            mypointer["associated"] += [tableName: []];
            mypointer["associated"][tableName] = options + mypointer["associated"][tableName];
        }
        
        return result.get("associated", result;
    }
}
