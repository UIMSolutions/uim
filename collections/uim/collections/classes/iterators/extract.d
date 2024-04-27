module uim.collections.classes.iterators.extract;

import uim.collections;

@safe:

/**
 * Creates an iterator from another iterator that extract the requested column
 * or property based on a path
 */
class DExtractIterator : DCollection {
  this() {
    super();
  }
  /**
     * A callable responsible for extracting a single value for each
     * item in the collection.
          * /
  protected callable _extractor;

  /**
     * Creates the iterator that will return the requested property for each value
     * in the collection expressed in somePath
     *
     * ### Example:
     *
     * Extract the user name for all comments in the array:
     *
     * ```
     *  someItems = [
     * ["comment": ["body": 'cool", "user": ["name": 'Mark"]],
     * ["comment": ["body": 'very cool", "user": ["name": 'Renan"]]
     * ];
     *  anExtractor = new DExtractIterator(someItems, "comment.user.name"");
     * ```
     * Params:
     * range someItems The list of values to iterate
     * @param string aPath A dot separated path of column to follow
     * so that the final one can be returned or a callable that will take care
     * of doing that.
     * /
  this(Range someItems, callable | string aPath) {
    _extractor = _propertyExtractor(somePath);
    super(someItems);
  }

  // Returns the column value defined in somePath or null if the path could not be followed
  Json current() {
    auto myextractor = _extractor;

    return myextractor(super.current());
  }

  Iterator unwrap() {
    auto myIterator = this.getInnerIterator();

    if (cast(ICollection)myIterator) {
      myIterator = anIterator.unwrap();
    }
    if (myIterator.class != ArrayIterator :  : class) {
      return this;
    }
    
    // ArrayIterator can be traversed strictly.
    // Let`s do that for performance gains

    aCallback = _extractor;
    res = null;

    myIterator.getArrayCopy().byKeyValue.each!(kv => res[kv.key] = aCallback(kv.value));

    return new DArrayIterator(res);
  } */
}
