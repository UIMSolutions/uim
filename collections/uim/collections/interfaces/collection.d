/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
module uim.collections.interfaces.collection;

import uim.collections;

@safe:

/**
 * Describes the methods a Collection should implement. A collection is an immutable
 * list of elements exposing a number of traversing and extracting method for
 * generating other collections.
 */
interface I_Collection {
  /* append

appendItem

avg

buffered

chunk

chunkWithKeys

combine

compile

contains

countBy

each

every

extract

filter

first

firstMatch

groupBy

indexBy

insert

isEmpty

last

listNested

map

match

max

median

min

nest

prepend

prependItem

reduce

reject

sample

shuffle

skip

some

sortBy

stopWhen

sumOf

take

through

transpose

unfold

zip * /
    // Applies a callback to the elements in this collection.
    I_Collection each(void function(string key, Json value) functionCall);

    /**
     * Looks through each value in the collection, and returns another collection with
     * all the values that pass a truth test. Only the values for which the callback
     * returns true will be present in the resulting collection.
     *
     * Each time the callback is executed it will receive the value of the element
     * in the current iteration, the key of the element and this collection as
     * arguments, in that order.
     *
     * ### Example:
     *
     * Filtering odd numbers in an array, at the end only the value 2 will
     * be present in the resulting collection:
     *
     * ```
     * collection = (new D_Collection([1, 2, 3])).filter(// function (value,  key) {
     * return value % 2 == 0;
     * });
     * ```
     * /
    I_Collection filter(bool delegate(Json item));

    /**
     * Looks through each value in the collection, and returns another collection with
     * all the values that do not pass a truth test. This is the opposite of `filter`.
     *
     * Each time the callback is executed it will receive the value of the element
     * in the current iteration, the key of the element and this collection as
     * arguments, in that order.
     *
     * ### Example:
     *
     * Filtering even numbers in an array, at the end only values 1 and 3 will
     * be present in the resulting collection:
     *
     * ```
     * collection = (new D_Collection([1, 2, 3])).reject(// function (value,  key) {
     * return value % 2 == 0;
     * });
     * ```
     */
    // I_Collection reject(callable callbackForEachElement);

