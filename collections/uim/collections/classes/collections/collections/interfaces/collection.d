module uim.collectionss.interfaces.collection;

import uim.collectionss;

@safe:

/**
 * Describes the methods a Collection should implement. A collection is an immutable
 * list of elements exposing a number of traversing and extracting method for
 * generating other collections.
 *
 * @template-extends \Iterator<mixed>
 */
interface ICollection : Iterator, JsonSerializable, Countable {
    /**
     * Applies a callback to the elements in this collection.
     *
     * ### Example:
     *
     * ```
     * collection = (new Collection(someItems)).each(function (aValue, aKey) {
     * echo "Element aKey: aValue";
     * });
     * ```
     * Params:
     * callable aCallback Callback to run for each element in collection.
     */
    auto each(callable aCallback);

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
     * collection = (new Collection([1, 2, 3])).filter(function (aValue, aKey) {
     * return aValue % 2 == 0;
     * });
     * ```
     * Params:
     * callable|null aCallback the method that will receive each of the elements and
     *  returns true whether they should be in the resulting collection.
     *  If left null, a callback that filters out falsey values will be used.
     */
    ICollection filter(callable aCallback = null);

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
     * collection = (new Collection([1, 2, 3])).reject(function (aValue, aKey) {
     * return aValue % 2 == 0;
     * });
     * ```
     * Params:
     * callable aCallback the method that will receive each of the elements and
     *  returns true whether they should be out of the resulting collection.
     *  If left null, a callback that filters out truthy values will be used.
     */
    ICollection reject(callable aCallback = null);

    /**
     * Loops through each value in the collection and returns a new collection
     * with only unique values based on the value returned by ``callback``.
     *
     * The callback is passed the value as the first argument and the key as the
     * second argument.
     * Params:
     * callable aCallback the method that will receive each of the elements and
     * returns the value used to determine uniqueness.
     */
    ICollection unique(callable aCallback = null);

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
     * overTwentyOne = (new Collection([24, 45, 60, 15])).every(function (aValue, aKey) {
     * return aValue > 21;
     * });
     * ```
     *
     * Empty collections always return true.
     * Params:
     * callable aCallback a callback function
     */
    bool every(callable aCallback);

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
     * hasYoungPeople = (new Collection([24, 45, 15])).some(function (aValue, aKey) {
     * return aValue < 21;
     * });
     * ```
     * Params:
     * callable aCallback a callback function
     */
    bool some(callable aCallback);

    /**
     * Returns true if aValue is present in this collection. Comparisons are made
     * both by value and type.
     * Params:
     * Json aValue The value to check for
     */
    bool contains(Json aValue);

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
     * collection = (new Collection($people)).map(function ($person, aKey) {
     * return person.gender == "female";
     * });
     * ```
     * Params:
     * callable aCallback the method that will receive each of the elements and
     * returns the new value for the key that is being iterated
     */
    ICollection map(callable aCallback);

    /**
     * Folds the values in this collection to a single value, as the result of
     * applying the callback auto to all elements. zero is the initial state
     * of the reduction, and each successive step of it should be returned
     * by the callback function.
     * If zero is omitted the first value of the collection will be used in its place
     * and reduction will start from the second item.
     * Params:
     * callable aCallback The callback auto to be called
     * @param Json  anInitial The state of reduction
    */
    Json reduce(callable aCallback, Json  anInitial = null);

    /**
     * Returns a new collection containing the column or property value found in each
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
     *  someItems = [
     * ["comment": ["body": 'cool", "user": ["name": 'Mark"]],
     * ["comment": ["body": 'very cool", "user": ["name": 'Renan"]]
     * ];
     * extracted = (new Collection(someItems)).extract("comment.user.name");
     *
     * // Result will look like this when converted to array
     * ["Mark", "Renan"]
     * ```
     *
     * It is also possible to extract a flattened collection out of nested properties
     *
     * ```
     *  someItems = [
     *     ["comment": ["votes": [["value": 1], ["value": 2], ["value": 3]]],
     *     ["comment": ["votes": [["value": 4]]
     * ];
     * extracted = (new Collection(someItems)).extract("comment.votes.{*}.value");
     *
     * // Result will contain
     * [1, 2, 3, 4]
     * ```
     * Params:
     * string aPath A dot separated path of column to follow
     * so that the final one can be returned or a callable that will take care
     * of doing that.
     */
    ICollection extract(string aPath);

