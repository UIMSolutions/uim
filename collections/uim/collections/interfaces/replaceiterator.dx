module uim.collections.iterators;

import uim.collections;

@safe:

/**
 * Creates an iterator from another iterator that will modify each of the values
 * by converting them using a callback function.
 */
class ReplaceIterator : Collection {
  // The callback auto to be used to transform values
  protected callable _callback;

  // A reference to the internal iterator this object is wrapping.
  protected Traversable _innerIterator;

  /**
     * Creates an iterator from another iterator that will modify each of the values
     * by converting them using a callback function.
     *
     * Each time the callback is executed it will receive the value of the element
     * in the current iteration, the key of the element and the passed  someItems iterator
     * as arguments, in that order.
     * Params:
     * iterable someItems The items to be filtered.
     * @param callable aCallback Callback.
     */
  this(iterable someItems, callableaCallback) {
   _callback = aCallback;
  super(someItems);
   _innerIterator = this.getInnerIterator();
  }

  // Returns the value returned by the callback after passing the current value in the iteration
  Json current() {
    aCallback = _callback;

    return aCallback(super.current(), this.key(), _innerIterator);
  }

  Iterator unwrap() {
     anIterator = _innerIterator;

    if (cast(ICollection) anIterator) {
       anIterator =  anIterator.unwrap();
    }
    if (anIterator.class != ArrayIterator.class) {
      return this;
    }
    
    // ArrayIterator can be traversed strictly.
    // Let`s do that for performance gains

    aCallback = _callback;
    auto res = [];
    anIterator.byKeyValue
      .each!(kv => res[kv.key] = aCallback(kv.value, kv.key,  anIterator));
    
    return new ArrayIterator(res);
  }
}
