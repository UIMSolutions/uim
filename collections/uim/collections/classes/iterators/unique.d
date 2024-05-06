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
     * Json[string] someItems The items to be filtered.
     * @param callable aCallback Callback.
     * /
    this(Json[string] someItems, callable aCallback) {
        if (!cast(Iterator)someItems) {
            someItems = new DCollection(someItems);
        }
        auto myunique = null;
        auto myuniqueValues = null;
        someItems.byKeyValue
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
