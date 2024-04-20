/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.orm.classes.associations.associationsnormalizertrait;

/**
 * Contains methods for parsing the associated tables array that is typically
 * passed to a save operation
 * /
mixin template AssociationsNormalizerTrait
{
    /**
     * Returns an array out of the original passed associations list where dot notation
     * is transformed into nested arrays so that they can be parsed by other routines
     *
     * @param array|string associations The array of included associations.
     * @return array An array having dot notation transformed into nested arrays
     * /
    // TODO protected array _normalizeAssociations(associations) {
        result = null;
        foreach ((array)associations as table: options) {
            pointer = &result;

            if (is_int(table)) {
                table = options;
                options = null;
            }

            if (!indexOf(table, ".")) {
                result[table] = options;
                continue;
            }

            path = explode(".", table);
            table = array_pop(path);
            /** @var string first * /
            first = array_shift(path);
            pointer += [first: []];
            pointer = &pointer[first];
            pointer += ["associated": ArrayData];

            foreach (path as t) {
                pointer += ["associated": ArrayData];
                pointer["associated"] += [t: []];
                pointer["associated"][t] += ["associated": ArrayData];
                pointer = &pointer["associated"][t];
            }

            pointer["associated"] += [table: []];
            pointer["associated"][table] = options + pointer["associated"][table];
        }

        return result["associated"] ?? result;
    }
} */
