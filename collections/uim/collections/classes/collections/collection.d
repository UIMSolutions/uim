/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.collections.classes.collections.collection;

import uim.collections;

@safe:

/**
 * A collection is an immutable list of elements with a handful of functions to
 * iterate, group, transform and extract information from it.
 *
 * @template-extends \IteratorIterator<mixed, mixed, \Traversable<mixed>>
 */
class DCollection : /* IteratorIterator, */ ICollection {
  mixin TCollection;

  protected Json[] _items;

  this() {}

  this(Json[] newItems) {
    _items = newItems;
  }

	bool initialize(Json[string] initData = null) {
		return true;
	}

  this(Json[string] someItems) {
    /* 
    if (someItems.isArray) {
      someItems = new DArrayIterator(someItems);
    } */
    super(someItems);
  }


  // Returns an array for serializing this of this object.
  Json[string] __serialize() {
    return _buffered().toJString();
  }

  //  Rebuilds the Collection instance.
  void __unserialize(Json[string] data) {
    __construct(someData);
  }

  // Returns an array that can be used to describe the internal state of this object.
  protected Json[string] debugInfo() {
    size_t countItems;
    try {
      countItems = count();
    } catch (Exception exception) {
      countItems = "An exception occurred while getting count";
    }
    return [
      "count":  Json(countItems),
    ];
  } */ 
}
