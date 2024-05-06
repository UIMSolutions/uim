module uim.collections.classes.iterators.unique;

import uim.collections;

@safe:

/**
 * Creates a filtered iterator from another iterator. The filtering is done by
 * passing a callback auto to each of the elements and taking them out if
 * the value returned is not unique.
 */
class DUniqueIterator : DCollection {
    /**
     * Creates a filtered iterator using the callback to determine which items are
     * accepted or rejected.
     *
     * The callback is passed the value as the first argument and the key as the
     * second argument.
     * Params:
     * @param callable aCallback Callback.
     * /
    this(Json[string] itemToFilter, callable aCallback) {
        if (!cast(Iterator)itemToFilter) {
            itemToFilter = new DCollection(itemToFilter);
        }
        auto myunique = null;
        auto myuniqueValues = null;
        itemToFilter.byKeyValue
            .each!((kv) {
                auto compareValue = aCallback(kv.value, kv.key);
                if (!in_array(compareValue, uniqueValues, true)) {
                    unique[kv.key] = kv.value;
                    uniqueValues ~= compareValue;
                }
            }); 
        super(unique);
    } */
}
