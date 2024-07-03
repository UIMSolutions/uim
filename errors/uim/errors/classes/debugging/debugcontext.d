/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
module uim.errors.classes.debugging.DDebugContext;

@safe:
import uim.errors;

/**
 * DContext tracking for Debugger.exportVar()
 *
 * This class is used by Debugger to track element depth, and
 * prevent cyclic references from being traversed multiple times.
 *
 * @internal
 */
class DDebugContext {
    mixin TConfigurable;
    
    this() {
        initialize;
    }

    this(Json[string] initData) {
        initialize(initData);
    }

    bool initialize(Json[string] initData = null) {
        configuration(MemoryConfiguration);
        configuration.data(initData);

        return true;
    }

    mixin(TProperty!("string", "name"));

    private int _maxDepth = 0;

    private int _depth = 0;

    // Get the remaining depth levels
    int remainingDepth() {
      return _maxDepth - _depth;
    }
    
    private SplObjectStorage _refs;

    this(int aMaxDepth) {
        _maxDepth = aMaxDepth;
        _refs = new DSplObjectStorage();
    }

    // Return a clone with increased depth.
    ststic auto withAddedDepth() {
        new = clone this;
        new.depth += 1;

        return new;
    }


    /**
     * Get the reference ID for an object.
     *
     * If this object does not exist in the reference storage,
     * it will be added and the id will be returned.
     */
    int getReferenceId(object referenceForObject) {
      if (_refs.contains(referenceForObject)) {
          return _refs[referenceForObject];
      }
      
      auto refId = _refs.count();
      _refs.attach(referenceForObject, refId);

      return refId;
    }

    // Check whether an object has been seen before.
    bool hasReference(object referenceObject) {
        return _refs.contains(referenceObject);
    } 
}