    /**
     * Returns the top element in this collection after being sorted by a property.
     * Check the sortBy method for information on the callback and sort parameters
     *
     * ### Examples:
     *
     * ```
     * // For a collection of employees
     * max = collection.max("age");
     * max = collection.max("user.salary");
     * max = collection.max(function (anException) {
     * return anException.get("user").get("salary");
     * });
     *
     * // Display employee name
     * echo max.name;
     * ```
     * Params:
     * string aPath The column name to use for sorting or callback that returns the value.
     * @param int sort The sort type, one of SORT_STRING, SORT_NUMERIC or SORT_NATURAL
     * @see \UIM\Collection\ICollection.sortBy()
     */
    Json max(string aPath, int sort = SORT_NUMERIC);

    /**
     * Returns the bottom element in this collection after being sorted by a property.
     * Check the sortBy method for information on the callback and sort parameters
     *
     * ### Examples:
     *
     * ```
     * // For a collection of employees
     * min = collection.min("age");
     * min = collection.min("user.salary");
     * min = collection.min(function (anException) {
     * return anException.get("user").get("salary");
     * });
     *
     * // Display employee name
     * echo min.name;
     * ```
     * Params:
     * string aPath The column name to use for sorting or callback that returns the value.
     * @param int sort The sort type, one of SORT_STRING, SORT_NUMERIC or SORT_NATURAL
     * @see \UIM\Collection\ICollection.sortBy()
     */
    Json min(string aPath, int sort = SORT_NUMERIC);

    /**
     * Returns the average of all the values extracted with somePath
     * or of this collection.
     *
     * ### Example:
     *
     * ```
     *  someItems = [
     * ["invoice": ["total": 100]],
     * ["invoice": ["total": 200]]
     * ];
     *
     * total = (new Collection(someItems)).avg("invoice.total");
     *
     * // Total: 150
     *
     * total = (new Collection([1, 2, 3])).avg();
     * // Total: 2
     * ```
     *
     * The average of an empty set or 0 rows is `null`. Collections with `null`
     * values are not considered empty.
     * Params:
     * string somePath The property name to compute the average or a function
     * If no value is passed, an identity auto will be used.
     * that will return the value of the property to compute the average.
     */
    float|int avg(string somePath = null);

    /**
     * Returns the median of all the values extracted with somePath
     * or of this collection.
     *
     * ### Example:
     *
     * ```
     *  someItems = [
     * ["invoice": ["total": 400]],
     * ["invoice": ["total": 500]]
     * ["invoice": ["total": 100]]
     * ["invoice": ["total": 333]]
     * ["invoice": ["total": 200]]
     * ];
     *
     * total = (new Collection(someItems)).median("invoice.total");
     *
     * // Total: 333
     *
     * total = (new Collection([1, 2, 3, 4])).median();
     * // Total: 2.5
     * ```
     *
     * The median of an empty set or 0 rows is `null`. Collections with `null`
     * values are not considered empty.
     * Params:
     * string somePath The property name to compute the median or a function
     * If no value is passed, an identity auto will be used.
     * that will return the value of the property to compute the median.
     */
    float|int median(string somePath = null);

    /**
     * Returns a sorted iterator out of the elements in this collection,
     * ranked based on the results of applying a callback auto to each value.
     * The parameter somePath can also be a string representing the column or property name.
     *
     * The callback will receive as its first argument each of the elements in  someItems,
     * the value returned by the callback will be used as the value for sorting such
     * element. Please note that the callback auto could be called more than once
     * per element.
     *
     * ### Example:
     *
     * ```
     *  someItems = collection.sortBy(function ($user) {
     * return user.age;
     * });
     *
     * // alternatively
     *  someItems = collection.sortBy("age");
     *
     * // or use a property path
     *  someItems = collection.sortBy("department.name");
     *
     * // output all user name order by their age in descending order
     * foreach (someItems as user) {
     * echo user.name;
     * }
     * ```
     * Params:
     * string aPath The column name to use for sorting or callback that returns the value.
     * @param int order The sort order, either SORT_DESC or SORT_ASC
     * @param int sort The sort type, one of SORT_STRING, SORT_NUMERIC or SORT_NATURAL
     */
    ICollection sortBy(
        string aPath,
        int order = SORT_DESC,
        int sort = SORT_NUMERIC
    );

