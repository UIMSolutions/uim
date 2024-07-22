module uim.collections.classes.iterators.replace;

import uim.collections;

@safe:

/**
 * Creates an iterator from another iterator that will modify each of the values
 * by converting them using a callback function.
 */
class DReplaceIterator : D_Collection {
  /*
  // The callback auto to be used to transform values
  protected callable _callback;

  // A reference to the internal iterator this object is wrapping.
  protected ITraversable _innerIterator;

  /**
     * Creates an iterator from another iterator that will modify each of the values
     * by converting them using a callback function.
     *
     * Each time the callback is executed it will receive the value of the element
     * in the current iteration, the key of the element and the passed  someItems iterator
     * as arguments, in that order.
     * /
  this(Json[string] itemToFilter, callable callableaCallback) {
    _callback = aCallback;
    super(itemToFilter);
    _innerIterator = innerIterator();
  }

  // Returns the value returned by the callback after passing the current value in the iteration
  Json currentValue() {
    // TODO
    /* aCallback = _callback;

    return aCallback(super.currentValue(), this.key(), _innerIterator); * /
    return Json(null);
  }

  Iterator unwrap() {
    // TODO
    /* anIterator = _innerIterator;

    if (cast(ICollection) anIterator) {
       anIterator = anIterator.unwrap();
    }
    if (anIterator.classname != ArrayIterator.classname) {
      return this;
    }
    
    // ArrayIterator can be traversed strictly.
    // Let`s do that for performance gains

    aCallback = _callback;
    auto res = null;
    anIterator.byKeyValue
      .each!(kv => res[kv.key] = aCallback(kv.value, kv.key,  anIterator));
    
    return new DArrayIterator(res); * /
    return null;
  } */
}
