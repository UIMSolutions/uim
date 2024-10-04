/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.errors.classes.debugging.context;

@safe:
import uim.errors;

unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
}

/**
 * DContext tracking for Debugger.exportVar()
 *
 * This class is used by Debugger to track element depth, and
 * prevent cyclic references from being traversed multiple times.
 */
class DDebugContext : UIMObject {
    this() {
        super();
    }

    this(Json[string] initData) {
        super(initData);
    }

    override bool initialize(Json[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

        return true;
    }

    private int _maxDepth = 0;
    private int _depth = 0;

    // Get the remaining depth levels
    int remainingDepth() {
        return _maxDepth - _depth;
    }

    // private SplObjectStorage _refs;
    this(int aMaxDepth) {
        _maxDepth = aMaxDepth;
        _refs = new DSplObjectStorage();
    }

    // Return a clone with increased depth.
    /* static auto withAddedDepth() {
        auto newContext = this.clone;
        newContext.depth += 1;

        return newContext;
    } */

    protected UUID[UIMObject] _refObjects;

    /**
     * Get the reference ID for an object.
     *
     * If this object does not exist in the reference storage,
     * it will be added and the id will be returned.
     */
    UUID referenceId(UIMObject referenceObject) {
        if (hasReference(referenceObject)) {
            return _refObjects[referenceObject];
        }

        auto refId = randomUUID;
        _refObjects[referenceObject] = refId;

        return refId;
    }

    // Check whether an object has been seen before.
    bool hasReference(UIMObject referenceObject) {
        return _refObjects.any!(obj => obj == referenceObject);
    }
}
