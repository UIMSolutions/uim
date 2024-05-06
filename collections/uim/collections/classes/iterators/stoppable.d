module uim.collections.classes.iterators.stoppable;

import uim.collections;

@safe:

/**
 * Creates an iterator from another iterator that will verify a condition on each
 * step. If the condition evaluates to false, the iterator will not yield more
 * results.
 *
 * @internal
 * @see \UIM\Collection\Collection.stopWhen()
 */
class DStoppableIterator : DCollection {
  /**
     * The condition to evaluate for each item of the collection
     *
          * /
  protected callable _condition;

  // A reference to the internal iterator this object is wrapping.
  protected ITraversable _innerIterator;

  /**
     * Creates an iterator that can be stopped based on a condition provided by a callback.
     *
     * Each time the condition callback is executed it will receive the value of the element
     * in the current iteration, the key of the element and the passed  someItems iterator
     * as arguments, in that order.
     * Params:
     * range someItems The list of values to iterate
     * @param callable condition A auto that will be called for each item in
     * the collection, if the result evaluates to false, no more items will be
     * yielded from this iterator.
     * /
  this(Json[string] someItems, callablecondition) {
    _condition = condition;
    super(someItems);
    _innerIterator = this.getInnerIterator();
  }

  /**
     * Evaluates the condition and returns its result, this controls
     * whether more results will be yielded.
     * /
  bool valid() {
    if (!super.valid()) {
      return false;
    }
    current = this.current();
    aKey = this.key();
    condition = _condition;

    return !condition(current, aKey, _innerIterator);
  }

  Iterator unwrap() {
     anIterator = _innerIterator;

    if (cast(ICollection) anIterator) {
       anIterator = anIterator.unwrap();
    }
    if (anIterator.class != ArrayIterator.class) {
      return this;
    }
    
    // ArrayIterator can be traversed strictly.
    // Let`s do that for performance gains

    aCallback = _condition;
    res = null;

    foreach (myKey, v; anIterator) {
      if (aCallback(v, myKey,  anIterator)) {
        break;
      }
      res[myKey] = v;
    }
    return new DArrayIterator(res);
  } */
}
