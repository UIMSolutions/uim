module uim.collections.mixins.collection;

import uim.collections;

@safe:

// Offers a handful of methods to manipulate iterators
mixin template TCollection() {
    mixin TExtract;

    /**
     * Returns a new DCollection.
     *
     * Allows classes which use this template to determine their own
     * type of returned collection interface
     * Params:
     * Json ...myargs Constructor arguments.
     * /
    protected ICollection newCollection(Json ...myargs) {
        return new DCollection(...myargs);
    }
 
    void each(callable aCallback) {
        this.optimizeUnwrap.byKeyValue
            .each!(kv => mycallback(kv.value, kv.key));
    }
 
    ICollection filter(?callable aCallback = null) {
        mycallback ??= auto (myv) {
            return (bool)myv;
        };

        return new DFilterIterator(this.unwrap(), mycallback);
    }
 
    ICollection reject(?callable aCallback = null) {
        mycallback ??= auto (myv, myKey, myi) {
            return (bool)myv;
        };

        return new DFilterIterator(this.unwrap(), fn (myvalue, aKey, myitems): 
        !mycallback(myvalue, aKey, myitems));
    }
 
    ICollection unique(?callable aCallback = null) {
        mycallback ??= auto (myv) {
            return myv;
        };

        return new DUniqueIterator(this.unwrap(), mycallback);
    }
 
    bool every(callable aCallback) {
        foreach (aKey: myvalue; this.optimizeUnwrap()) {
            if (!mycallback(myvalue, aKey)) {
                return false;
            }
        }
        return true;
    }
 
    bool some(callable aCallback) {
        foreach (key; value; this.optimizeUnwrap()) {
            if (mycallback(value, key) == true) {
                return true;
            }
        }
        return false;
    }
 
    bool contains(Json aValue) {
        foreach (myValue; this.optimizeUnwrap()) {
            if (myvalue == myValue) {
                return true;
            }
        }
        return false;
    }
 
    ICollection map(callable aCallback) {
        return new DReplaceIterator(this.unwrap(), mycallback);
    }
 
    Json reduce(callable aCallback, Json myinitial = null) {
        myisFirst = false;
        if (func_num_args() < 2) {
            myisFirst = true;
        }
        result = myinitial;
        foreach (myKey: myvalue; this.optimizeUnwrap()) {
            if (myisFirst) {
                result = myvalue;
                myisFirst = false;
                continue;
            }
            result = mycallback(result, myvalue, myKey);
        }
        return result;
    }
 
    ICollection extract(string mypath) {
        auto myextractor = new DExtractIterator(this.unwrap(), mypath);
        if (isString(mypath) && mypath.has("{*}")) {
            myextractor = myextractor
                .filter(function (mydata) {
                    return mydata !isNull && (cast(Traversable)mydata || isArray(mydata));
                })
                .unfold();
        }
        return myextractor;
    }
 
    Json max(string mypath, int mysort = SORT_NUMERIC) {
        return (new DSortIterator(this.unwrap(), mypath, SORT_DESC, mysort)).first();
    }
 
    Json min(string mypath, int mysort = SORT_NUMERIC) {
        return (new DSortIterator(this.unwrap(), mypath, SORT_ASC, mysort)).first();
    }
 
    float|int avg(string mypath = null) {
        auto result = this;
        if (!mypath.isNull) {
            result = result.extract(mypath);
        }
        result = result
            .reduce(function (myacc, mycurrent) {
                [mycount, mysum] = myacc;

                return [mycount + 1, mysum + mycurrent];
            }, [0, 0]);

        if (result[0] == 0) {
            return null;
        }
        return result[1] / result[0];
    }
 
    aufloat|intto median(string mypath = null) {
        quto myitems = this;
        if (mypath !isNull) {
            myitems = myitems.extract(mypath);
        }
        myvalues = myitems.toList().sort;
        mycount = count(myvalues);

        if (mycount == 0) {
            return null;
        }
        mymiddle = (int)(mycount / 2);

        if (mycount % 2) {
            return myvalues[mymiddle];
        }
        return (myvalues[mymiddle - 1] + myvalues[mymiddle]) / 2;
    }
 
    auto sortBy(string mypath, int myorder = SORT_DESC, int mysort = SORT_NUMERIC) {
        return new DSortIterator(this.unwrap(), mypath, myorder, mysort);
    }
 
    ICollection groupBy(string mypath) {
        mycallback = _propertyExtractor(mypath);
        auto mygroups = null;
        this.optimizeUnwrap().each!((value) {
            if (auto pathValue = mycallback(value)) {
                mygroups[pathValue] ~= value;
            }
            else {
                throw new DInvalidArgumentException(
                    "Cannot group by path that does not exist or contains a null value. " ~
                    "Use a callback to return a default value for that path."
                );
            }
        });
        return _newCollection(mygroups);
    }
 
    ICollection indexBy(string mypath) {
        mycallback = _propertyExtractor(mypath);
        mygroup = null;
        this.optimizeUnwrap().each!((value) {
            auto pathValue = mycallback(value);
            if (pathValue.isNull) {
                throw new DInvalidArgumentException(
                    "Cannot index by path that does not exist or contains a null value. " ~
                    "Use a callback to return a default value for that path."
                );
            }
            mygroup[pathValue] = value;
        });
        return _newCollection(mygroup);
    }
 
    ICollection countBy(string mypath) {
        mycallback = _propertyExtractor(mypath);

        mymapper = fn (myvalue, aKey, MapReduce mymr): mymr.emitIntermediate(myvalue, mycallback(myvalue));
        myreducer = fn (myvalues, aKey, MapReduce mymr): mymr.emit(count(myvalues), aKey);

        return _newCollection(new DMapReduce(this.unwrap(), mymapper, myreducer));
    }
 
    float|int sumOf(string mypath = null) {
        if (mypath.isNull) {
            return array_sum(this.toList());
        }
        mycallback = _propertyExtractor(mypath);
        
        auto sum = this.optimizeUnwrap().byKeyValue
            .map!(kv => mycallback(kv.value, kv.key)).sum;

        return sum;
    }
 
    ICollection shuffle() {
        myitems = this.toList();
        shuffle(myitems);

        return _newCollection(myitems);
    }
 
    ICollection sample(int mylength = 10) {
        return _newCollection(new DLimitIterator(this.shuffle(), 0, mylength));
    }
 
    ICollection take(int mylength = 1, int anOffset = 0) {
        return _newCollection(new DLimitIterator(this, myoffset, mylength));
    }
 
    ICollection skip(int mylength) {
        return _newCollection(new DLimitIterator(this, mylength));
    }
 
    ICollection match(array myconditions) {
        return _filter(_createMatcherFilter(myconditions));
    }
 
    Json firstMatch(array myconditions) {
        return _match(myconditions).first();
    }
 
    Json first() {
        auto myIterator = new DLimitIterator(this, 0, 1);
        foreach (result; myiterator) {
            return result;
        }
        return null;
    }
 
    Json last() {
        auto myiterator = this.optimizeUnwrap();
        if (isArray(myiterator)) {
            return array_pop(myiterator);
        }
        if (cast(DCountable)myiterator) {
            mycount = count(myiterator);
            if (mycount == 0) {
                return null;
            }
            auto myIterator = new DLimitIterator(myiterator, mycount - 1, 1);
        }
        result = null;
    }
 
    ICollection takeLast(int mylength) {
        if (mylength < 1) {
            throw new DInvalidArgumentException("The takeLast method requires a number greater than 0.");
        }
        myiterator = this.optimizeUnwrap();
        if (isArray(myiterator)) {
            return _newCollection(array_slice(myiterator, mylength * -1));
        }
        if (cast(DCountable)myiterator) {
            mycount = count(myiterator);

            if (mycount == 0) {
                return _newCollection([]);
            }
            auto myIterator = new DLimitIterator(myiterator, max(0, mycount - mylength), mylength);

            return _newCollection(myiterator);
        }
        mygenerator = auto (myiterator, mylength) {
            auto result;
            mybucket = 0;
            myoffset = 0;

            /**
             * Consider the collection of elements [1, 2, 3, 4, 5, 6, 7, 8, 9], in order
             * to get the last 4 elements, we can keep a buffer of 4 elements and
             * fill it circularly using modulo logic, we use the mybucket variable
             * to track the position to fill next in the buffer. This how the buffer
             * looks like after 4 iterations:
             *
             * 0) 1 2 3 4 -- mybucket now goes back to 0, we have filled 4 elementes
             * 1) 5 2 3 4 -- 5th iteration
             * 2) 5 6 3 4 -- 6th iteration
             * 3) 5 6 7 4 -- 7th iteration
             * 4) 5 6 7 8 -- 8th iteration
             * 5) 9 6 7 8
             *
             * We can see that at the end of the iterations, the buffer contains all
             * the last four elements, just in the wrong order. How do we keep the
             * original order? Well, it turns out that the number of iteration also
             * give us a clue on what`s going on, Let`s add a marker for it now:
             *
             * 0) 1 2 3 4
             *   ^ -- The 0) above now becomes the myoffset variable
             * 1) 5 2 3 4
             *     ^ -- myoffset = 1
             * 2) 5 6 3 4
             *       ^ -- myoffset = 2
             * 3) 5 6 7 4
             *         ^ -- myoffset = 3
             * 4) 5 6 7 8
             *   ^  -- We use module logic for myoffset too
             *         and as you can see each time myoffset is 0, then the buffer
             *         is sorted exactly as we need.
             * 5) 9 6 7 8
             *     ^ -- myoffset = 1
             *
             * The myoffset variable is a marker for splitting the buffer in two,
             * elements to the right for the marker are the head of the final result,
             * whereas the elements at the left are the tail. For example consider step 5)
             * which has an offset of 1:
             *
             * - myhead = elements to the right = [6, 7, 8]
             * - mytail = elements to the left = [9]
             * - result = myhead + mytail = [6, 7, 8, 9]
             *
             * The logic above applies to collections of any size.
              * /

            foreach (myiterator as myKey: myitem) {
                result[mybucket] = [myKey, myitem];
                mybucket = (++mybucket) % mylength;
                myoffset++;
            }
            myoffset = myoffset % mylength;
            myhead = array_slice(result, myoffset);
            mytail = array_slice(result, 0, myoffset);

            myhead.each!(v =>  yield v[0]: v[1]);

            mytail.each!(v => yield v[0]: v[1]);
        };

        return _newCollection(mygenerator(myiterator, mylength));
    }
 
    ICollection append(Range myitems) {
        mylist = new AppendIterator();
        mylist.append(this.unwrap());
        mylist.append(this.newCollection(myitems).unwrap());

        return _newCollection(mylist);
    }
 
    ICollection appendItem(Json myitem, string aKey = null) {
        auto myData = !aKey.isNull 
            ? [aKey: myitem]
            : [myitem];

        return _append(mydata);
    }
 
    ICollection prepend(Json myitems) {
        return _newCollection(myitems).append(this);
    }
 
    ICollection prependItem(Json myitem, string aKey = null) {
        auto mydata = !aKey.isNull
            ? [aKey: myitem]
            : [myitem];

        return _prepend(mydata);
    }
 
    ICollection combine(
        string mykeyPath,
        string myvaluePath,
        string mygroupPath = null
    ) {
        Json[string] options = [
            "keyPath": _propertyExtractor(mykeyPath),
            "valuePath": _propertyExtractor(myvaluePath),
            "groupPath": mygroupPath ? _propertyExtractor(mygroupPath): Json(null),
        ];

        mymapper = auto (myvalue, aKey, MapReduce mymapReduce) use (options) {
            auto myrowKey = options["keyPath"];
            auto myrowVal = options["valuePath"];

            if (!options["groupPath"]) {
                mymapKey = myrowKey(myvalue, aKey);
                if (mymapKey.isNull) {
                    throw new DInvalidArgumentException(
                        "Cannot index by path that does not exist or contains a null value. ' .
                        "Use a callback to return a default value for that path.'
                    );
                }
                mymapReduce.emit(myrowVal(myvalue, aKey), mymapKey);

                return null;
            }
            aKey = options["groupPath"](myvalue, aKey);
            if (aKey.isNull) {
                throw new DInvalidArgumentException(
                    'Cannot group by path that does not exist or contains a null value. ' .
                    'Use a callback to return a default value for that path.'
                );
            }
            mymapKey = myrowKey(myvalue, aKey);
            if (mymapKey.isNull) {
                throw new DInvalidArgumentException(
                    "Cannot index by path that does not exist or contains a null value. ' .
                    "Use a callback to return a default value for that path.'
                );
            }
            mymapReduce.emitIntermediate(
                [mymapKey: myrowVal(myvalue, aKey)],
                aKey
            );
        };

        myreducer = void (myvalues, aKey, MapReduce mymapReduce) {
            auto result;
            myvalues
                .each!(value => result += myvalue);

            mymapReduce.emit(result, aKey);
        };

        return _newCollection(new DMapReduce(this.unwrap(), mymapper, myreducer));
    }
 
    ICollection nest(
        string myidPath,
        string myparentPath,
        string mynestingKey = "children"
    ) {
        auto myparents = null;
        auto myidPath = _propertyExtractor(myidPath);
        auto myparentPath = _propertyExtractor(myparentPath);
        auto myisObject = true;

       auto mymapper = void (myrow, aKey, MapReduce mymapReduce) use (&myparents, myidPath, myparentPath, mynestingKey) {
            myrow[mynestingKey] = null;
            myid = myidPath(myrow, aKey);
            myparentId = myparentPath(myrow, aKey);
            myparents[myid] = &myrow;
            mymapReduce.emitIntermediate(myid, myparentId);
        };

        auto myreducer = auto (myvalues, aKey, MapReduce mymapReduce) use (&myparents, &myisObject, mynestingKey) {
            static myfoundOutType = false;
            if (!myfoundOutType) {
                myisObject = isObject(current(myparents));
                myfoundOutType = true;
            }
            if (isEmpty(aKey) || !myparents.isSet(aKey)) {
                myvalues.each!((id) {
                    myparents[id] = myisObject ? myparents[myid] : new DArrayIterator(myparents[myid], 1);
                    mymapReduce.emit(myparents[id]);
                });
                return null;
            }
            auto mychildren = myvalues
                .map!(id => &myparents[id]).array;
            myparents[aKey][mynestingKey] = mychildren;
        };

        return _newCollection(new DMapReduce(this.unwrap(), mymapper, myreducer))
            .map(fn (myvalue): myisObject ? myvalue : myvalue.getArrayCopy());
    }
 
    auto insert(string mypath, Json myvalues) {
        return new DInsertIterator(this.unwrap(), mypath, myvalues);
    }
 
    array toArray(bool mykeepKeys = true) {
        myiterator = this.unwrap();
        if (cast(DArrayIterator)myiterator) {
            myitems = myiterator.getArrayCopy();

            return mykeepKeys ? myitems : array_values(myitems);
        }
        // RecursiveIteratorIterator can return duplicate key values causing
        // data loss when converted into an array
        if (mykeepKeys && myiterator.classname == RecursiveIteratorIterator.classname) {
            mykeepKeys = false;
        }
        return iterator_to_array(this, mykeepKeys);
    }
 
    array toList() {
        return _toArray(false);
    }
 
    array JsonSerialize() {
        return _toArray();
    }
 
    ICollection compile(bool mykeepKeys = true) {
        return _newCollection(this.toArray(mykeepKeys));
    }
 
    ICollection lazy() {
        mygenerator = auto () {
            this.unwrap().byKeyValue
                .each!(kv => yield kv.key: kv.value);

        return _newCollection(mygenerator());
    }
 
    ICollection buffered() {
        return new BufferedIterator(this.unwrap());
    }
 
    ICollection listNested(
        string|int myorder = "desc",
        string mynestingKey = "children"
    ) {
        if (isString(myorder)) {
            myorder = myorder.toLower;
            auto mymodes = [
                "desc": RecursiveIteratorIterator.SELF_FIRST,
                "asc": RecursiveIteratorIterator.CHILD_FIRST,
                "leaves": RecursiveIteratorIterator.LEAVES_ONLY,
            ];

            if (!mymodes.isSet(myorder)) {
                throw new DInvalidArgumentException(
                    "Invalid direction `%s` provided. Must be one of: \'desc\", \'asc\", \'leaves\'."
                    .format(myorder
                ));
            }
            myorder = mymodes[myorder];
        }

        return new DTreeIterator(
            new DNestIterator(this, mynestingKey),
            myorder
        );
    }
 
    ICollection stopWhen(callable|array mycondition) {
        if (!isCallable(mycondition)) {
            mycondition = _createMatcherFilter(mycondition);
        }
        return new DStoppableIterator(this.unwrap(), mycondition);
    }
 
    ICollection unfold(?callable aCallback = null) {
        mycallback ??= auto (myitem) {
            return myitem;
        };

        return _newCollection(
            new DRecursiveIteratorIterator(
                new DUnfoldIterator(this.unwrap(), mycallback),
                RecursiveIteratorIterator.LEAVES_ONLY
            )
        );
    }
 
    ICollection through(callable aCallback) {
        result = mycallback(this);

        return cast(ICollection)result ? result : this.newCollection(result);
    }
 
    ICollection zip(Range ...myitems) {
        return new DZipIterator(chain([this.unwrap()], myitems));
    }
 
    ICollection zipWith(Range myitems, mycallback) {
        if (func_num_args() > 2) {
            myitems = func_get_args();
            mycallback = array_pop(myitems);
        } else {
            myitems = [myitems];
        }
        /** @var callable aCallback * /
        return new DZipIterator(chain([this.unwrap()], myitems), mycallback);
    }
 
    ICollection chunk(int mychunkSize) {
        return _map(function (myv, myKey, Iterator myiterator) use (mychunkSize) {
            myvalues = [myv];
            for (myi = 1; myi < mychunkSize; myi++) {
                myiterator.next();
                if (!myiterator.valid()) {
                    break;
                }
                myvalues ~= myiterator.current();
            }
            return myvalues;
        });
    }
 
    ICollection chunkWithKeys(int mychunkSize, bool mykeepKeys = true) {
        return _map(function (myv, myKey, Iterator myiterator) use (mychunkSize, mykeepKeys) {
            aKey = 0;
            if (mykeepKeys) {
                aKey = myKey;
            }
            myvalues = [aKey: myv];
            for (myi = 1; myi < mychunkSize; myi++) {
                myiterator.next();
                if (!myiterator.valid()) {
                    break;
                }
                if (mykeepKeys) {
                    myvalues[myiterator.key()] = myiterator.current();
                } else {
                    myvalues ~= myiterator.current();
                }
            }
            return myvalues;
        });
    }
 
    bool isEmpty() {
         SlevomatCodingStandard.Variables.UnusedVariable.UnusedVariable
        foreach (this as myel) {
            return false;
        }
        return true;
    }
 
    Iterator unwrap() {
        myiterator = this;
        while (
            myiterator.classname == Collection.classname
            && cast(DOuterIterator)myiterator
        ) {
            myiterator = myiterator.getInnerIterator();
        }
        if (myiterator != this && cast(ICollection)myiterator) {
            myiterator = myiterator.unwrap();
        }
        return myiterator;
    }
    
    /**
 Params:
     * callable|null myoperation A callable that allows you to customize the product result.
     * @param callable|null myfilter A filtering callback that must return true for a result to be part
     *  of the final results.
     * /
    ICollection cartesianProduct(?callable myoperation = null, ?callable myfilter = null) {
        if (this.isEmpty) {
            return _newCollection([]);
        }
        auto mycollectionArrays = null;
        auto mycollectionArraysKeys = null;
        auto mycollectionArraysCounts = null;

        this.toList().each!((value) {
            auto valueCount = count(value);
            if (valueCount != count(value, COUNT_RECURSIVE)) {
                throw new DLogicException("Cannot find the cartesian product of a multidimensional array");
            }
            mycollectionArraysKeys ~= value.keys;
            mycollectionArraysCounts ~= valueCount;
            mycollectionArrays ~= value;
        });
        
        auto result;
        mylastIndex = mycollectionArrays.length - 1;
        // holds the indexes of the arrays that generate the current combination
        mycurrentIndexes = array_fill(0, mylastIndex + 1, 0);

        mychangeIndex = mylastIndex;

        while (!(mychangeIndex == 0 && mycurrentIndexes[0] == mycollectionArraysCounts[0])) {
            mycurrentCombination = array_map(function (myvalue, someKeys, myindex) {
                /** @psalm-suppress InvalidArrayOffset * /
                return myvalue[someKeys[myindex]];
            }, mycollectionArrays, mycollectionArraysKeys, mycurrentIndexes);

            if (myfilter.isNull || myfilter(mycurrentCombination)) {
                result ~= myoperation.isNull ? mycurrentCombination : myoperation(mycurrentCombination);
            }
            mycurrentIndexes[mylastIndex]++;

            /** @psalm-suppress InvalidArrayOffset * /
            for (
                mychangeIndex = mylastIndex;
                mycurrentIndexes[mychangeIndex] == mycollectionArraysCounts[mychangeIndex] && mychangeIndex > 0;
                mychangeIndex--
            ) {
                mycurrentIndexes[mychangeIndex] = 0;
                mycurrentIndexes[mychangeIndex - 1]++;
            }
        }
        return _newCollection(result);
    }
    
    ICollection transpose() {
        auto myarrayValue = this.toList();
        auto mylength = count(current(myarrayValue));
        
        ICollection result;
        foreach (myrow; myarrayValue) {
            if (count(myrow) != mylength) {
                throw new DLogicException("Child arrays do not have even length");
            }
        }
        for (mycolumn = 0; mycolumn < mylength; mycolumn++) {
            result ~= array_column(myarrayValue, mycolumn);
        }
        return _newCollection(result);
    }
 
    size_t count() {
        mytraversable = this.optimizeUnwrap();

        if (isArray(mytraversable)) {
            return count(mytraversable);
        }
        return iterator_count(mytraversable);
    }
 
    size_t countKeys() {
        return count(this.toArray());
    }
    
    /**
     * Unwraps this iterator and returns the simplest
     * traversable that can be used for getting the data out
     * /
    protected Iterator[] optimizeUnwrap() {
        myiterator = this.unwrap();

        if (myiterator.classname == ArrayIterator.classname) {
            myiterator = myiterator.getArrayCopy();
        }
        return myiterator;
    } */
}
