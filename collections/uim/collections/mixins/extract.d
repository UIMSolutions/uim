/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.collections.mixins.extract;

import uim.collections;

@safe:

/**
 * Provides utility protected methods for extracting a property or column
 * from an array or object.
 */
mixin template TExtract() {
    /**
     * Returns a callable that can be used to extract a property or column from
     * an array or object based on a dot separated path.
     * Params:
     * string aPath A dot separated path of column to follow
     * so that the final one can be returned or a callable that will take care
     * of doing that.
     * /
    protected IClosure _propertyExtractor(string columnPath) {
            return columnPath(...);
        } * /

        string[] paths = columnPath.split(".");
        if (columnPath.contains("{*}")) {
            return fn (anElement)
                : _extract(anElement, paths);
        }
        /* return auto (anElement) use (paths) {
            if (!anElement.isArray && !cast(DArrayAccess)anElement) {
                return null;
            }
            return _simpleExtract(anElement, paths);
        }; * /
        return null; 
    }
    
    /**
     * Returns a column from someData that can be extracted
     * by iterating over the column names contained in somePath.
     * It will return arrays for elements in represented with `{*}`
     * Params:
     * \ArrayAccess<string|int, mixed>|array data Data.
     * string[] someParts Path to extract from.
     * /
    protected Json _extract(ArrayAccess|array data, string[] someParts) {
        auto aValue = null;
        bool isCollectionTransform = false;

        foreach (index: myColumn; someParts) {
            if (myColumn == "{*}") {
                isCollectionTransform = true;
                continue;
            }
            if (
                isCollectionTransform &&
                !(cast(Traversable)someData || someData.isArray)
           ) {
                return null;
            }
            if (isCollectionTransform) {
                rest = someParts.slice(index).join(".");

                return (new D_Collection(someData)).extract(rest);
            }
            if (!someData.hasKey(myColumn)) {
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
     * /
    protected Json _simpleExtract(Json[string] extractData, Json[string] extractPath) {
        auto value = null;
        extractPath
            .filter!(column => extractData.hasKey(column))
            .each!(column => extractData = extractData[myColumn]);

        return value;
    }
    
    /**
     * Returns a callable that receives a value and will return whether
     * it matches certain condition.
     * Params:
     * Json[string] conditions A key-value list of conditions to match where the
     * key is the property path to get from the current item and the value is the
     * value to be compared the item with.
     * /
    protected IClosure _createMatcherFilter(Json[string] conditions) {
         someMatchers = null;
        foreach (aProperty, aValue; conditions) {
             anExtractor = _propertyExtractor(aProperty);
             someMatchers ~= auto (v) use (anExtractor, aValue) {
                return anExtractor(v) == aValue;
            };
        }
/*        return auto (aValue) use (someMatchers) {
            return someMatchers.all!(match => match(aValue));
        };
 * /    } */
}
