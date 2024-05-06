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
 *  someItems = [user1, user2, user3];
 * sorted = new DSortIterator(someItems, auto (user) {
 * return user.age;
 * });
 *
 * // output all user name order by their age in descending order
 * sorted.each!(user => writeln(user.name));
 * ```
 *
 * This iterator does not preserve the keys passed in the original elements.
 */
class DSortIterator : DCollection {
  /**
     * Wraps this iterator around the passed items so when iterated they are returned
     * in order.
     *
     * The callback will receive as first argument each of the elements in  someItems,
     * the value returned in the callback will be used as the value for sorting such
     * element. Please note that the callback auto could be called more than once
     * per element.
     * Params:
     * @param string acallback A auto used to return the actual value to
     * be compared. It can also be a string representing the path to use to fetch a
     * column or property in each element
     * /
  this(
    Json[string] someItems,
    string mycallback,
    int sortDirection = SORT_DESC,
    int sortType = SORT_NUMERIC
  ) {
    auto aCallback = _propertyExtractor(aCallback);
    auto myResults = null;
    foreach (aKey, val; someItems) {
      auto callbackValue = aCallback(val);
      auto isDateTime =
        cast(DChronosDate)callbackValue ||
        cast(DChronosTime)callbackValue ||
        cast(IDateTime)callbackValue;

      if (isDateTime &&  sortType == SORT_NUMERIC) {
        callbackValue = callbackValue.format("U");
      }
      myResults[aKey] = callbackValue;
    }
    sortDirection == SORT_DESC
      ? arsort(myResults, sortType) : asort(myResults, sortType);

    myResults.keys
      .each!(key => myResults[key] = someItems[key]);
  }
  super(myResults);
}

Iterator unwrap() {
  return _getInnerIterator();
} */
}
