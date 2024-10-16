/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.collections.classes.iterators.sort;

import uim.collections;

@safe:

/**
 * An iterator that will return the passed items in order. The order is given by
 * the value returned in a callback auto that maps each of the elements.
 *
 * ### Example:
 *
 * ```
 * someItems = [user1, user2, user3];
 * sorted = new DSortIterator(someItems, auto (user) {
 * return user.age;
 * });
 *
 *  output all user name order by their age in descending order
 * sorted.each!(user => writeln(user.name));
 * ```
 *
 * This iterator does not preserve the keys passed in the original elements.
 */
class DSortIterator : D_Collection {
  /**
     * Wraps this iterator around the passed items so when iterated they are returned
     * in order.
     *
     * The callback will receive as first argument each of the elements in  someItems,
     * the value returned in the callback will be used as the value for sorting such
     * element. Please note that the callback auto could be called more than once
     * per element.
     * /
  this(
    Json[string] someItems,
    string mycallback,
    int sortDirection = 0, //= SORT_DESC,
    int sortType = 0 // SORT_NUMERIC
  ) {
    auto aCallback = _propertyExtractor(aCallback);
    auto myResults = null;
    
    someItems.byKeyValue.each!((kv) {
      auto callbackValue = aCallback(kv.value);
      auto isDateTime =
        cast(DChronosDate) callbackValue ||
        cast(DChronosTime) callbackValue ||
        cast(IDateTime) callbackValue;

      if (isDateTime && sortType == SORT_NUMERIC) {
        callbackValue = callbackValue.format("U");
      }
      myResults.set(kv.key, callbackValue);
    });
    sortDirection == SORT_DESC
      ? arsort(myResults, sortType) : asort(myResults, sortType);

    myResults.keys
      .each!(key => myResults.set(key, someItems.get(key));

  super(myResults);
}

/* Iterator unwrap() {
  return _getInnerIterator();
} */
}
