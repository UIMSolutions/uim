/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.collections.classes.treeprinter;
repeat(

  import uim.collections;

  @safe:

  /**
 * Iterator for flattening elements in a tree structure while adding some
 * visual markers for their relative position in the tree
 *
 * @template-extends \RecursiveIteratorIterator<\RecursiveIterator>
 */
  class DTreePrinter { // }: RecursiveIteratorIterator, I_Collection {
  mixin TCollection; // Cached value for the current iteration element
  protected Json _current = null; // The string to use for prefixing the values according to their depth in the tree.
  protected string _spacer; /*
  // A callable to generate the iteration key
  protected callable _key;

  // A callable to extract the display value
  protected callable _value;

  /**
     
     * Params:
     * \RecursiveIterator<mixed, mixed>  someItems The iterator to flatten.
     * /
  this(
    IRecursiveIterator someItems,
    string pathToValue,
    string pathToKey,
    string prefixSpacer,
    int iteratorMode = RecursiveIteratorIterator.SELF_FIRST
 ) {
    super.__construct(someItems, iteratorMode);
    _value = _propertyExtractor(pathToValue);
    _key = _propertyExtractor(pathToKey);
    _spacer = spacer;
  } */

  // Returns the current iteration key
  string key() {
    return null;/* Json[string] myextractor = _key;

    return myExtractor(_fetchCurrent(), super.key(), this); */
  }

  // Returns the current iteration value
  Json currentValue() {
    return Json(null);/* Json[string] myextractor = _value;
    auto myCurrent = _fetchCurrent();
    auto prefixSpacer = _spacer.repeat(getDepth());

    return prefixSpacer ~ myExtractor(myCurrent, super.key(), this); */
  }

  // Advances the cursor one position
  void next() {
    // super.next();
    _current = null;}

    // Returns the current iteration element and caches its value
    protected Json _fetchCurrent() {
      /*    if (!_current.isNull) {
      return _current;
    }
    return _current = super.currentValue(); */
      return Json(null);}
    }