    /**
     * Splits a collection into sets, grouped by the result of running each value
     * through the callback. If aCallback is a string instead of a callable,
     * groups by the property named by aCallback on each of the values.
     *
     * When aCallback is a string it should be a property name to extract or
     * a dot separated path of properties that should be followed to get the last
     * one in the path.
     *
     * ### Example:
     *
     * ```
     *  someItems = [
     * ["id": 1, "name": 'foo", "parent_id": 10],
     * ["id": 2, "name": 'bar", "parent_id": 11],
     * ["id": 3, "name": 'baz", "parent_id": 10],
     * ];
     *
     *  anGroup = (new Collection(someItems)).groupBy("parent_id");
     *
     * // Or
     *  anGroup = (new Collection(someItems)).groupBy(function (anException) {
     * return anException["parent_id"];
     * });
     *
     * // Result will look like this when converted to array
     * [
     * 10: [
     *     ["id": 1, "name": 'foo", "parent_id": 10],
     *     ["id": 3, "name": 'baz", "parent_id": 10],
     * ],
     * 11: [
     *     ["id": 2, "name": 'bar", "parent_id": 11],
     * ]
     * ];
     * ```
     * Params:
     * string aPath The column name to use for grouping or callback that returns the value.
     * or a auto returning the grouping key out of the provided element
     */
    ICollection groupBy(string aPath);

    /**
     * Given a list and a callback auto that returns a key for each element
     * in the list (or a property name), returns an object with an index of each item.
     * Just like groupBy, but for when you know your keys are unique.
     *
     * When aCallback is a string it should be a property name to extract or
     * a dot separated path of properties that should be followed to get the last
     * one in the path.
     *
     * ### Example:
     *
     * ```
     *  someItems = [
     * ["id": 1, "name": 'foo"],
     * ["id": 2, "name": 'bar"],
     * ["id": 3, "name": 'baz"],
     * ];
     *
     *  anIndexed = (new Collection(someItems)).indexBy("id");
     *
     * // Or
     *  anIndexed = (new Collection(someItems)).indexBy(function (anException) {
     * return anException["id"];
     * });
     *
     * // Result will look like this when converted to array
     * [
     * 1: ["id": 1, "name": 'foo"],
     * 3: ["id": 3, "name": 'baz"],
     * 2: ["id": 2, "name": 'bar"],
     * ];
     * ```
     * Params:
     * string aPath The column name to use for indexing or callback that returns the value.
     * or a auto returning the indexing key out of the provided element
     */
    ICollection indexBy(string aPath);

    /**
     * Sorts a list into groups and returns a count for the number of elements
     * in each group. Similar to groupBy, but instead of returning a list of values,
     * returns a count for the number of values in that group.
     *
     * When aCallback is a string it should be a property name to extract or
     * a dot separated path of properties that should be followed to get the last
     * one in the path.
     *
     * ### Example:
     *
     * ```
     *  someItems = [
     * ["id": 1, "name": 'foo", "parent_id": 10],
     * ["id": 2, "name": 'bar", "parent_id": 11],
     * ["id": 3, "name": 'baz", "parent_id": 10],
     * ];
     *
     *  anGroup = (new Collection(someItems)).countBy("parent_id");
     *
     * // Or
     *  anGroup = (new Collection(someItems)).countBy(function (anException) {
     * return anException["parent_id"];
     * });
     *
     * // Result will look like this when converted to array
     * [
     * 10: 2,
     * 11: 1
     * ];
     * ```
     * Params:
     * string aPath The column name to use for indexing or callback that returns the value.
     * or a auto returning the indexing key out of the provided element
     */
    ICollection countBy(string aPath);

    /**
     * Returns the total sum of all the values extracted with matcher
     * or of this collection.
     *
     * ### Example:
     *
     * ```
     *  someItems = [
     * ["invoice": ["total": 100]],
     * ["invoice": ["total": 200]],
     * ];
     *
     * total = (new Collection(someItems)).sumOf("invoice.total");
     *
     * // Total: 300
     *
     * total = (new Collection([1, 2, 3])).sumOf();
     * // Total: 6
     * ```
     * Params:
     * string somePath The property name to sum or a function
     * If no value is passed, an identity auto will be used.
     * that will return the value of the property to sum.
     */
    float|int sumOf(string somePath = null);

