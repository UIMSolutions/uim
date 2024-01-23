/*********************************************************************************************************
  Copyright: © 2015 - 2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.oop.containers.lists.list;

import uim.oop;

// An ordered collection (also known as a sequence). 
// The user of this interface has precise control over where in the list each element is inserted. 
// The user can access elements by their integer index (position in the list), and search for elements in the list.
@safe:
class DList(T) : DContainer!T, IList  {
  protected T[] _items;

  this() {
    super();
    initialize;
  }
  this(T[] newItems) {
    this().addAll(newItems.dup);
  }

  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);
  }

  // #region add
    // Appends the specified element to the end of this list (optional operation).
    override bool add(T addItem) {
      _items ~= addItem;
      return true;
    }

    // Inserts the specified element at the specified position in this list (optional operation).
    bool add(size_t index, T addItem) {
      if (index < _items.length) {
        _items = _items[0..index] ~addItem~_items[index..$];
      } else {
        this.add(addItem);
      }
      return true;
    }
  // #endregion add

  // Appends all of the elements in the specified collection to the end of this list, in the order that they are returned by the specified collection's iterator (optional operation).
  override bool addAll(DContainer!T addItems) {
    return addAll(addItems.toArray);
  }

  override bool addAll(T[] addItems...) {
    return addAll(addItems.dup);
  }

  override bool addAll(T[] addItems) {
    addItems.each!(item => add(item));

    return true;
  }
  
  // Returns true if this list contains the specified element.
  override bool contains(T checkItem) {
    if (checkItem.isNull) { 
      return false; 
    }

    return _items.count!(item => checkItem == item) > 0;
  }

  // Returns true if this list contains all of the elements of the specified collection.
  override bool containsAll(DContainer!T checkItems) {
    return containsAll(checkItems.toArray);
  }

  override bool containsAll(T[] checkItems...) {
    return containsAll(checkItems.dup);
  }

  override bool containsAll(T[] checkItems) {
    if (checkItems.isEmpty) {
      return false;
    } 

    return checkItems
      .count!(item => contains(item)) == checkItems.length;
  }

  // Returns the element at the specified position in this list.
  T	get(size_t index) {
    if (index < _items.length) { return _items[index]; }
    return null; 
  }

  // Returns the index of the first occurrence of the specified element in this list, or -1 if this list does not contain the element.
  size_t	indexOf(T checkItem) {
    foreach(index, myItem; _items) {
      if (myItem == checkItem) { return index; }
    }
    return -1;
  }

  override size_t size() {
    return _items.length;
  }

  // Removes the element at the specified position in this list (optional operation).
  T	remove(size_t index) {
    if (index < _items.length-1) {
      auto myItem = _items[index];
      _items = _items[0..index]~_items[index+1..$];
      return myItem; 
    }
    if (index < _items.length) {
      auto myItem = _items[index];
      _items = _items[0..index]; 
      return myItem; 
    }
    return null; 
  }

  // Removes the first occurrence of the specified element from this list, if it is present (optional operation).
  override bool remove(T removeItem) {
    foreach(index, myItem; _items) {
      if (myItem == removeItem) { return !remove(index).isNull; }
    }
    return false;
  }

  // Removes from this list all of its elements that are contained in the specified collection (optional operation).
  override bool removeAll(DContainer!T removeItems) {
    return removeAll(removeItems.toArray);
  }

  override bool removeAll(T[] removeItems...) {
    return removeAll(removeItems.dup);
  }

  override bool removeAll(T[] removeItems) {
    foreach(myItem; removeItems) {
      if (!remove(myItem)) { 
        return false; 
      }
    }
    return true;
  }

  // Removes all of the elements from this list.
  override bool clear() {
    _items = null;
    return true;
  }

  override bool isEmpty() {
    return (_items.length == 0);
  }

  override T[] toArray() {
    return _items.dup;
  }
}
auto List(T)() { return new DList!T(); }

// ---------- Test
class DTest { 
  this() {}
  this(string aName) { this().name(aName); }

  alias opEquals = Object.opEquals;
  bool opEquals(DTest aValue) {
    return aValue.isNull ? false : (name == aValue.name);
  }

  string registerPath() { return name; }
  mixin(OProperty!("string", "name"));
}

bool isNull(DTest aValue) {
  return aValue is null;
}

unittest {
  auto list = List!DTest;
  list.add(new DTest("1"));
  list.add(new DTest("2"));
  list.add(new DTest("3"));
  assert(list.toArray.map!(item => item.name).array == ["1", "2", "3"]);

  list.add(2, new DTest("4"));
  assert(list.toArray.map!(item => item.name).array == ["1", "2", "4", "3"]);

  list = List!DTest;
  list.addAll(new DTest("1"), new DTest("2"), new DTest("3"));
  assert(list.toArray.map!(item => item.name).array == ["1", "2", "3"]);

  list = List!DTest;
  list.addAll([new DTest("1"), new DTest("2"), new DTest("3")]);
  assert(list.toArray.map!(item => item.name).array == ["1", "2", "3"]);

  assert(cast(DList!DTest)list);
  assert(cast(IList)list);
  assert((cast(IList)list).size == 3);

  list.clear;
  assert(list.size == 0);
  assert(list.isEmpty); 
 
  list = List!DTest;
  list.addAll([new DTest("1"), new DTest("2"), new DTest("3")]);
  auto iList = cast(IList)list;
  iList.clear;
  assert(iList.size == 0); 
  assert(iList.isEmpty); 

  auto test0 = new DTest("0");
  auto test1 = new DTest("1");
  auto test2 = new DTest("2");
  auto testX = new DTest("x");
  list = List!DTest;
  list.addAll(test0, test1, test2);
  assert(list.size == 3);

  assert(list.contains(test1)); 
  assert(list.containsAll(test1, test0)); 

  assert(!list.contains(testX)); 
  assert(!list.containsAll(test1, testX, test2)); 

  assert(list.get(0) == test0);
  assert(list.indexOf(test1) == 1);
  assert(list.get(1) != test0);
  assert(list.indexOf(test1) != 2);

  with (list) {
    remove(0);
    assert(size == 2);
    remove(test2);
    assert(size == 1);

    clear;
    addAll(test0, test1, test2);
    removeAll(test0, test1);
    assert(size == 1);
  }
} 