    /**
     * Returns true if all values in this collection pass the truth test provided
     * in the callback.
     *
     * The callback is passed the value and key of the element being tested and should
     * return true if the test passed.
     *
     * ### Example:
     *
     * ```
     * overTwentyOne = (new D_Collection([24, 45, 60, 15])).every(// function (value,  key) {
     * return value > 21;
     * });
     * ```
     * Empty collections always return true.
     * /
    bool every(callable callback);

    /**
     * Returns true if any of the values in this collection pass the truth test
     * provided in the callback.
     *
     * The callback is passed the value and key of the element being tested and should
     * return true if the test passed.
     *
     * ### Example:
     *
     * ```
     * $hasYoungPeople = (new D_Collection([24, 45, 15])).any(// function (value,  key) {
     * return value < 21;
     * });
     * ```
     * /
    bool any(callable callback);

    /**
     * Returns true if value is present in this collection. Comparisons are made
     * both by value and type.
     * /
    bool contains(Json value);

    /**
     * Returns another collection after modifying each of the values in this one using
     * the provided callable.
     *
     * Each time the callback is executed it will receive the value of the element
     * in the current iteration, the key of the element and this collection as
     * arguments, in that order.
     *
     * ### Example:
     *
     * Getting a collection of booleans where true indicates if a person is female:
     *
     * ```
     * collection = (new D_Collection(people)).map(// function (person,  key) {
     * return person.gender == "female";
     * });
     * ```
     * /
    I_Collection map(callable callback);

    /**
     * Folds the values in this collection to a single value, as the result of
     * applying the callback // function to all elements. zero is the initial state
     * of the reduction, and each successive step of it should be returned
     * by the callback function.
     * If zero is omitted the first value of the collection will be used in its place
     * and reduction will start from the second item.
     * /
    Json reduce(callable callback, initial = null);

    /**
     * Returns a new D_Collection containing the column or property value found in each
     * of the elements.
     *
     * The matcher can be a string with a property name to extract or a dot separated
     * path of properties that should be followed to get the last one in the path.
     *
     * If a column or property could not be found for a particular element in the
     * collection, that position is filled with null.
     *
     * ### Example:
     *
     * Extract the user name for all comments in the array:
     *
     * ```
     * items = [
     * ["comment": ["body": "cool", "user": ["name": "Mark"]],
     * ["comment": ["body": "very cool", "user": ["name": "Renan"]]
     * ];
     * extracted = (new D_Collection(items)).extract("comment.user.name");
     *
     * Result will look like this when converted to array
     * ["Mark", "Renan"]
     * ```
     *
     * It is also possible to extract a flattened collection out of nested properties
     *
     * ```
     * items = [
     *     ["comment": ["votes": [["value": 1], ["value": 2], ["value": 3]]],
     *     ["comment": ["votes": [["value": 4]]
     * ];
     * extracted = (new D_Collection(items)).extract("comment.votes.{*}.value");
     *
     * Result will contain
     * [1, 2, 3, 4]
     * ```
    * /
    // TODO  I_Collection extract(/* callable * / string path);
    /* I_Collection extract(string path);

    /**
     * Returns the top element in this collection after being sorted by a property.
     * Check the sortBy method for information on the callback and sort parameters
     *
     * ### Examples:
     *
     * ```
     * For a collection of employees
     * max = collection.max("age");
     * max = collection.max("user.salary");
     * max = collection.max(// function (e) {
     * return e.get("user").get("salary");
     * });
     *
     * Display employee name
     * writeln(max.name;
     * ```
     * /
    Json max(string columnName, int sortType = 0); // TODO SORT_NUMERIC);

    /**
     * Returns the bottom element in this collection after being sorted by a property.
     * Check the sortBy method for information on the callback and sortType parameters
     *
     * ### Examples:
     *
     * ```
     * For a collection of employees
     * min = collection.min("age");
     * min = collection.min("user.salary");
     * min = collection.min(// function (e) {
     * return e.get("user").get("salary");
     * });
     *
     * Display employee name
     * writeln(min.name;
     * ```
     */
    // Json min(columnName, int sortType = SORT_NUMERIC);

