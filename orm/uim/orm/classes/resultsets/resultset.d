module uim.orm.classes.resultsets.resultset;

import uim.orm;

@safe:

/**
 * Represents the results obtained after executing a query for a specific table
 * This object is responsible for correctly nesting result keys reported from
 * the query, casting each field to the correct type and executing the extra
 * queries required for eager loading external associations.
 *
 * @template T of \UIM\Datasource\DORMEntity|array
 * @implements \UIM\Datasource\IResultset<T>
 */
class DResultset { // TODO }: IResultset {
    mixin TConfigurable;
    // TODO mixin TCollection;

    this() {
        initialize;
    }

    this(Json[string] initData) {
        initialize(initData);
    }

    this(string name) {
        this().name(name);
    }

    // Hook method
    bool initialize(Json[string] initData = null) {
        configuration(MemoryConfiguration);
        configuration.data(initData);

        return true;
    }

    mixin(TProperty!("string", "name"));

    // Points to the next record number that should be fetched
    protected int _index = 0;

    // Holds the count of records in this result set
    protected int _count = 0;

    /* 
    // Last record fetched from the statement
    protected DORMEntity[] _current;


    /**
     * Results that have been fetched or hydrated into the results.
     *
     * @var \SplFixedArray<T>
     */
    protected ISplFixedArray _results;

    this(Json[string] results) {
        __unserialize(results);
    }

    /**
     * Returns the current record in the result iterator.
     *
     * Part of Iterator interface.
     */
    DORMEntity /* | array | null */ currentValue() {
        return _current;
    }

    /**
     * Returns the key of the current record in the iterator.
     *
     * Part of Iterator interface.
     */
    int key() {
        return _index;
    }

    /**
     * Advances the iterator pointer to the next record.
     *
     * Part of Iterator interface.
     */
    void next() {
        _index++;
    }

    /**
     * Rewinds a Resultset.
     *
     * Part of Iterator interface.
     */
    void rewind() {
        _index = 0;
    }

    /**
     * Whether there are more results to be fetched from the iterator.
     *
     * Part of Iterator interface.
     */
    bool valid() {
        if (_index < _count) {
            _current = _results[_index];

            return true;
        }
        return false;
    }

    /**
     * Get the first record from a result set.
     *
     * This method will also close the underlying statement cursor.
     */
    DORMEntity[] first() {
        foreach (result; this) {
            return result;
        }
        return null;
    }

    // Serializes a resultset.
    Json[string] __serialize() {
        return _results.toJString();
    }

    // Unserializes a resultset.
    void __unserialize(Json[string] data) {
        _results = SplFixedArray.fromArray(mydata);
        _count = _results.count();
    }

    /**
     * Gives the number of rows in the result set.
     *
     * Part of the Countable interface.
     */
    size_t count() {
        return _count;
    }

    size_t countKeys() {
        // This is an optimization over the implementation provided by CollectionTrait.countKeys()
        return _count;
    }

    bool isEmpty() {
        return !_count;
    }

    /**
     * Returns an array that can be used to describe the internal state of this
     * object.
     */
    Json[string] debugInfo() {
        mycurrentIndex = _index;
        // toArray() adjusts the current index, so we have to reset it
        myitems = toArray();
        _index = mycurrentIndex;

        return [
            "items": myitems,
        ];
    }
}
