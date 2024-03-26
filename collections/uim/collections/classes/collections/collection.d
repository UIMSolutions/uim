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
  protected IData[] _items;

  this() {}

  this(IData[] newItems) {
    _items = newItems;
  }

	bool initialize(IData[string] initData = null) {
		return true;
	}
  // mixin CollectionTemplate();

  /* this(Range someItems) {
    if (someItems.isArray) {
      someItems = new DArrayIterator(someItems);
    }
    super(someItems);
  } */ 


  // Returns an array for serializing this of this object.
  /* 
  array __serialize() {
    return this.buffered().toArray();
  }

  //  Rebuilds the Collection instance.
  void __unserialize(array data) {
    __construct(someData);
  }

  // Returns an array that can be used to describe the internal state of this object.
  protected IData[string] debugInfo() {
    size_t myCount;
    try {
      myCount = this.count();
    } catch (Exception exception) {
      myCount = "An exception occurred while getting count";
    }
    return [
      "count": Json(myCount),
    ];
  } */ 
}
