/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.errors.classes.debugging.debugcontext;

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
class DebugContext {
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
    
    /* 
    private SplObjectStorage _refs;

    /**
     * Constructor
     *
     * @param int maxDepth The desired depth of dump output.
     */
    this(int aMaxDepth) {
        _maxDepth = aMaxDepth;
        _refs = new DSplObjectStorage();
    }

    /**
     * Return a clone with increased depth.
     *
     * @return static
     */
    function withAddedDepth() {
        new = clone this;
        new.depth += 1;

        return new;
    }


    /**
     * Get the reference ID for an object.
     *
     * If this object does not exist in the reference storage,
     * it will be added and the id will be returned.
     *
     * @param object object The object to get a reference for.
     * @return int
     */
    int getReferenceId(object object) {
      if (this.refs.contains(object)) {
          return _refs[object];
      }
      refId = this.refs.count();
      this.refs.attach(object, refId);

      return refId;
    }

    /**
     * Check whether an object has been seen before.
     *
     * @param object object The object to get a reference for.
     */
    bool hasReference(object object) {
        return _refs.contains(object);
    } */
}