    /**
     * Returns a new collection with the elements placed in a random order,
     * this auto does not preserve the original keys in the collection.
     */
    ICollection shuffle();

    /**
     * Returns a new collection with maximum length random elements
     * from this collection
     * Params:
     * size_t aLength the maximum number of elements to randomly
     * take from this collection
     */
    ICollection sample(size_t aLength = 10);

    /**
     * Returns a new collection with maximum length elements in the internal
     * order this collection was created. If a second parameter is passed, it
     * will determine from what position to start taking elements.
     * Params:
     * size_t aLength the maximum number of elements to take from
     * this collection
     * @param int anOffset A positional offset from where to take the elements
     */
    ICollection take(size_t aLength = 1, int anOffset = 0);

    /**
     * Returns the last N elements of a collection
     *
     * ### Example:
     *
     * ```
     *  someItems = [1, 2, 3, 4, 5];
     *
     * last = (new Collection(someItems)).takeLast(3);
     *
     * // Result will look like this when converted to array
     * [3, 4, 5];
     * ```
     * Params:
     * size_t aLength The number of elements at the end of the collection
     */
    ICollection takeLast(size_t aLength);

    /**
     * Returns a new collection that will skip the specified amount of elements
     * at the beginning of the iteration.
     * Params:
     * size_t aLength The number of elements to skip.
     * @return self
     */
    ICollection skip(size_t aLength);

    /**
     * Looks through each value in the list, returning a Collection of all the
     * values that contain all of the key-value pairs listed in conditions.
     *
     * ### Example:
     *
     * ```
     *  someItems = [
     * ["comment": ["body": 'cool", "user": ["name": 'Mark"]],
     * ["comment": ["body": 'very cool", "user": ["name": 'Renan"]],
     * ];
     *
     * extracted = (new Collection(someItems)).match(["user.name": 'Renan"]);
     *
     * // Result will look like this when converted to array
     * [
     * ["comment": ["body": 'very cool", "user": ["name": 'Renan"]]]
     * ]
     * ```
     * Params:
     * array conditions a key-value list of conditions where
     * the key is a property path as accepted by `Collection.extract`,
     * and the value the condition against with each element will be matched
     */
    ICollection match(array conditions);

    /**
     * Returns the first result matching all the key-value pairs listed in
     * conditions.
     * Params:
     * array conditions a key-value list of conditions where the key is
     * a property path as accepted by `Collection.extract`, and the value the
     * condition against with each element will be matched
     * @see \UIM\Collection\ICollection.match()
    */
    Json firstMatch(array conditions);

    /**
     * Returns the first result in this collection
     */
    Json first();

    /**
     * Returns the last result in this collection
     */
    Json last();

    /**
     * Returns a new collection as the result of concatenating the list of elements
     * in this collection with the passed list of elements
     * Params:
     * iterable someItems Items list.
     */
    ICollection append(iterable someItems);

    /**
     * Append a single item creating a new collection.
     * Params:
     * Json  anItem The item to append.
     * @param string aKey The key to append the item with. If null a key will be generated.
     */
    ICollection appendItem(Json  anItem, string aKey = null);

    /**
     * Prepend a set of items to a collection creating a new collection
     * Params:
     * iterable someItems The items to prepend.
     */
    ICollection prepend(iterable someItems);

    // Prepend a single item creating a new collection.
    ICollection prependItem(Json itemToPrepend, string keyToPrependItem = null);

