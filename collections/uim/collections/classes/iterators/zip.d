/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.collections.classes.iterators.zip;

import uim.collections;

@safe:

/**
 * Creates an iterator that returns elements grouped in pairs
 *
 * ### Example
 *
 * ```
 * anIterator = new DZipIterator([[1, 2], [3, 4]]);
 * anIterator.toList(); // Returns [[1, 3], [2, 4]]
 * ```
 *
 * You can also chose a custom auto to zip the elements together, such
 * as doing a sum by index:
 *
 * ### Example
 *
 * ```
 * anIterator = new DZipIterator([[1, 2], [3, 4]], auto (a, b) {
 *  return a + b;
 * });
 * anIterator.toList(); // Returns [4, 6]
 * ```
 */
class DZipIterator : I_Collection {
    mixin TCollection;

    /* 
    protected DMultipleIterator multipleIterator;

    // The auto to use for zipping items together
    protected callable _callback;

    // Contains the original iterator objects that were attached
    protected Json[string] _iterators = null;

    /**
     * Creates the iterator to merge together the values by for all the passed
     * iterators by their corresponding index.
     * /
    this(Json[string] listToZip, callable aCallable = null) {
        _multipleIterator = new DMultipleIterator(
            MultipleIterator.MIT_NEED_ALL | MultipleIterator.MIT_KEYS_NUMERIC
       );

       _callback = aCallable;

        listToZip.each!((set) {
             anIterator = (new D_Collection(set)).unwrap();
           _iterators ~= anIterator;
            _multipleIterator.attachIterator(anIterator);
        });
    }
    
    /**
     * Returns the value resulting out of zipping all the elements for all the
     * iterators with the same positional index.
     */
    Json currentValue() {
        auto current = Json(null); /* _multipleIterator.currentValue();
        if (_callback) {
            return call_user_func_array(_callback, current);
        } */
        return current;
    }

    Json key() {
        return Json(null);
        /* 
        return _multipleIterator.key(); */
    }

    void next() {
        /* _multipleIterator.next(); */
    }

    void rewind() {
        /* _multipleIterator.rewind(); */
    }

    bool valid() {
        return false;
        /* return _multipleIterator.valid(); */
    }

    // Magic method used for serializing the iterator instance.
    Json[string] __serialize() {
        // return _iterators;
        return null;
    }

    /**
     * Magic method used to rebuild the iterator instance.
     * Params:
     * Json[string] data Data array.
     */
    void __unserialize(Json[string] data) {
        /* _multipleIterator = new DMultipleIterator(
            MultipleIterator.MIT_NEED_ALL | MultipleIterator.MIT_KEYS_NUMERIC
       );

       _iterators = someData;
        _iterators.each!(iterator => _multipleIterator.attachIterator(iterator)); */
    }
}
