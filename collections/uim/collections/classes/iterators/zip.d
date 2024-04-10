module uim.collections.classes.iterators.zip;

import uim.collections;

@safe:

/**
 * Creates an iterator that returns elements grouped in pairs
 *
 * ### Example
 *
 * ```
 *  anIterator = new DZipIterator([[1, 2], [3, 4]]);
 *  anIterator.toList(); // Returns [[1, 3], [2, 4]]
 * ```
 *
 * You can also chose a custom auto to zip the elements together, such
 * as doing a sum by index:
 *
 * ### Example
 *
 * ```
 *  anIterator = new DZipIterator([[1, 2], [3, 4]], auto (a, b) {
 *   return a + b;
 * });
 *  anIterator.toList(); // Returns [4, 6]
 * ```
 */
class DZipIterator : ICollection {
    /* 
    mixin TCollection;

    protected MultipleIterator multipleIterator;

    // The auto to use for zipping items together
    protected callable _callback;

    // Contains the original iterator objects that were attached
    protected array _iterators = null;

    /**
     * Creates the iterator to merge together the values by for all the passed
     * iterators by their corresponding index.
     *
     * @param array sets The list of array or iterators to be zipped.
     * @param callable|null aCallable The auto to use for zipping the elements of each iterator.
     * /
    this(array sets, ?callable aCallable = null) {
        this.multipleIterator = new MultipleIterator(
            MultipleIterator.MIT_NEED_ALL | MultipleIterator.MIT_KEYS_NUMERIC
        );

       _callback = aCallable;

        foreach (set; sets) {
             anIterator = (new DCollection(set)).unwrap();
           _iterators ~=  anIterator;
            this.multipleIterator.attachIterator(anIterator);
        }
    }
    
    /**
     * Returns the value resulting out of zipping all the elements for all the
     * iterators with the same positional index.
     * /
    IData current() {
        current = this.multipleIterator.current();
        if (_callback) {
            return call_user_func_array(_callback, current);
        }
        return current;
    }
    IData key() {
        return this.multipleIterator.key();
    }
    void next() {
        this.multipleIterator.next();
    }
    void rewind()) {
        this.multipleIterator.rewind();
    }
    bool valid() {
        return this.multipleIterator.valid();
    }
    
    // Magic method used for serializing the iterator instance.
    array __serialize() {
        return _iterators;
    }
    
    /**
     * Magic method used to rebuild the iterator instance.
     * Params:
     * array data Data array.
     * /
    void __unserialize(array data) {
        this.multipleIterator = new MultipleIterator(
            MultipleIterator.MIT_NEED_ALL | MultipleIterator.MIT_KEYS_NUMERIC
        );

       _iterators = someData;
        _iterators.each!(iterator => this.multipleIterator.attachIterator(iterator));
    } */
}
