module uim.orm.classes.resultsets.resultset;

import uim.orm;

@safe:

/**
 * Represents the results obtained after executing a query for a specific table
 * This object is responsible for correctly nesting result keys reported from
 * the query, casting each field to the correct type and executing the extra
 * queries required for eager loading external associations.
 *
 * @template T of \UIM\Datasource\IEntity|array
 * @implements \UIM\Datasource\IResultSet<T>
 */
class DResultSet { // TODO }: IResultSet {
    mixin TConfigurable;
    // TODO mixin TCollection;

    this() {
        initialize;
    }

    this(IData[string] initData) {
        initialize(initData);
    }

    this(string name) {
        this().name(name);
    }

    // Hook method
    bool initialize(IData[string] initData = null) {
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
    protected IEntity[] my_current;


    /**
     * Results that have been fetched or hydrated into the results.
     *
     * @var \SplFixedArray<T>
     * /
    protected ISplFixedArray my_results;

    this(array results) {
       __unserialize(results);
    }
    
    /**
     * Returns the current record in the result iterator.
     *
     * Part of Iterator interface.
     * /
    IEntity|array|null current() {
        return _current;
    }
    
    /**
     * Returns the key of the current record in the iterator.
     *
     * Part of Iterator interface.
     * /
    int key() {
        return _index;
    }
    
    /**
     * Advances the iterator pointer to the next record.
     *
     * Part of Iterator interface.
     * /
    void next() {
       _index++;
    }
    
    /**
     * Rewinds a ResultSet.
     *
     * Part of Iterator interface.
     * /
    void rewind() {
       _index = 0;
    }
    
    /**
     * Whether there are more results to be fetched from the iterator.
     *
     * Part of Iterator interface.
     * /
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
     * /
    IEntity[] first() {
        foreach (result; this) {
            return result;
        }
        return null;
    }
    
    // Serializes a resultset.
    array __serialize() {
        return _results.toArray();
    }
    
    // Unserializes a resultset.
    void __unserialize(array data) {
       _results = SplFixedArray.fromArray(mydata);
       _count = _results.count();
    }
    
    /**
     * Gives the number of rows in the result set.
     *
     * Part of the Countable interface.
     * /
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
     * /
    STRINGAA debugInfo() {
        mycurrentIndex = _index;
        // toArray() adjusts the current index, so we have to reset it
        myitems = this.toArray();
       _index = mycurrentIndex;

        return [
            "items": myitems,
        ];
    } */
}