    /**
     * Returns a new collection where the values extracted based on a value path
     * and then indexed by a key path. Optionally this method can produce parent
     * groups based on a group property path.
     *
     * ### Examples:
     *
     * ```
     *  someItems = [
     * ["id": 1, "name": 'foo", "parent": 'a"],
     * ["id": 2, "name": 'bar", "parent": 'b"],
     * ["id": 3, "name": 'baz", "parent": 'a"],
     * ];
     *
     * combined = (new Collection(someItems)).combine("id", "name");
     *
     * // Result will look like this when converted to array
     * [
     * 1: 'foo",
     * 2: 'bar",
     * 3: 'baz",
     * ];
     *
     * combined = (new Collection(someItems)).combine("id", "name", "parent");
     *
     * // Result will look like this when converted to array
     * [
     * 'a": [1: 'foo", 3: 'baz"],
     * 'b": [2: 'bar"],
     * ];
     * ```
     * Params:
     * string akeyPath the column name path to use for indexing
     * or a auto returning the indexing key out of the provided element
     * @param string avaluePath the column name path to use as the array value
     * or a auto returning the value out of the provided element
     * @param string  anGroupPath the column name path to use as the parent
     * grouping key or a auto returning the key out of the provided element
     */
    ICollection combine(
        string akeyPath,
        string avaluePath,
        string  anGroupPath = null
    );

    /**
     * Returns a new collection where the values are nested in a tree-like structure
     * based on an id property path and a parent id property path.
     * Params:
     * string aidPath the column name path to use for determining
     * whether an element is a parent of another
     * @param string aparentPath the column name path to use for determining
     * whether an element is a child of another
     * @param string anestingKey The key name under which children are nested
     */
    ICollection nest(
        string aidPath,
        string aparentPath,
        string anestingKey = "children"
    );

    /**
     * Returns a new collection containing each of the elements found in ` someValues` as
     * a property inside the corresponding elements in this collection. The property
     * where the values will be inserted is described by the `somePath` parameter.
     *
     * The somePath can be a string with a property name or a dot separated path of
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
     *  someItems = [
     * ["comment": ["body": 'cool", "user": ["name": 'Mark"]],
     * ["comment": ["body": 'awesome", "user": ["name": 'Renan"]]
     * ];
     * ages = [25, 28];
     *  anInserted = (new Collection(someItems)).insert("comment.user.age", ages);
     *
     * // Result will look like this when converted to array
     * [
     * ["comment": ["body": 'cool", "user": ["name": 'Mark", "age": 25]],
     * ["comment": ["body": 'awesome", "user": ["name": 'Renan", "age": 28]]
     * ];
     * ```
     * Params:
     * string aPath a dot separated string symbolizing the path to follow
     * inside the hierarchy of each value so that the value can be inserted
     * @param Json  someValues The values to be inserted at the specified path,
     * values are matched with the elements in this collection by its positional index.
     * @return self
     */
    ICollection insert(string aPath, Json  someValues);

    /**
     * Returns an array representation of the results
     * Params:
     * bool keepKeys Whether to use the keys returned by this
     * collection as the array keys. Keep in mind that it is valid for iterators
     * to return the same key for different elements, setting this value to false
     * can help getting all items if keys are not important in the result.
     */
    array toArray(bool shouldKeepKeys = true);

    /**
     * Returns an numerically-indexed array representation of the results.
     * This is equivalent to calling `toArray(false)`
     */
    array toList();

    /**
     * Returns the data that can be converted to JSON. This returns the same data
     * as `toArray()` which contains only unique keys.
     *
     * Part of JsonSerializable interface.
     */
    array jsonSerialize();

    /**
     * Iterates once all elements in this collection and executes all stacked
     * operations of them, finally it returns a new collection with the result.
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
     * collection.map($mapper).sortBy("age").extract("name");
     * compiled = collection.compile();
     *  isJohnHere = compiled.some($johnMatcher);
     * allButJohn = compiled.filter($johnMatcher);
     * ```
     *
     * In the above example, had the collection not been compiled before, the
     * iterations for `map`, `sortBy` and `extract` would've been executed twice:
     * once for getting ` isJohnHere` and once for `$allButJohn`
     *
     * You can think of this method as a way to create save points for complex
     * calculations in a collection.
     * Params:
     * bool keepKeys Whether to use the keys returned by this
     * collection as the array keys. Keep in mind that it is valid for iterators
     * to return the same key for different elements, setting this value to false
     * can help getting all items if keys are not important in the result.
     * @return self
     */
    ICollection compile(bool keepKeys = true);

    /**
     * Returns a new collection where any operations chained after it are guaranteed
     * to be run lazily. That is, elements will be yielded one at a time.
     *
     * A lazy collection can only be iterated once. A second attempt results in an error.
     *
     * @return self
     */
    ICollection lazy();

