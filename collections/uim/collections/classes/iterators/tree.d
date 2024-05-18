module uim.collections.classes.iterators.tree;

import uim.collections;

@safe:

/**
 * A Recursive iterator used to flatten nested structures and also exposes
 * all Collection methods
 *
 * @template-extends \RecursiveIteratorIterator<\RecursiveIterator>
 */
class DTreeIterator { // TODO }: RecursiveIteratorIterator, ICollection {
    mixin TCollection;

    // The iteration mode
    protected int _mode;

    /**
     
     * Params:
     * \RecursiveIterator<mixed, mixed>  someItems The iterator to flatten.
     */
    this(
        RecursiveIterator  someItems,
        int iteratorMode = RecursiveIteratorIterator.SELF_FIRST,
        int iteratorFlags = 0
    ) {
        super(someItems, iteratorMode, iteratorFlags);
       _mode = iteratorMode;
    }
    
    /**
     * Returns another iterator which will return the values ready to be displayed
     * to a user. It does so by extracting one property from each of the elements
     * and prefixing it with a spacer so that the relative position in the tree
     * can be visualized.
     *
     * Both valuePath and keyPath can be a string with a property name to extract
     * or a dot separated path of properties that should be followed to get the last
     * one in the path.
     *
     * Alternatively, valuePath and keyPath can be callable functions. They will get
     * the current element as first parameter, the current iteration key as second
     * parameter, and the iterator instance as third argument.
     *
     * ### Example
     *
     * ```
     * printer = (new DCollection(treeStructure)).listNested().printer("name");
     * ```
     *
     * Using a closure:
     *
     * ```
     * printer = (new DCollection(treeStructure))
     *     .listNested()
     *     .printer(function (anItem, aKey, myIterator) {
     *         return anItem.name;
     *     });
     * ```
    DTreePrinter printer(
        string propertyPath,
        string keyPath = null,
        string aspacer = "__"
    ) {
        if (! keyPath) {
            counter = 0;
            keyPath = auto () use (&counter) {
                return counter++;
            };
        }
        /** @var \RecursiveIterator  anIterator */
        auto myIterator = innerIterator();

        return new DTreePrinter(
            myIterator,
            valuePath,
            keyPath,
            spacer,
           _mode
        );
    } */
}
