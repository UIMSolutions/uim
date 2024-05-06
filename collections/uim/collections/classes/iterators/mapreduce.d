module uim.collections.classes.iterators.mapreduce;

import uim.collections;

@safe:

/**
 * : a simplistic version of the popular Map-Reduce algorithm. Acts
 * like an iterator for the original passed data after each result has been
 * processed, thus offering a transparent wrapper for results coming from any
 * source.
 *
 * @template-implements \IteratorAggregate<mixed>
 */
class DMapReduce { // }: IteratorAggregate {
    // Whether the Map-Reduce routine has been executed already on the data
    protected bool _executed = false;

    // Holds the original data that needs to be processed
    protected Json[string] _data;

    // Count of elements emitted during the Reduce phase
    protected size_t _counter = 0;
    // Holds the shuffled results that were emitted from the map phase
    protected Json[string] _intermediate = null;

    // Holds the results as emitted during the reduce phase
    protected Json[string] _autoResults;

    /* 
    // A callable that will be executed for each record in the original data
    protected callable _mapper;

    /**
     * A callable that will be executed for each intermediate record emitted during
     * the Map phase
     * /
    protected callable _reducer;

    /**
     * Constructor
     *
     * ### Example:
     *
     * Separate all unique odd and even numbers in an array
     *
     * ```
     * someData = new \ArrayObject([1, 2, 3, 4, 5, 3]);
     * mapper = auto (aValue, aKey, mr) {
     *     type = (aValue % 2 == 0) ? "even' : 'odd";
     *     mr.emitIntermediate(aValue, type);
     * };
     *
     * reducer = auto (numbers, type, mr) {
     *     mr.emit(array_unique(numbers), type);
     * };
     * results = new DMapReduce(someData, mapper, reducer);
     * ```
     *
     * Previous example will generate the following result:
     *
     * ```
     * ["odd": [1, 3, 5], "even": [2, 4]]
     * ```
     * Params:
     * range someData The original data to be processed.
     * /
    this(Json[string] dataToProcess, callable mapper, ?callable reducer = null) {
       _data = dataToProcess;
       _mapper = mapper;
       _reducer = reducer;
    }
    
    /**
     * Returns an iterator with the end result of running the Map and Reduce
     * phases on the original data
     * /
    Traversable getIterator() {
        if (!_executed) {
           _execute();
        }
        return new DArrayIterator(_result);
    }
    
    /**
     * Appends a new record to the bucket labelled with aKey, usually as a result
     * of mapping a single record from the original data.
     *  /
    void emitIntermediate(Json storeData, Json aBucketName)) {
       _intermediate[aBucketName] ~= storeData;
    }
    
    /**
     * Appends a new record to the final list of results and optionally assign a key
     * for this record.
     * /
    void emit(Json val, string valueKey = null) {
       _result[valueKey ? valueKey : _counter] = val;
       _counter++;
    }
    
    /**
     * Runs the actual Map-Reduce algorithm. This is iterate the original data
     * and call the mapper auto for each , then for each intermediate
     * bucket created during the Map phase call the reduce function.
     *
     * @throws \LogicException if emitIntermediate was called but no reducer function
     * was provided
     * /
    protected void _execute() {
        auto myMapper = _mapper;
        _data.byKeyValue.each!(kv => myMapper(kv.value, kv.key, this));

        if (!_intermediate.isEmpty && _reducer.isEmpty) {
            throw new DLogicException("No reducer auto was provided");
        }
        auto myReducer = _reducer;
        if (!myReducer.isNull) {
            _intermediate.byKeyValue.each!(kv => myReducer(kv.value, kv.key, this));
        }
       _intermediate = null;
       _executed = true;
    } */
}
