/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.oop.containers.container;

import uim.oop;
@safe:

version (test_uim_oop) {
  import std.stdio;
  unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
  }
}

abstract class DContainer(T : UIMObject) {
  this() {
    initialize;
  }

  bool initialize(Json[string] initData = null) {
    return true;
  }

  protected T[] _items;

  // Returns the number of elements in this container.*/
  size_t length() {
    return _items.length;
  } 
  
  T[] items() {
    return _items.dup;
  } 
  // #region add
  // Adds all of array addItems to this container.
  void add(T[] newItems) {
    newItems.each!(item => add(item));
  }

  // Ensures that this container contains the specified element.
  void add(T newItem) {
    _items ~= newItem.dup;
  }

  // Adds all of the elements in the specified container to this container.
  void add(DContainer!T itemContainer) {
    if (itemContainer is null) {
      return;
    }
    add(itemContainer.items);
  }
  // #endregion add
  
  // Returns true if this container contains the specified element.
  bool contains(T checkItem) {
    return _items.any!(item => item == checkItem);
  }
  
  // Returns true if this container contains all of the elements in the specified container.
  bool containsAll(DContainer!T checkItems) {
    return checkItems.all!(item => contains(item));
  }

  bool containsAll(T[] checkItems...) {
    return containsAll(checkItems.dup);
  }

  bool containsAll(T[] checkItems) {
    return checkItems.all!(item => contains(item));
  }
  
    // Returns true if this container contains all of the elements in the specified container.
  bool containsAny(DContainer!T checkItems) {
    return checkItems.any!(item => contains(item));
  }

  bool containsAny(T[] checkItems...) {
    return containsAny(checkItems.dup);
  }

  bool containsAny(T[] checkItems) {
    return checkItems.any!(item => contains(item));
  }

  // Returns true if this container contains no elements.*/
  bool isEmpty() {
    return _items.length = 0;
  } 

  bool removeKey(T[] remove) {
    remove.each!(item => removeKey(item));
  }

  // Removes a single instance of the specified element from this container, if it is present.
  bool removeKey(T removeItem) {
    _items.removeKey(removeItem);
  }

  // Removes all of the elements from this container */
  bool clear() {
    _items = null;
  }
}