    /**
     * Returns a new collection where the operations performed by this collection.
     * No matter how many times the new collection is iterated, those operations will
     * only be performed once.
     *
     * This can also be used to make any non-rewindable iterator rewindable.
     */
    ICollection buffered();

    /**
     * Returns a new collection with each of the elements of this collection
     * after flattening the tree structure. The tree structure is defined
     * by nesting elements under a key with a known name. It is possible
     * to specify such name by using the '$nestingKey' parameter.
     *
     * By default all elements in the tree following a Depth First Search
     * will be returned, that is, elements from the top parent to the leaves
     * for each branch.
     *
     * It is possible to return all elements from bottom to top using a Breadth First
     * Search approach by passing the '$dir' parameter with 'asc'. That is, it will
     * return all elements for the same tree depth first and from bottom to top.
     *
     * Finally, you can specify to only get a collection with the leaf nodes in the
     * tree structure. You do so by passing 'leaves' in the first argument.
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
     * collection = new Collection([
     * ["id": 1, "children": [["id": 2, "children": [["id": 3]]]]],
     * ["id": 4, "children": [["id": 5]]]
     * ]);
     * flattenedIds = collection.listNested().extract("id"); // Yields [1, 2, 3, 4, 5]
     * ```
     * Params:
     * string|int order The order in which to return the elements
     * @param string anestingKey The key name under which children are nested
     * or a callable auto that will return the children list
     */
    ICollection listNested(
        string|int order = "desc",
        string anestingKey = "children"
    );

    /**
     * Creates a new collection that when iterated will stop yielding results if
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
     * lines = (new Collection($fileLines)).stopWhen(function (aValue, aKey) {
     * return (new DateTime(aValue)).format("Y") < 2012;
     * })
     * .toArray();
     * ```
     *
     * Get elements until the first unapproved message is found:
     *
     * ```
     * comments = (new Collection($comments)).stopWhen(["isApproved": false]);
     * ```
     * Params:
     * callable|array condition the method that will receive each of the elements and
     * returns true when the iteration should be stopped.
     * If an array, it will be interpreted as a key-value list of conditions where
     * the key is a property path as accepted by `Collection.extract`,
     * and the value the condition against with each element will be matched.
     * @return self
     */
    ICollection stopWhen(callable|array condition);

    /**
     * Creates a new collection where the items are the
     * concatenation of the lists of items generated by the transformer function
     * applied to each item in the original collection.
     *
     * The transformer auto will receive the value and the key for each of the
     * items in the collection, in that order, and it must return an array or a
     * Traversable object that can be concatenated to the final result.
     *
     * If no transformer bool is passed, an "identity" auto will be used.
     * This is useful when each of the elements in the source collection are
     * lists of items to be appended one after another.
     *
     * ### Example:
     *
     * ```
     *  someItems [[1, 2, 3], [4, 5]];
     * unfold = (new Collection(someItems)).unfold(); // Returns [1, 2, 3, 4, 5]
     * ```
     *
     * Using a transformer
     *
     * ```
     *  someItems [1, 2, 3];
     * allItems = (new Collection(someItems)).unfold(function ($page) {
     * return service.fetchPage($page).toArray();
     * });
     * ```
     * Params:
     * callable|null aCallback A callable auto that will receive each of
     * the items in the collection and should return an array or Traversable object
     */
    ICollection unfold(callable aCallback = null);

    /**
     * Passes this collection through a callable as its first argument.
     * This is useful for decorating the full collection with another object.
     *
     * ### Example:
     *
     * ```
     *  someItems = [1, 2, 3];
     * decorated = (new Collection(someItems)).through(function ($collection) {
     *     return new MyCustomCollection($collection);
     * });
     * ```
     * Params:
     * callable aCallback A callable auto that will receive
     * this collection as first argument.
     * @return self
     */
    ICollection through(callable aCallback);

    /**
     * Combines the elements of this collection with each of the elements of the
     * passed iterables, using their positional index as a reference.
     *
     * ### Example:
     *
     * ```
     * collection = new Collection([1, 2]);
     * collection.zip([3, 4], [5, 6]).toList(); // returns [[1, 3, 5], [2, 4, 6]]
     * ```
     * Params:
     * iterable ... someItems The collections to zip.
     * @return self
     */
    ICollection zip(iterable ... someItems);

