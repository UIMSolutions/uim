module uim.collections;

import uim.collections;

@safe:

/**
 * Provides utility protected methods for extracting a property or column
 * from an array or object.
 */
template ExtractTemplate {
    /**
     * Returns a callable that can be used to extract a property or column from
     * an array or object based on a dot separated path.
     * Params:
     * string aPath A dot separated path of column to follow
     * so that the final one can be returned or a callable that will take care
     * of doing that.
     */
    protected Closure _propertyExtractor(string columnPath) {
        if (!isString(somePath)) {
            return somePath(...);
        }

        string[] someParts = somePath.split(".");
        if (columnPath.has("{*}")) {
            return fn (anElement)
                : _extract(anElement, someParts);
        }
        return auto (anElement) use (someParts) {
            if (!isArray(anElement) && !cast(ArrayAccess)anElement) {
                return null;
            }
            return _simpleExtract(anElement, someParts);
        };
    }
    
    /**
     * Returns a column from someData that can be extracted
     * by iterating over the column names contained in somePath.
     * It will return arrays for elements in represented with `{*}`
     * Params:
     * \ArrayAccess<string|int, mixed>|array data Data.
     * string[] someParts Path to extract from.
     */
    protected Json _extract(ArrayAccess|array data, string[] someParts) {
        auto aValue = null;
        bool isCollectionTransform = false;

        foreach (anI: myColumn; someParts) {
            if (myColumn == "{*}") {
                isCollectionTransform = true;
                continue;
            }
            if (
                isCollectionTransform &&
                !(cast(Traversable)someData || isArray(someData))
            ) {
                return null;
            }
            if (isCollectionTransform) {
                rest = array_slice(someParts,  anI).join(".");

                return (new Collection(someData)).extract(rest);
            }
            if (!someData.isSet(myColumn)) {
                return null;
            }
            aValue = someData[myColumn];
            someData = aValue;
        }
        return aValue;
    }
    
    /**
     * Returns a column from someData that can be extracted
     * by iterating over the column names contained in somePath
     * Params:
     * \ArrayAccess<string|int, mixed>|array data Data.
     * @param string[] someParts Path to extract from.
     */
    protected Json _simpleExtract(ArrayAccess|array data, array someParts) {
        auto value = null;
        someParts
            .filter!(column => someData.isSet(column))
            .each!((column) {
                value = someData[myColumn];
                someData = value;
            });

        return value;
    }
    
    /**
     * Returns a callable that receives a value and will return whether
     * it matches certain condition.
     * Params:
     * array conditions A key-value list of conditions to match where the
     * key is the property path to get from the current item and the value is the
     * value to be compared the item with.
     */
    protected Closure _createMatcherFilter(array conditions) {
         someMatchers = [];
        foreach (aProperty, aValue; conditions) {
             anExtractor = _propertyExtractor(aProperty);
             someMatchers ~= auto ( v) use (anExtractor, aValue) {
                return anExtractor( v) == aValue;
            };
        }
        return auto (aValue) use (someMatchers) {
            foreach ($match; someMatchers) {
                if (!$match(aValue)) {
                    return false;
                }
            }
            return true;
        };
    }
}
