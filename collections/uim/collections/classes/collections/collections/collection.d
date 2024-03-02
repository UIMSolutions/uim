module uim.collections;

import uim.collections;

@safe:

/**
 * A collection is an immutable list of elements with a handful of functions to
 * iterate, group, transform and extract information from it.
 *
 * @template-extends \IteratorIterator<mixed, mixed, \Traversable<mixed>>
 */
class Collection : IteratorIterator, ICollection {
  mixin CollectionTemplate();

  this(iterable someItems) {
    if (isArray(someItems)) {
      someItems = new ArrayIterator(someItems);
    }
    super(someItems);
  }

	override bool initialize(IConfigData[string] configData = null) {
		if (!super.initialize(configData)) { return false; }
		
		return true;
	}

  // Returns an array for serializing this of this object.
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
  }
}