    // phpcs:disable
    /**
     * Combines the elements of this collection with each of the elements of the
     * passed iterables, using their positional index as a reference.
     *
     * The resulting element will be the return value of the aCallable function.
     *
     * ### Example:
     *
     * ```
     * collection = new Collection([1, 2]);
     * zipped = collection.zipWith([3, 4], [5, 6], auto (...someArguments) {
     *  return array_sum(someArguments);
     * });
     * zipped.toList(); // returns [9, 12]; [(1 + 3 + 5), (2 + 4 + 6)]
     * ```
     * Params:
     * iterable ... someItems The collections to zip.
     */
    ICollection zipWith(iterable someItems, callable aCallback);
    // phpcs:enable

    /**
     * Breaks the collection into smaller arrays of the given size.
     *
     * ### Example:
     *
     * ```
     *  someItems [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];
     * chunked = (new Collection(someItems)).chunk(3).toList();
     * // Returns [[1, 2, 3], [4, 5, 6], [7, 8, 9], [10, 11]]
     * ```
     * Params:
     * int chunkSize The maximum size for each chunk
     */
    ICollection chunk(int chunkSize);

    /**
     * Breaks the collection into smaller arrays of the given size.
     *
     * ### Example:
     *
     * ```
     *  someItems ["a": 1, "b": 2, "c": 3, "d": 4, "e": 5, "f": 6];
     * chunked = (new Collection(someItems)).chunkWithKeys(3).toList();
     * // Returns [["a": 1, "b": 2, "c": 3], ["d": 4, "e": 5, "f": 6]]
     * ```
     * Params:
     * int chunkSize The maximum size for each chunk
     * @param bool keepKeys If the keys of the array should be kept
     */
    ICollection chunkWithKeys(int chunkSize, bool keepKeys = true);

    /**
     * Returns whether there are elements in this collection
     *
     * ### Example:
     *
     * ```
     *  someItems [1, 2, 3];
     * (new Collection(someItems)).isEmpty(); // false
     * ```
     *
     * ```
     * (new Collection([])).isEmpty(); // true
     * ```
     */
   bool isEmpty();

    /**
     * Returns the closest nested iterator that can be safely traversed without
     * losing any possible transformations. This is used mainly to remove empty
     * IteratorIterator wrappers that can only slowdown the iteration process.
     */
    Iterator unwrap();

    /**
     * Transpose rows and columns into columns and rows
     *
     * ### Example:
     * ```
     *  someItems = [
     *      ["Products", "2012", "2013", "2014"],
     *      ["Product A", "200", "100", "50"],
     *      ["Product B", "300", "200", "100"],
     *      ["Product C", "400", "300", "200"],
     * ]
     *
     * transpose = (new Collection(someItems)).transpose().toList();
     *
     * // Returns
     * // [
     * //     ["Products", "Product A", "Product B", "Product C"],
     * //     ["2012", "200", "300", "400"],
     * //     ["2013", "100", "200", "300"],
     * //     ["2014", "50", "100", "200"],
     * // ]
     * ```
     */
    ICollection transpose();

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
     * Specifically any collection wrapping a Generator (a auto with a yield statement)
     * or a unbuffered database cursor will not accept any other auto calls after calling
     * `count()` on it.
     *
     * Create a new collection with `buffered()` method to overcome this problem.
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
     *
     */
    size_t count();

    /**
     * Returns the number of unique keys in this iterator. This is the same as the number of
     * elements the collection will contain after calling `toArray()`
     *
     * This method comes with a number of caveats. Please refer to `ICollection.count()`
     * for details.
     *
     * @see \UIM\Collection\ICollection.count()
     */
    size_t countKeys();

    /**
     * Create a new collection that is the cartesian product of the current collection
     *
     * In order to create a cartesian product a collection must contain a single dimension
     * of data.
     *
     * ### Example
     *
     * ```
     * collection = new Collection([["A", "B", "C"], [1, 2, 3]]);
     * result = collection.cartesianProduct().toArray();
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
     * Params:
     * callable|null operation A callable that allows you to customize the product result.
     * @param callable|null filter A filtering callback that must return true for a result to be part
     *  of the final results.
     */
    ICollection cartesianProduct(?callable operation = null, ?callable filter = null);
}
