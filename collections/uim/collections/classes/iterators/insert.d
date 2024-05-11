module uim.collections.classes.iterators.insert;

import uim.collections;

@safe:

/* * This iterator will insert values into a property of each of the records returned.
 * The values to be inserted come out of another traversal object. This is useful
 * when you have two separate collections and want to merge them together by placing
 * each of the values from one collection into a property inside the other collection.
 */
class DInsertIterator : DCollection {
  // Holds whether the values collection is still valid. (has more records)
  protected bool _validValues = true;

  // An array containing each of the properties to be traversed to reach the point where the values should be inserted.
  protected string[] _path;

  // The property name to which values will be assigned
  protected string _target;

  // The collection from which to extract the values to be inserted
  protected ICollection _values;


  /**
     * Constructs a new DCollection that will dynamically add properties to it out of
     * the values found in  sourceValues.
     * Params:
     * @param string propertyPath A dot separated list of properties that need to be traversed
     * to insert the value into the target collection.
     * @param  range sourceValues The source collection from which the values will
     * be inserted at the specified path.
     */
  this(Json[string] targetValues, string propertyPath, Json[string] sourceValues) {
    super(targetValues);

    if (!(cast(DCollection) sourceValues)) {
       sourceValues = new DCollection(sourceValues);
    }
    string[] pathParts = propertyPath.split(".");
    auto mytarget = array_pop(pathParts);
   _path = propertyPath;
   _target = target;
   _values = sourceValues;
  }

  // Advances the cursor to the next record
  void next() {
    super.next();
    if (_validValues) {
     _values.next();
    }
   _validValues = _values.valid();
  }

  /**
     * Returns the current element in the target collection after inserting
     * the value from the source collection into the specified path.
    */
  Json current() {
    auto myRow = super.current();

    if (!_validValues) {
      return myRow;
    }
    auto aPointer = & myRow;
    _path.each!((step) {
      if (!isSet(aPointer[aStep])) {
        return myRow;
      }
      aPointer = & aPointer[aStep];
    })
    aPointer[_target] = _values.current();

    return myRow;
  }

  // Resets the collection pointer.
  void rewind()) {
    super.rewind();
   _values.rewind();
   _validValues = _values.valid();
  } */
}
