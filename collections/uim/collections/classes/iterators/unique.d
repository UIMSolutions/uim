module uim.collections.classes.iterators.unique;

import uim.collections;

@safe:

/**
 * Creates a filtered iterator from another iterator. The filtering is done by
 * passing a callback auto to each of the elements and taking them out if
 * the value returned is not unique.
 */
class DUniqueIterator : D_Collection {
    /**
     * Creates a filtered iterator using the callback to determine which items are
     * accepted or rejected.
     *
     * The callback is passed the value as the first argument and the key as the
     * second argument.
     * /
    this(Json[string] itemToFilter, callable aCallback) {
        if (!cast(Iterator)itemToFilter) {
            itemToFilter = new D_Collection(itemToFilter);
        }
        auto myunique = null;
        auto myuniqueValues = null;
        itemToFilter.byKeyValue
            .each!((kv) {
                auto compareValue = aCallback(kv.value, kv.key);
                if (!compareValue.isIn(uniqueValues)) {
                    unique.set(kv.key, kv.value);
                    uniqueValues ~= compareValue;
                }
            }); 
        super(unique);
    } */
}