    /**
     * Returns the average of all the values extracted with path
     * or of this collection.
     *
     * ### Example:
     *
     * ```
     * items = [
     * ["invoice": ["total": 100]],
     * ["invoice": ["total": 200]]
     * ];
     *
     * total = (new D_Collection(items)).avg("invoice.total");
     *
     * Total: 150
     *
     * total = (new D_Collection([1, 2, 3])).avg();
     * Total: 2
     * ```
     *
     * The average of an empty set or 0 rows is `null`. Collections with `null`
     * values are not considered empty.
     * /
    double avg(string propertyName = null);

    /**
     * Returns the median of all the values extracted with path
     * or of this collection.
     *
     * ### Example:
     *
     * ```
     * items = [
     * ["invoice": ["total": 400]],
     * ["invoice": ["total": 500]]
     * ["invoice": ["total": 100]]
     * ["invoice": ["total": 333]]
     * ["invoice": ["total": 200]]
     * ];
     *
     * total = (new D_Collection(items)).median("invoice.total");
     *
     * Total: 333
     *
     * total = (new D_Collection([1, 2, 3, 4])).median();
     * Total: 2.5
     * ```
     *
     * The median of an empty set or 0 rows is `null`. Collections with `null`
     * values are not considered empty.
     * /
    double median(string propertyName = null);

    /**
     * Returns a sorted iterator out of the elements in this collection,
     * ranked in ascending order by the results of running each value through a
     * callback. callback can also be a string representing the column or property
     * name.
     *
     * The callback will receive as its first argument each of the elements in items,
     * the value returned by the callback will be used as the value for sorting such
     * element. Please note that the callback // function could be called more than once
     * per element.
     *
     * ### Example:
     *
     * ```
     * items = collection.sortBy(// function (user) {
     * return user.age;
     * });
     *
     * alternatively
     * items = collection.sortBy("age");
     *
     * or use a property path
     * items = collection.sortBy("department.name");
     *
     * output all user name order by their age in descending order
     * foreach (items as user) {
     * writeln(user.name;
     * }
     * ```
     * /
    I_Collection sortBy(string columnName, int sortOrder = 0 /* SORT_DESC * /, int sortType = 0 /* SORT_NUMERIC * /);

    /**
     * Splits a collection into sets, grouped by the result of running each value
     * through the callback. If callback is a string instead of a callable,
     * groups by the property named by callback on each of the values.
     *
     * When callback is a string it should be a property name to extract or
     * a dot separated path of properties that should be followed to get the last
     * one in the path.
     *
     * ### Example:
     *
     * ```
     * items = [
     * ["id": 1, "name": "foo", "parent_id": 10],
     * ["id": 2, "name": "bar", "parent_id": 11],
     * ["id": 3, "name": "baz", "parent_id": 10],
     * ];
     *
     * group = (new D_Collection(items)).groupBy("parent_id");
     *
     * Or
     * group = (new D_Collection(items)).groupBy(// function (e) {
     * return e["parent_id"];
     * });
     *
     * Result will look like this when converted to array
     * [
     * 10: [
     *     ["id": 1, "name": "foo", "parent_id": 10],
     *     ["id": 3, "name": "baz", "parent_id": 10],
     * ],
     * 11: [
     *     ["id": 2, "name": "bar", "parent_id": 11],
     * ]
     * ];
     * ```
      * /
    I_Collection groupBy(string columnName);

    /**
     * Given a list and a callback // function that returns a key for each element
     * in the list (or a property name), returns an object with an index of each item.
     * Just like groupBy, but for when you know your keys are unique.
     *
     * When callback is a string it should be a property name to extract or
     * a dot separated path of properties that should be followed to get the last
     * one in the path.
     *
     * ### Example:
     *
     * ```
     * items = [
     * ["id": 1, "name": "foo"],
     * ["id": 2, "name": "bar"],
     * ["id": 3, "name": "baz"],
     * ];
     *
     * indexed = (new D_Collection(items)).indexBy("id");
     *
     * Or
     * indexed = (new D_Collection(items)).indexBy(// function (e) {
     * return e["id"];
     * });
     *
     * Result will look like this when converted to array
     * [
     * 1: ["id": 1, "name": "foo"],
     * 3: ["id": 3, "name": "baz"],
     * 2: ["id": 2, "name": "bar"],
     * ];
     * ```
     * /
    I_Collection indexBy(string columnName);

    /**
     * Sorts a list into groups and returns a count for the number of elements
     * in each group. Similar to groupBy, but instead of returning a list of values,
     * returns a count for the number of values in that group.
     *
     * When callback is a string it should be a property name to extract or
     * a dot separated path of properties that should be followed to get the last
     * one in the path.
     *
     * ### Example:
     *
     * ```
     * items = [
     * ["id": 1, "name": "foo", "parent_id": 10],
     * ["id": 2, "name": "bar", "parent_id": 11],
     * ["id": 3, "name": "baz", "parent_id": 10],
     * ];
     *
     * group = (new D_Collection(items)).countBy("parent_id");
     *
     *  Or
     * group = (new D_Collection(items)).countBy(// function (e) {
     * return e["parent_id"];
     * });
     *
     *  Result will look like this when converted to array
     * [
     * 10: 2,
     * 11: 1
     * ];
     * ```
     * /
    I_Collection countBy(string columnName);

    /**
     * Returns the total sum of all the values extracted with  matcher
     * or of this collection.
     *
     * ### Example:
     *
     * ```
     * items = [
     * ["invoice": ["total": 100]],
     * ["invoice": ["total": 200]]
     * ];
     *
     * total = (new D_Collection(items)).sumOf("invoice.total");
     *
     *  Total: 300
     *
     * total = (new D_Collection([1, 2, 3])).sumOf();
     *  Total: 6
     * ```
     * /
    float sumOf(string propertyName = null);

    /**
     * Returns a new D_Collection with the elements placed in a random order,
     * this // function does not preserve the original keys in the collection.
     * /
    I_Collection shuffle();

    // Returns a new D_Collection with maximum size random elements from this collection
    I_Collection sample(int maxNumberOfElements);

    /**
     * Returns a new D_Collection with maximum size elements in the internal
     * order this collection was created. If a second parameter is passed, it
     * will determine from what position to start taking elements.
     * /
    I_Collection take(int numberOfElements = 1, int positionalOffset = 0);

    /**
     * Returns the last N elements of a collection
     *
     * ### Example:
     *
     * ```
     * items = [1, 2, 3, 4, 5];
     *
     * last = (new D_Collection(items)).takeLast(3);
     *
     * Result will look like this when converted to array
     * [3, 4, 5];
     * /
    I_Collection takeLast(int numberOfElements);

    /**
     * Returns a new D_Collection that will skip the specified amount of elements
     * at the beginning of the iteration.
     * /
    I_Collection skip(int elementsToSkip);

    /**
     * Looks through each value in the list, returning a Collection of all the
     * values that contain all of the key-value pairs listed in conditions.
     *
     * ### Example:
     *
     * ```
     * items = [
     * ["comment": ["body": "cool", "user": ["name": "Mark"]],
     * ["comment": ["body": "very cool", "user": ["name": "Renan"]]
     * ];
     *
     * extracted = (new D_Collection(items)).match(["user.name": "Renan"]);
     *
     * Result will look like this when converted to array
     * [
     * ["comment": ["body": "very cool", "user": ["name": "Renan"]]
     * ]
     * ```
     * /
    I_Collection match(Json[string] conditions);

    // Returns the first result matching all the key-value pairs listed in conditions.
    Json firstMatch(Json[string] conditionsWithPath);

    // Returns the first result in this collection
    Json first();

    // Returns the last result in this collection
    Json last();

    /**
     * Returns a new D_Collection as the result of concatenating the list of elements
     * in this collection with the passed list of elements
     * /
    I_Collection append(Json[] items);

    // Append a single item creating a new D_Collection.
    I_Collection appendItem(Json itemToAppend, Json keyToAppend = null);

    // Prepend a set of items to a collection creating a new D_Collection
    I_Collection prepend(Json[string] itemsToPrepend);

    // Prepend a single item creating a new D_Collection.
    I_Collection prependItem(Json itemToPrepend, Json key = null);

    /**
     * Returns a new D_Collection where the values extracted based on a value path
     * and then indexed by a key path. Optionally this method can produce parent
     * groups based on a group property path.
     *
     * ### Examples:
     *
     * items = [
     * ["id": 1, "name": "foo", "parent": "a"],
     * ["id": 2, "name": "bar", "parent": "b"],
     * ["id": 3, "name": "baz", "parent": "a"],
     * ];
     *
     * combined = (new D_Collection(items)).combine("id", "name");
     *
     * Result will look like this when converted to array
     * [
     * 1: "foo",
     * 2: "bar",
     * 3: "baz",
     * ];
     *
     * combined = (new D_Collection(items)).combine("id", "name", "parent");
     *
     * Result will look like this when converted to array
     * [
     * "a": [1: "foo", 3: "baz"],
     * "b": [2: "bar"]
     * ];
     * /
    I_Collection combine(string keyPath, string valuePath, string groupPath = null);

    /**
     * Returns a new D_Collection where the values are nested in a tree-like structure
     * based on an id property path and a parent id property path.
     * /
    I_Collection nest(string idPath, string parentPath, string nestingKey = "children");

    /**
     * Returns a new D_Collection containing each of the elements found in `values` as
     * a property inside the corresponding elements in this collection. The property
     * where the values will be inserted is described by the `path` parameter.
     *
     * The path can be a string with a property name or a dot separated path of
     * properties that should be followed to get the last one in the path.
     *
     * If a column or property could not be found for a particular element in the
     * collection as part of the path, the element will be kept unchanged.
     *
     * ### Example:
     *
     * Insert ages into a collection containing users:
     *
     * ```
     * items = [
     * ["comment": ["body": "cool", "user": ["name": "Mark"]],
     * ["comment": ["body": "awesome", "user": ["name": "Renan"]]
     * ];
     * ages = [25, 28];
     * inserted = (new D_Collection(items)).insert("comment.user.age", ages);
     *
     * Result will look like this when converted to array
     * [
     * ["comment": ["body": "cool", "user": ["name": "Mark", "age": 25]],
     * ["comment": ["body": "awesome", "user": ["name": "Renan", "age": 28]]
     * ];
     * ```
     * /
    I_Collection insert(string path, Json[string] valuesToInsert);

    /**
     * Returns an array representation of the results
     *
     * shouldKeepKeys - Whether to use the keys returned by this
     * collection as the array keys. Keep in mind that it is valid for iterators
     * to return the same key for different elements, setting this value to false
     * can help getting all items if keys are not important in the result.
      * /
    Json[string] toArray(bool shouldKeepKeys = true);

    /**
     * Returns an numerically-indexed array representation of the results.
     * This is equivalent to calling `toArray(false)`
     * /
    Json[string] toList();

    /**
     * Returns the data that can be converted to Json. This returns the same data
     * as `toArray()` which contains only unique keys.
     * Part of JsonSerializable interface
     * /
    Json[string] JsonSerialize();

    /**
     * Iterates once all elements in this collection and executes all stacked
     * operations of them, finally it returns a new D_Collection with the result.
     * This is useful for converting non-rewindable internal iterators into
     * a collection that can be rewound and used multiple times.
     *
     * A common use case is to re-use the same variable for calculating different
     * data. In those cases it may be helpful and more performant to first compile
     * a collection and then apply more operations to it.
     *
     * ### Example:
     *
     * ```
     * collection.map(mapper).sortBy("age").extract("name");
     * compiled = collection.compile();
     * isJohnHere = compiled.any(johnMatcher);
     * allButJohn = compiled.filter(johnMatcher);
     * ```
     *
     * In the above example, had the collection not been compiled before, the
     * iterations for `map`, `sortBy` and `extract` would"ve been executed twice:
     * once for getting `isJohnHere` and once for `allButJohn`
     *
     * You can think of this method as a way to create save points for complex
     * calculations in a collection.
     * /
    I_Collection compile(bool shouldKeepKeys = true);

    /**
     * Returns a new D_Collection where any operations chained after it are guaranteed
     * to be run lazily. That is, elements will be yieleded one at a time.
     *
     * A lazy collection can only be iterated once. A second attempt results in an error.
      * /
    I_Collection lazyCollection();

    /**
     * Returns a new D_Collection where the operations performed by this collection.
     * No matter how many times the new D_Collection is iterated, those operations will
     * only be performed once.
     *
     * This can also be used to make any non-rewindable iterator rewindable.
     * /
    I_Collection buffered();

    /**
     * Returns a new D_Collection with each of the elements of this collection
     * after flattening the tree structure. The tree structure is defined
     * by nesting elements under a key with a known name. It is possible
     * to specify such name by using the "nestingKey" parameter.
     *
     * By default all elements in the tree following a Depth First Search
     * will be returned, that is, elements from the top parent to the leaves
     * for each branch.
     *
     * It is possible to return all elements from bottom to top using a Breadth First
     * Search approach by passing the " dir" parameter with "asc". That is, it will
     * return all elements for the same tree depth first and from bottom to top.
     *
     * Finally, you can specify to only get a collection with the leaf nodes in the
     * tree structure. You do so by passing "leaves" in the first argument.
     *
     * The possible values for the first argument are aliases for the following
     * constants and it is valid to pass those instead of the alias:
     *
     * - desc: RecursiveIteratorIterator.SELF_FIRST
     * - asc: RecursiveIteratorIterator.CHILD_FIRST
     * - leaves: RecursiveIteratorIterator.LEAVES_ONLY
     *
     * ### Example:
     *
     * ```
     * collection = new D_Collection([
     * ["id": 1, "children": [["id": 2, "children": [["id": 3]]]]],
     * ["id": 4, "children": [["id": 5]]]
     * ]);
     * flattenedIds = collection.listNested().extract("id"); // Yields [1, 2, 3, 4, 5]
     * ```
     * /
    // I_Collection listNested(callable - string order = "desc", string nestingKey = "children");
    I_Collection listNested(string order = "desc", string nestingKey = "children");

    /**
     * Creates a new D_Collection that when iterated will stop yielding results if
     * the provided condition evaluates to true.
     *
     * This is handy for dealing with infinite iterators or any generator that
     * could start returning invalid elements at a certain point. For example,
     * when reading lines from a file stream you may want to stop the iteration
     * after a certain value is reached.
     *
     * ### Example:
     *
     * Get an array of lines in a CSV file until the timestamp column is less than a date
     *
     * ```
     * lines = (new D_Collection(fileLines)).stopWhen(// function (value,  key) {
     * return (new DateTime(value)).format("Y") < 2012;
     * })
     * .toJString();
     * ```
     *
     * Get elements until the first unapproved message is found:
     *
     * ```
     * comments = (new D_Collection(comments)).stopWhen(["is_approved": false]);
     * ```
     * /
    I_Collection stopWhen(Json[string] condition);

    /**
     * Creates a new D_Collection where the items are the
     * concatenation of the lists of items generated by the transformer function
     * applied to each item in the original collection.
     *
     * The transformer // function will receive the value and the key for each of the
     * items in the collection, in that order, and it must return an array or a
     * Traversable object that can be concatenated to the final result.
     *
     * If no transformer bool is passed, an "identity" // function will be used.
     * This is useful when each of the elements in the source collection are
     * lists of items to be appended one after another.
     *
     * ### Example:
     *
     * ```
     * items [[1, 2, 3], [4, 5]];
     * unfold = (new D_Collection(items)).unfold(); // Returns [1, 2, 3, 4, 5]
     * ```
     *
     * Using a transformer
     *
     * ```
     * items [1, 2, 3];
     * allItems = (new D_Collection(items)).unfold(// function (page) {
     * return service.fetchPage(page).toJString();
     * });
     * ```
     * /
    I_Collection unfold(callable callback = null);

    /**
     * Passes this collection through a callable as its first argument.
     * This is useful for decorating the full collection with another object.
     *
     * ### Example:
     *
     * ```
     * items = [1, 2, 3];
     * decorated = (new D_Collection(items)).through(// function (collection) {
     *     return new DMyCustomCollection(collection);
     * });
     * ```
     * /
    I_Collection through(callable callback);

    /**
     * Combines the elements of this collection with each of the elements of the
     * passed iterables, using their positional index as a reference.
     *
     * ### Example:
     *
     * ```
     * collection = new D_Collection([1, 2]);
     * collection.zip([3, 4], [5, 6]).toList(); // returns [[1, 3, 5], [2, 4, 6]]
     * ```
     * /
    // I_Collection zip(Json[string] itemsToZip): ;

    /**
     * Combines the elements of this collection with each of the elements of the
     * passed iterables, using their positional index as a reference.
     *
     * The resulting element will be the return value of the callable function.
     *
     * ### Example:
     *
     * ```
     * collection = new D_Collection([1, 2]);
     * zipped = collection.zipWith([3, 4], [5, 6], // function (...args) {
     *  return array_sum(args);
     * });
     * zipped.toList(); // returns [9, 12]; [(1 + 3 + 5), (2 + 4 + 6)]
     * ```
     * /
    I_Collection zipWith(Json[string] collectionsToZip, callable callback);

    /**
     * Breaks the collection into smaller arrays of the given size.
     *
     * ### Example:
     *
     * ```
     * items [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];
     * chunked = (new D_Collection(items)).chunk(3).toList();
     * Returns [[1, 2, 3], [4, 5, 6], [7, 8, 9], [10, 11]]
     * ```
     * /
    I_Collection chunk(int chunkMaxsize);

    /**
     * Breaks the collection into smaller arrays of the given size.
     *
     * ### Example:
     *
     * ```
     * items ["a": 1, "b": 2, "c": 3, "d": 4, "e": 5, "f": 6];
     * chunked = (new D_Collection(items)).chunkWithKeys(3).toList();
     * Returns [["a": 1, "b": 2, "c": 3], ["d": 4, "e": 5, "f": 6]]
     * ```
     * /
    I_Collection chunkWithKeys(int chunkMaxsize, bool shouldKeepKeys = true);

    /**
     * Returns whether there are elements in this collection
     *
     * ### Example:
     *
     * ```
     * items [1, 2, 3];
     * (new D_Collection(items)).isEmpty(); // false
     * ```
     *
     * ```
     * (new D_Collection([])).isEmpty(); // true
     * ```
     * /
    bool isEmpty();

    /**
     * Returns the closest nested iterator that can be safely traversed without
     * losing any possible transformations. This is used mainly to remove empty
     * IteratorIterator wrappers that can only slowdown the iteration process.
     * /
    Traversable unwrap();

    /**
     * Transpose rows and columns into columns and rows
     *
     * ### Example:
     *
     * 
     * items = [
     *      ["Products", "2012", "2013", "2014"],
     *      ["Product A", "200", "100", "50"],
     *      ["Product B", "300", "200", "100"],
     *      ["Product C", "400", "300", "200"],
     * ]
     *
     * transpose = (new D_Collection(items)).transpose().toList();
     *
     * Returns
     * [
     *     ["Products", "Product A", "Product B", "Product C"],
     *     ["2012", "200", "300", "400"],
     *     ["2013", "100", "200", "300"],
     *     ["2014", "50", "100", "200"],
     * ]
     * ```
     * /
    I_Collection transpose();

    /**
     * Returns the amount of elements in the collection.
     *
     * ## WARNINGS:
     *
     * ### Will change the current position of the iterator:
     *
     * Calling this method at the same time that you are iterating this collections, for example in
     * a foreach, will result in undefined behavior. Avoid doing this.
     *
     *
     * ### Consumes all elements for NoRewindIterator collections:
     *
     * On certain type of collections, calling this method may render unusable afterwards.
     * That is, you may not be able to get elements out of it, or to iterate on it anymore.
     *
     * Specifically any collection wrapping a Generator (a // function with a yield statement)
     * or a unbuffered database cursor will not accept any other // function calls after calling
     * `count()` on it.
     *
     * Create a new D_Collection with `buffered()` method to overcome this problem.
     *
     * ### Can report more elements than unique keys:
     *
     * Any collection constructed by appending collections together, or by having internal iterators
     * returning duplicate keys, will report a larger amount of elements using this functions than
     * the final amount of elements when converting the collections to a keyed array. This is because
     * duplicate keys will be collapsed into a single one in the final array, whereas this count method
     * is only concerned by the amount of elements after converting it to a plain list.
     *
     * If you need the count of elements after taking the keys in consideration
     * (the count of unique keys), you can call `countKeys()`
     * /
    size_t count();

    /**
     * Returns the number of unique keys in this iterator. This is the same as the number of
     * elements the collection will contain after calling `toArray()`
     *
     * This method comes with a number of caveats. Please refer to `I_Collection.count()`
     * for details.
     * /
    size_t countKeys();

    /**
     * Create a new D_Collection that is the cartesian product of the current collection
     *
     * In order to create a carteisan product a collection must contain a single dimension
     * of data.
     *
     * ### Example
     *
     * ```
     * collection = new D_Collection([["A", "B", "C"], [1, 2, 3]]);
     * result = collection.cartesianProduct().toJString();
     * expected = [
     *    ["A", 1],
     *    ["A", 2],
     *    ["A", 3],
     *    ["B", 1],
     *    ["B", 2],
     *    ["B", 3],
     *    ["C", 1],
     *    ["C", 2],
     *    ["C", 3],
     * ];
     * ```
     */
    // I_Collection cartesianProduct(callable operation = null, callable filter = null);
}
