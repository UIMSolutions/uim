module uim.collections.classes.iterators.nest;

import uim.collections;

@safe:

/**
 * A type of collection that is aware of nested items and exposes methods to
 * check or retrieve them
 *
 * @template-implements \RecursiveIterator<mixed, mixed>
 */
class DNestIterator : DCollection {// }, RecursiveIterator {
    // The name of the property that contains the nested items for each element
    protected string _nestedKey;

    /* 
    this(Json[string] itemToFilter, string nestedKey) {
        super(itemToFilter);
       _nestedKey = nestedKey;
    }
    
    // Returns a traversable containing the children for the current item
    RecursiveIterator getChildren() {
        auto aProperty = _propertyExtractor(_nestedKey);

        return new static(aProperty(this.current()), _nestedKey);
    }
    
    /**
     * Returns true if there is an array or a traversable object stored under the
     * configured nestKey for the current item
     */
    bool hasChildren() {
        auto myProperty = _propertyExtractor(_nestedKey);
        auto myChildren = myProperty(this.current());

        if (myChildren.isArray) {
            return !myChildren.isEmpty;
        }
        return cast(Traversable)myChildren;
    } */
}
