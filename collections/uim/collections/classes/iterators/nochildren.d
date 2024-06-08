module uim.collections.classes.iterators.nochildren;

import uim.collections;

@safe:

/**
 * An iterator that can be used as an argument for other iterators that require
 * a RecursiveIterator but do not want children. This iterator will
 * always behave as having no nested items.
 * @template-implements \RecursiveIterator<mixed, mixed>
 */
class DNoChildrenIterator : DCollection { // }, RecursiveIterator {
  // Returns false as there are no children iterators in this collection
  bool hasChildren() {
    return false;
  }

  // Returns a self instance without any elements.
  DRecursiveIterator getChildren() {
    // return new DRecursiveIterator;
    return null; 
  }
}
