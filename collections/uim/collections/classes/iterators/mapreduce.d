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
    /* 
    // Holds the shuffled results that were emitted from the map phase
    protected array _intermediate = [];

    // Holds the results as emitted during the reduce phase
    protected array _auto result;

    // Whether the Map-Reduce routine has been executed already on the data
    protected bool _executed = false;

    // Holds the original data that needs to be processed
    protected range _data;

    // A callable that will be executed for each record in the original data
    protected callable _mapper;

    /**
     * A callable that will be executed for each intermediate record emitted during
     * the Map phase
     * /
    protected callable _reducer;

    // Count of elements emitted during the Reduce phase
    protected size_t _counter = 0;

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
     * @param callable mapper the mapper callback. This auto will receive 3 arguments.
     * The first one is the current value, second the current results key and third is
     * this class instance so you can call the result emitters.
     * @param callable|null reducer the reducer callback. This auto will receive 3 arguments.
     * The first one is the list of values inside a bucket, second one is the name
     * of the bucket that was created during the mapping phase and third one is an
     * instance of this class.
     * /
    this(Range someData, callable mapper, ?callable reducer = null) {
       _data = someData;
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
     * Params:
     * IData val The record itself to store in the bucket
     * @param IData aBucketName the name of the bucket where to put the record
     *  /
    void emitIntermediate(IData val, IData aBucketName)) {
       _intermediate[aBucketName] ~= val;
    }
    
    /**
     * Appends a new record to the final list of results and optionally assign a key
     * for this record.
     * Params:
     * IData val The value to be appended to the final list of results
     * @param string aKey and optional key to assign to the value
     * /
    void emit(IData val, string aKey = null) {
       _result[aKey ?? _counter] = val;
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
            throw new LogicException("No reducer auto was provided");
        }
        auto myReducer = _reducer;
        if (!myReducer.isNull) {
            _intermediate.byKeyValue.each!(kv => myReducer(kv.value, kv.key, this));
        }
       _intermediate = null;
       _executed = true;
    } */
}
