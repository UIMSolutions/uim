module uim.collections.iterators.nest;

import uim.cake;

@safe:

/**
 * A type of collection that is aware of nested items and exposes methods to
 * check or retrieve them
 *
 * @template-implements \RecursiveIterator<mixed, mixed>
 */
class NestIterator : Collection, RecursiveIterator {
    // The name of the property that contains the nested items for each element
    protected string _nestKey;

    /**
     * Constructor
     * Params:
     * iterable someItems Collection items.
     * @param string anestKey the property that contains the nested items
     * If a callable is passed, it should return the childrens for the passed item
     */
    this(iterable someItems, callable | string mynestKey) {
        super(someItems);
       _nestKey = nestKey;
    }
    
    /**
     * Returns a traversable containing the children for the current item
     */
    RecursiveIterator getChildren() {
         aProperty = _propertyExtractor(_nestKey);

        return new static(aProperty(this.current()), _nestKey);
    }
    
    /**
     * Returns true if there is an array or a traversable object stored under the
     * configured nestKey for the current item
     */
    bool hasChildren() {
        auto myProperty = _propertyExtractor(_nestKey);
        auto myChildren = myProperty(this.current());

        if (isArray(myChildren)) {
            return !myChildren.isEmpty;
        }
        return cast(Traversable)myChildren;
    }
}
