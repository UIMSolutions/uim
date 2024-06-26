module uim.models.interfaces.data;

import uim.models;

@safe:
interface IData {

    // IAttribute attribute();
    string typeName();

    // #region is-check
        // #region is-BasicTypes
            bool isArray();
            void isArray(bool mode);

            bool isBigInt();	 
            void isBigInt(bool mode);

            bool isBoolean();	 
            void isBoolean(bool mode);

            bool isDouble();	 
            void isDouble(bool mode);

            bool isLong();	 
            void isLong(bool mode);

            bool isNull();	 
            void isNull(bool mode);

            bool isObject();	 
            void isObject(bool mode);

            bool isString();	 
            void isString(bool mode);
        // #endregion is-BasicTypes

        // #region is-AdditionalTypes
            bool isUUID();
            void isUUID(bool mode);

            bool isNumber();
            void isNumber(bool mode);

            bool isNumeric();
            void isNumeric(bool mode);

            bool isTime();
            void isTime(bool mode);

            bool isDate();
            void isDate(bool mode);

            bool isDatetime();
            void isDatetime(bool mode);

            bool isTimestamp();
            void isTimestamp(bool mode);
        // #region is-AdditionalTypes

        // #region is-General
            bool isScalar();
            void isScalar(bool mode);

            bool isArray();
            void isArray(bool mode);

            bool isEntity();
            void isEntity(bool mode);

            bool isNullable();
            void isNullable(bool mode);

            bool isEmpty();

            bool isReadOnly();
            void isReadOnly(bool mode);
        // #region is-General
    // #endregion is-check

    // #region get
        bool getBoolean();
        long getLong(); 
        double getDouble();
        string getString();
        UUID getUUID();
        Json getJson();
    // #region isEqual

    // #region isEqual
        bool isEqual(bool value);
        bool isEqual(long value); 
        bool isEqual(double value);
        bool isEqual(string value);
        bool isEqual(UUID value);
        bool isEqual(Json value);
        bool isEqual(Json[] value);
        bool isEqual(Json[string] value);
    // #endregion isEqual

    // #region set
        void set(bool value);
        void set(long value);
        void set(double value);
        void set(string value);
        void set(UUID value);
        void set(Json value);
    // #endregion set

    /* IData at(size_t pos);
    Json toJson();
    string toString();
    string[] toStringArray();
    size_t length();

    bool hasPaths(string[] paths, string separator = "/");
    bool hasPath(string path, string separator = "/");

    bool hasKey(); // One single key
    string key();
    void key(string newKey);

    bool hasAllKeys(string[]); // Has many keys , one or more 
    string[] keys();

    bool hasAllKeys(string[] keys, bool deepSearch = false);
    bool hasKey(string key, bool deepSearch = false);

    bool hasData(IData[string] checkData, bool deepSearch = false);
    bool hasData(IData[] data, bool deepSearch = false);
    bool hasData(IData data, bool deepSearch = false);

    IData value(string key, IData defaultData);

    IData[string] data(string[] keys);
    IData data(string key);
    IData opIndex(string key);

    void data(string key, IData data);
    void opAssignIndex(IData data, string key);

    string toString();
    Json toJson(string[] selectedKeys = null); */
}

/*

Underscore.js

Underscore is a JavaScript library that provides a whole mess of useful functional programming helpers without extending any built-in objects. It’s the answer to the question: “If I sit down in front of a blank HTML page, and want to start being productive immediately, what do I need?” … and the tie to go along with jQuery's tux and Backbone's suspenders.

Underscore provides over 100 functions that support both your favorite workaday functional helpers: map, filter, invoke — as well as more specialized goodies: function binding, javascript templating, creating quick indexes, deep equality testing, and so on.

A complete Test Suite is included for your perusal.

You may also read through the annotated source code. There is a modular version with clickable import references as well.

You may choose between monolithic and modular imports. There is a quick summary of the options below, as well as a more comprehensive discussion in the article.

Enjoying Underscore, and want to turn it up to 11? Try Underscore-contrib.

The project is hosted on GitHub. You can report bugs and discuss features on the issues page or chat in the Gitter channel.

You can support the project by donating on Patreon. Enterprise coverage is available as part of the Tidelift Subscription.

Underscore is an open-source component of DocumentCloud.

v1.13.6 Downloads (Right-click, and use "Save As")
ESM (Development)	65.9 KB, Uncompressed with Plentiful Comments  (Source Map)
ESM (Production)	8.59 KB, Minified and Gzipped  (Source Map)
UMD (Development)	68.4 KB, Uncompressed with Bountiful Comments  (Source Map)
UMD (Production)	7.48 KB, Minified and Gzipped  (Source Map)
Edge ESM	Unreleased, current master, use by your own judgement and at your own risk
Edge UMD	Unreleased, current master, use if you’re feeling lucky
v1.13.6 CDN URLs (Use with <script src="..."></script>)
https://cdn.jsdelivr.net/npm/underscore@1.13.6/underscore-umd-min.js
https://cdn.jsdelivr.net/npm/underscore@1.13.6/underscore-esm-min.js
https://unpkg.com/underscore@1.13.6/underscore-umd-min.js
https://unpkg.com/underscore@1.13.6/underscore-esm-min.js
https://pagecdn.io/lib/underscore/1.13.6/underscore-umd-min.js
https://pagecdn.io/lib/underscore/1.13.6/underscore-esm-min.js
https://cdnjs.cloudflare.com/ajax/libs/underscore.js/1.13.6/underscore-umd-min.js
https://cdnjs.cloudflare.com/ajax/libs/underscore.js/1.13.6/underscore-esm-min.js
In most cases, you can replace the version number above by latest so that your embed will automatically use the latest version, or stable if you want to delay updating until an update has proven to be free of accidental breaking changes. Example:
https://cdn.jsdelivr.net/npm/underscore@latest/underscore-umd-min.js

Package Installation
Node.js npm install underscore
Meteor.js meteor add underscore
Bower bower install underscore
If you are hardcoding the path to the file within the package and you are unsure which build to use, it is very likely that you need underscore-umd.js or the minified variant underscore-umd-min.js.

Monolithic Import (recommended)
ESM import _, { map } from 'underscore';
AMD require(['underscore'], ...)
CommonJS var _ = require('underscore');
ExtendScript #include "underscore-umd.js"
Modular Import
ESM import map from 'underscore/modules/map.js'
AMD require(['underscore/amd/map.js'], ...)
CommonJS var map = require('underscore/cjs/map.js');
For functions with multiple aliases, the file name of the module is always the first name that appears in the documentation. For example, _.reduce/_.inject/_.foldl is exported from underscore/modules/reduce.js. Modular usage is mostly recommended for creating a customized build of Underscore.

Engine Compatibility
Underscore 1.x is backwards compatible with any engine that fully supports ES3, while also utilizing newer features when available, such as Object.keys, typed arrays and ES modules. We routinely run our unittests against the JavaScript engines listed below:

Chrome 26–latest
Edge 13, 18 and latest
Firefox 11–latest
Internet Explorer 9–11
Node.js 8–latest LTS
Safari 8–latest
In addition:

We have recent confirmation that the library is compatible with Adobe ExtendScript.
There is support code present for IE 8, which we will retain in future Underscore 1.x updates.
Patches to enhance support for other ES3-compatible environments are always welcome.
Underscore 2.x will likely remove support for some outdated environments.

Collection Functions (Arrays or Objects)
each_.each(list, iteratee, [context]) Alias: forEach source
Iterates over a list of elements, yielding each in turn to an iteratee function. The iteratee is bound to the context object, if one is passed. Each invocation of iteratee is called with three arguments: (element, index, list). If list is a JavaScript object, iteratee's arguments will be (value, key, list). Returns the list for chaining.

_.each([1, 2, 3], alert);
=> alerts each number in turn...
_.each({one: 1, two: 2, three: 3}, alert);
=> alerts each number value in turn...
Note: Collection functions work on arrays, objects, and array-like objects such as arguments, NodeList and similar. But it works by duck-typing, so avoid passing objects with a numeric length property. It's also good to note that an each loop cannot be broken out of — to break, use _.find instead.

map_.map(list, iteratee, [context]) Alias: collect source
Produces a new array of values by mapping each value in list through a transformation function (iteratee). The iteratee is passed three arguments: the value, then the index (or key) of the iteration, and finally a reference to the entire list.

_.map([1, 2, 3], function(num){ return num * 3; });
=> [3, 6, 9]
_.map({one: 1, two: 2, three: 3}, function(num, key){ return num * 3; });
=> [3, 6, 9]
_.map([[1, 2], [3, 4]], _.first);
=> [1, 3]
reduce_.reduce(list, iteratee, [memo], [context]) Aliases: inject, foldl source
Also known as inject and foldl, reduce boils down a list of values into a single value. Memo is the initial state of the reduction, and each successive step of it should be returned by iteratee. The iteratee is passed four arguments: the memo, then the value and index (or key) of the iteration, and finally a reference to the entire list.

If no memo is passed to the initial invocation of reduce, the iteratee is not invoked on the first element of the list. The first element is instead passed as the memo in the invocation of the iteratee on the next element in the list.

var sum = _.reduce([1, 2, 3], function(memo, num){ return memo + num; }, 0);
=> 6
reduceRight_.reduceRight(list, iteratee, [memo], [context]) Alias: foldr source
The right-associative version of reduce. Foldr is not as useful in JavaScript as it would be in a language with lazy evaluation.

var list = [[0, 1], [2, 3], [4, 5]];
var flat = _.reduceRight(list, function(a, b) { return a.concat(b); }, []);
=> [4, 5, 2, 3, 0, 1]
find_.find(list, predicate, [context]) Alias: detect source
Looks through each value in the list, returning the first one that passes a truth test (predicate), or undefined if no value passes the test. The function returns as soon as it finds an acceptable element, and doesn't traverse the entire list. predicate is transformed through iteratee to facilitate shorthand syntaxes.

var even = _.find([1, 2, 3, 4, 5, 6], function(num){ return num % 2 == 0; });
=> 2
filter_.filter(list, predicate, [context]) Alias: select source
Looks through each value in the list, returning an array of all the values that pass a truth test (predicate). predicate is transformed through iteratee to facilitate shorthand syntaxes.

var evens = _.filter([1, 2, 3, 4, 5, 6], function(num){ return num % 2 == 0; });
=> [2, 4, 6]
findWhere_.findWhere(list, properties) source
Looks through the list and returns the first value that matches all of the key-value pairs listed in properties.

If no match is found, or if list is empty, undefined will be returned.

_.findWhere(publicServicePulitzers, {newsroom: "The New York Times"});
=> {year: 1918, newsroom: "The New York Times",
  reason: "For its public service in publishing in full so many official reports,
  documents and speeches by European statesmen relating to the progress and
  conduct of the war."}
where_.where(list, properties) source
Looks through each value in the list, returning an array of all the values that matches the key-value pairs listed in properties.

_.where(listOfPlays, {author: "Shakespeare", year: 1611});
=> [{title: "Cymbeline", author: "Shakespeare", year: 1611},
    {title: "The Tempest", author: "Shakespeare", year: 1611}]
reject_.reject(list, predicate, [context]) source
Returns the values in list without the elements that the truth test (predicate) passes. The opposite of filter. predicate is transformed through iteratee to facilitate shorthand syntaxes.

var odds = _.reject([1, 2, 3, 4, 5, 6], function(num){ return num % 2 == 0; });
=> [1, 3, 5]
every_.every(list, [predicate], [context]) Alias: all source
Returns true if all of the values in the list pass the predicate truth test. Short-circuits and stops traversing the list if a false element is found. predicate is transformed through iteratee to facilitate shorthand syntaxes.

_.every([2, 4, 5], function(num) { return num % 2 == 0; });
=> false
some_.some(list, [predicate], [context]) Alias: any source
Returns true if any of the values in the list pass the predicate truth test. Short-circuits and stops traversing the list if a true element is found. predicate is transformed through iteratee to facilitate shorthand syntaxes.

_.some([null, 0, 'yes', false]);
=> true
contains_.contains(list, value, [fromIndex]) Aliases: include, includes source
Returns true if the value is present in the list. Uses indexOf internally, if list is an Array. Use fromIndex to start your search at a given index.

_.contains([1, 2, 3], 3);
=> true
invoke_.invoke(list, methodName, *arguments) source
Calls the method named by methodName on each value in the list. Any extra arguments passed to invoke will be forwarded on to the method invocation.

_.invoke([[5, 1, 7], [3, 2, 1]], 'sort');
=> [[1, 5, 7], [1, 2, 3]]
pluck_.pluck(list, propertyName) source
A convenient version of what is perhaps the most common use-case for map: extracting a list of property values.

var stooges = [{name: 'moe', age: 40}, {name: 'larry', age: 50}, {name: 'curly', age: 60}];
_.pluck(stooges, 'name');
=> ["moe", "larry", "curly"]
max_.max(list, [iteratee], [context]) source
Returns the maximum value in list. If an iteratee function is provided, it will be used on each value to generate the criterion by which the value is ranked. -Infinity is returned if list is empty, so an isEmpty guard may be required. This function can currently only compare numbers reliably. This function uses operator < (note).

var stooges = [{name: 'moe', age: 40}, {name: 'larry', age: 50}, {name: 'curly', age: 60}];
_.max(stooges, function(stooge){ return stooge.age; });
=> {name: 'curly', age: 60};
min_.min(list, [iteratee], [context]) source
Returns the minimum value in list. If an iteratee function is provided, it will be used on each value to generate the criterion by which the value is ranked. Infinity is returned if list is empty, so an isEmpty guard may be required. This function can currently only compare numbers reliably. This function uses operator < (note).

var numbers = [10, 5, 100, 2, 1000];
_.min(numbers);
=> 2
sortBy_.sortBy(list, iteratee, [context]) source
Returns a (stably) sorted copy of list, ranked in ascending order by the results of running each value through iteratee. iteratee may also be the string name of the property to sort by (eg. length). This function uses operator < (note).

_.sortBy([1, 2, 3, 4, 5, 6], function(num){ return Math.sin(num); });
=> [5, 4, 6, 3, 1, 2]

var stooges = [{name: 'moe', age: 40}, {name: 'larry', age: 50}, {name: 'curly', age: 60}];
_.sortBy(stooges, 'name');
=> [{name: 'curly', age: 60}, {name: 'larry', age: 50}, {name: 'moe', age: 40}];
groupBy_.groupBy(list, iteratee, [context]) source
Splits a collection into sets, grouped by the result of running each value through iteratee. If iteratee is a string instead of a function, groups by the property named by iteratee on each of the values.

_.groupBy([1.3, 2.1, 2.4], function(num){ return Math.floor(num); });
=> {1: [1.3], 2: [2.1, 2.4]}

_.groupBy(['one', 'two', 'three'], 'length');
=> {3: ["one", "two"], 5: ["three"]}
indexBy_.indexBy(list, iteratee, [context]) source
Given a list, and an iteratee function that returns a key for each element in the list (or a property name), returns an object with an index of each item. Just like groupBy, but for when you know your keys are unique.

var stooges = [{name: 'moe', age: 40}, {name: 'larry', age: 50}, {name: 'curly', age: 60}];
_.indexBy(stooges, 'age');
=> {
  "40": {name: 'moe', age: 40},
  "50": {name: 'larry', age: 50},
  "60": {name: 'curly', age: 60}
}
countBy_.countBy(list, iteratee, [context]) source
Sorts a list into groups and returns a count for the number of objects in each group. Similar to groupBy, but instead of returning a list of values, returns a count for the number of values in that group.

_.countBy([1, 2, 3, 4, 5], function(num) {
  return num % 2 == 0 ? 'even': 'odd';
});
=> {odd: 3, even: 2}
shuffle_.shuffle(list) source
Returns a shuffled copy of the list, using a version of the Fisher-Yates shuffle.

_.shuffle([1, 2, 3, 4, 5, 6]);
=> [4, 1, 6, 3, 5, 2]
sample_.sample(list, [n]) source
Produce a random sample from the list. Pass a number to return n random elements from the list. Otherwise a single random item will be returned.

_.sample([1, 2, 3, 4, 5, 6]);
=> 4

_.sample([1, 2, 3, 4, 5, 6], 3);
=> [1, 6, 2]
toArray_.toArray(list) source
Creates a real Array from the list (anything that can be iterated over). Useful for transmuting the arguments object.

(function(){ return _.toArray(arguments).slice(1); })(1, 2, 3, 4);
=> [2, 3, 4]
size_.size(list) source
Return the number of values in the list.

_.size([1, 2, 3, 4, 5]);
=> 5

_.size({one: 1, two: 2, three: 3});
=> 3
partition_.partition(list, predicate) source
Split list into two arrays: one whose elements all satisfy predicate and one whose elements all do not satisfy predicate. predicate is transformed through iteratee to facilitate shorthand syntaxes.

_.partition([0, 1, 2, 3, 4, 5], isOdd);
=> [[1, 3, 5], [0, 2, 4]]
compact_.compact(list) source
Returns a copy of the list with all falsy values removed. In JavaScript, false, null, 0, "", undefined and NaN are all falsy.

_.compact([0, 1, false, 2, '', 3]);
=> [1, 2, 3]
Array Functions
Note: All array functions will also work on the arguments object. However, Underscore functions are not designed to work on "sparse" arrays.

first_.first(array, [n]) Aliases: head, take source
Returns the first element of an array. Passing n will return the first n elements of the array.

_.first([5, 4, 3, 2, 1]);
=> 5
initial_.initial(array, [n]) source
Returns everything but the last entry of the array. Especially useful on the arguments object. Pass n to exclude the last n elements from the result.

_.initial([5, 4, 3, 2, 1]);
=> [5, 4, 3, 2]
last_.last(array, [n]) source
Returns the last element of an array. Passing n will return the last n elements of the array.

_.last([5, 4, 3, 2, 1]);
=> 1
rest_.rest(array, [index]) Aliases: tail, drop source
Returns the rest of the elements in an array. Pass an index to return the values of the array from that index onward.

_.rest([5, 4, 3, 2, 1]);
=> [4, 3, 2, 1]
flatten_.flatten(array, [depth]) source
Flattens a nested array. If you pass true or 1 as the depth, the array will only be flattened a single level. Passing a greater number will cause the flattening to descend deeper into the nesting hierarchy. Omitting the depth argument, or passing false or Infinity, flattens the array all the way to the deepest nesting level.

_.flatten([1, [2], [3, [[4]]]]);
=> [1, 2, 3, 4];

_.flatten([1, [2], [3, [[4]]]], true);
=> [1, 2, 3, [[4]]];

_.flatten([1, [2], [3, [[4]]]], 2);
=> [1, 2, 3, [4]];
without_.without(array, *values) source
Returns a copy of the array with all instances of the values removed.

_.without([1, 2, 1, 0, 3, 1, 4], 0, 1);
=> [2, 3, 4]
union_.union(*arrays) source
Computes the union of the passed-in arrays: the list of unique items, in order, that are present in one or more of the arrays.

_.union([1, 2, 3], [101, 2, 1, 10], [2, 1]);
=> [1, 2, 3, 101, 10]
intersection_.intersection(*arrays) source
Computes the list of values that are the intersection of all the arrays. Each value in the result is present in each of the arrays.

_.intersection([1, 2, 3], [101, 2, 1, 10], [2, 1]);
=> [1, 2]
difference_.difference(array, *others) source
Similar to without, but returns the values from array that are not present in the other arrays.

_.difference([1, 2, 3, 4, 5], [5, 2, 10]);
=> [1, 3, 4]
uniq_.uniq(array, [isSorted], [iteratee]) Alias: unique source
Produces a duplicate-free version of the array, using === to test object equality. In particular only the first occurrence of each value is kept. If you know in advance that the array is sorted, passing true for isSorted will run a much faster algorithm. If you want to compute unique items based on a transformation, pass an iteratee function.

_.uniq([1, 2, 1, 4, 1, 3]);
=> [1, 2, 4, 3]
zip_.zip(*arrays) source
Merges together the values of each of the arrays with the values at the corresponding position. Useful when you have separate data sources that are coordinated through matching array indexes.

_.zip(['moe', 'larry', 'curly'], [30, 40, 50], [true, false, false]);
=> [["moe", 30, true], ["larry", 40, false], ["curly", 50, false]]

unzip_.unzip(array) Alias: transpose source
The opposite of zip. Given an array of arrays, returns a series of new arrays, the first of which contains all of the first elements in the input arrays, the second of which contains all of the second elements, and so on. If you're working with a matrix of nested arrays, this can be used to transpose the matrix.

_.unzip([["moe", 30, true], ["larry", 40, false], ["curly", 50, false]]);
=> [['moe', 'larry', 'curly'], [30, 40, 50], [true, false, false]]
object_.object(list, [values]) source
Converts arrays into objects. Pass either a single list of [key, value] pairs, or a list of keys, and a list of values. Passing by pairs is the reverse of pairs. If duplicate keys exist, the last value wins.

_.object(['moe', 'larry', 'curly'], [30, 40, 50]);
=> {moe: 30, larry: 40, curly: 50}

_.object([['moe', 30], ['larry', 40], ['curly', 50]]);
=> {moe: 30, larry: 40, curly: 50}
chunk_.chunk(array, length) source
Chunks an array into multiple arrays, each containing length or fewer items.

var partners = _.chunk(_.shuffle(kindergarten), 2);
=> [["Tyrone", "Elie"], ["Aidan", "Sam"], ["Katrina", "Billie"], ["Little Timmy"]]
indexOf_.indexOf(array, value, [isSorted]) source
Returns the index at which value can be found in the array, or -1 if value is not present in the array. If you're working with a large array, and you know that the array is already sorted, pass true for isSorted to use a faster binary search ... or, pass a number as the third argument in order to look for the first matching value in the array after the given index. If isSorted is true, this function uses operator < (note).

_.indexOf([1, 2, 3], 2);
=> 1
lastIndexOf_.lastIndexOf(array, value, [fromIndex]) source
Returns the index of the last occurrence of value in the array, or -1 if value is not present. Pass fromIndex to start your search at a given index.

_.lastIndexOf([1, 2, 3, 1, 2, 3], 2);
=> 4
sortedIndex_.sortedIndex(array, value, [iteratee], [context]) source
Uses a binary search to determine the smallest index at which the value should be inserted into the array in order to maintain the array's sorted order. If an iteratee function is provided, it will be used to compute the sort ranking of each value, including the value you pass. The iteratee may also be the string name of the property to sort by (eg. length). This function uses operator < (note).

_.sortedIndex([10, 20, 30, 40, 50], 35);
=> 3

var stooges = [{name: 'moe', age: 40}, {name: 'curly', age: 60}];
_.sortedIndex(stooges, {name: 'larry', age: 50}, 'age');
=> 1
findIndex_.findIndex(array, predicate, [context]) source
Similar to _.indexOf, returns the first index where the predicate truth test passes; otherwise returns -1.

_.findIndex([4, 6, 8, 12], isPrime);
=> -1 // not found
_.findIndex([4, 6, 7, 12], isPrime);
=> 2
findLastIndex_.findLastIndex(array, predicate, [context]) source
Like _.findIndex but iterates the array in reverse, returning the index closest to the end where the predicate truth test passes.

var users = [{'id': 1, 'name': 'Bob', 'last': 'Brown'},
             {'id': 2, 'name': 'Ted', 'last': 'White'},
             {'id': 3, 'name': 'Frank', 'last': 'James'},
             {'id': 4, 'name': 'Ted', 'last': 'Jones'}];
_.findLastIndex(users, {
  name: 'Ted'
});
=> 3
range_.range([start], stop, [step]) source
A function to create flexibly-numbered lists of integers, handy for each and map loops. start, if omitted, defaults to 0; step defaults to 1 if start is before stop, otherwise -1. Returns a list of integers from start (inclusive) to stop (exclusive), incremented (or decremented) by step.

_.range(10);
=> [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
_.range(1, 11);
=> [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
_.range(0, 30, 5);
=> [0, 5, 10, 15, 20, 25]
_.range(0, -10, -1);
=> [0, -1, -2, -3, -4, -5, -6, -7, -8, -9]
_.range(0);
=> []
Function (uh, ahem) Functions
bind_.bind(function, object, *arguments) source
Bind a function to an object, meaning that whenever the function is called, the value of this will be the object. Optionally, pass arguments to the function to pre-fill them, also known as partial application. For partial application without context binding, use partial.

var func = function(greeting){ return greeting + ': ' + this.name };
func = _.bind(func, {name: 'moe'}, 'hi');
func();
=> 'hi: moe'
bindAll_.bindAll(object, *methodNames) source
Binds a number of methods on the object, specified by methodNames, to be run in the context of that object whenever they are invoked. Very handy for binding functions that are going to be used as event handlers, which would otherwise be invoked with a fairly useless this. methodNames are required.

var buttonView = {
  label  : 'underscore',
  onClick: function(){ alert('clicked: ' + this.label); },
  onHover: function(){ console.log('hovering: ' + this.label); }
};
_.bindAll(buttonView, 'onClick', 'onHover');
// When the button is clicked, this.label will have the correct value.
jQuery('#underscore_button').on('click', buttonView.onClick);
partial_.partial(function, *arguments) source
Partially apply a function by filling in any number of its arguments, without changing its dynamic this value. A close cousin of bind. You may pass _ in your list of arguments to specify an argument that should not be pre-filled, but left open to supply at call-time. Note: if you need _ placeholders and a this binding at the same time, use both _.partial and _.bind.

var subtract = function(a, b) { return b - a; };
sub5 = _.partial(subtract, 5);
sub5(20);
=> 15

// Using a placeholder
subFrom20 = _.partial(subtract, _, 20);
subFrom20(5);
=> 15
memoize_.memoize(function, [hashFunction]) source
Memoizes a given function by caching the computed result. Useful for speeding up slow-running computations. If passed an optional hashFunction, it will be used to compute the hash key for storing the result, based on the arguments to the original function. The default hashFunction just uses the first argument to the memoized function as the key. The cache of memoized values is available as the cache property on the returned function.

var fibonacci = _.memoize(function(n) {
  return n < 2 ? n: fibonacci(n - 1) + fibonacci(n - 2);
});
delay_.delay(function, wait, *arguments) source
Much like setTimeout, invokes function after wait milliseconds. If you pass the optional arguments, they will be forwarded on to the function when it is invoked.

var log = _.bind(console.log, console);
_.delay(log, 1000, 'logged later');
=> 'logged later' // Appears after one second.
defer_.defer(function, *arguments) source
Defers invoking the function until the current call stack has cleared, similar to using setTimeout with a delay of 0. Useful for performing expensive computations or HTML rendering in chunks without blocking the UI thread from updating. If you pass the optional arguments, they will be forwarded on to the function when it is invoked.

_.defer(function(){ alert('deferred'); });
// Returns from the function before the alert runs.
throttle_.throttle(function, wait, [options]) source
Creates and returns a new, throttled version of the passed function, that, when invoked repeatedly, will only actually call the original function at most once per every wait milliseconds. Useful for rate-limiting events that occur faster than you can keep up with.

By default, throttle will execute the function as soon as you call it for the first time, and, if you call it again any number of times during the wait period, as soon as that period is over. If you'd like to disable the leading-edge call, pass {leading: false}, and if you'd like to disable the execution on the trailing-edge, pass
{trailing: false}.

var throttled = _.throttle(updatePosition, 100);
$(window).scroll(throttled);
If you need to cancel a scheduled throttle, you can call .cancel() on the throttled function.

debounce_.debounce(function, wait, [immediate]) source
Creates and returns a new debounced version of the passed function which will postpone its execution until after wait milliseconds have elapsed since the last time it was invoked. Useful for implementing behavior that should only happen after the input has stopped arriving. For example: rendering a preview of a Markdown comment, recalculating a layout after the window has stopped being resized, and so on.

At the end of the wait interval, the function will be called with the arguments that were passed most recently to the debounced function.

Pass true for the immediate argument to cause debounce to trigger the function on the leading instead of the trailing edge of the wait interval. Useful in circumstances like preventing accidental double-clicks on a "submit" button from firing a second time.

var lazyLayout = _.debounce(calculateLayout, 300);
$(window).resize(lazyLayout);
If you need to cancel a scheduled debounce, you can call .cancel() on the debounced function.

once_.once(function) source
Creates a version of the function that can only be called one time. Repeated calls to the modified function will have no effect, returning the value from the original call. Useful for initialization functions, instead of having to set a boolean flag and then check it later.

var initialize = _.once(createApplication);
initialize();
initialize();
// Application is only created once.
after_.after(count, function) source
Creates a wrapper of function that does nothing at first. From the count-th call onwards, it starts actually calling function. Useful for grouping asynchronous responses, where you want to be sure that all the async calls have finished, before proceeding.

var renderNotes = _.after(notes.length, render);
_.each(notes, function(note) {
  note.asyncSave({success: renderNotes});
});
// renderNotes is run once, after all notes have saved.
before_.before(count, function) source
Creates a wrapper of function that memoizes its return value. From the count-th call onwards, the memoized result of the last invocation is returned immediately instead of invoking function again. So the wrapper will invoke function at most count - 1 times.

var monthlyMeeting = _.before(3, askForRaise);
monthlyMeeting();
monthlyMeeting();
monthlyMeeting();
// the result of any subsequent calls is the same as the second call
wrap_.wrap(function, wrapper) source
Wraps the first function inside of the wrapper function, passing it as the first argument. This allows the wrapper to execute code before and after the function runs, adjust the arguments, and execute it conditionally.

var hello = function(name) { return "hello: " + name; };
hello = _.wrap(hello, function(func) {
  return "before, " + func("moe") + ", after";
});
hello();
=> 'before, hello: moe, after'
negate_.negate(predicate) source
Returns a new negated version of the predicate function.

var isFalsy = _.negate(Boolean);
_.find([-2, -1, 0, 1, 2], isFalsy);
=> 0
compose_.compose(*functions) source
Returns the composition of a list of functions, where each function consumes the return value of the function that follows. In math terms, composing the functions f(), g(), and h() produces f(g(h())).

var greet    = function(name){ return "hi: " + name; };
var exclaim  = function(statement){ return statement.toUpperCase() + "!"; };
var welcome = _.compose(greet, exclaim);
welcome('moe');
=> 'hi: MOE!'
restArguments_.restArguments(function, [startIndex]) source
Returns a version of the function that, when called, receives all arguments from and beyond startIndex collected into a single array. If you don’t pass an explicit startIndex, it will be determined by looking at the number of arguments to the function itself. Similar to ES6’s rest parameters syntax.

var raceResults = _.restArguments(function(gold, silver, bronze, everyoneElse) {
  _.each(everyoneElse, sendConsolations);
});

raceResults("Dopey", "Grumpy", "Happy", "Sneezy", "Bashful", "Sleepy", "Doc");
Object Functions
keys_.keys(object) source
Retrieve all the names of the object's own enumerable properties.

_.keys({one: 1, two: 2, three: 3});
=> ["one", "two", "three"]
allKeys_.allKeys(object) source
Retrieve all the names of object's own and inherited properties.

function Stooge(name) {
  this.name = name;
}
Stooge.prototype.silly = true;
_.allKeys(new Stooge("Moe"));
=> ["name", "silly"]
values_.values(object) source
Return all of the values of the object's own properties.

_.values({one: 1, two: 2, three: 3});
=> [1, 2, 3]
mapObject_.mapObject(object, iteratee, [context]) source
Like map, but for objects. Transform the value of each property in turn.

_.mapObject({start: 5, end: 12}, function(val, key) {
  return val + 5;
});
=> {start: 10, end: 17}
pairs_.pairs(object) source
Convert an object into a list of [key, value] pairs. The opposite of object.

_.pairs({one: 1, two: 2, three: 3});
=> [["one", 1], ["two", 2], ["three", 3]]
invert_.invert(object) source
Returns a copy of the object where the keys have become the values and the values the keys. For this to work, all of your object's values should be unique and string serializable.

_.invert({Moe: "Moses", Larry: "Louis", Curly: "Jerome"});
=> {Moses: "Moe", Louis: "Larry", Jerome: "Curly"};
create_.create(prototype, props) source
Creates a new object with the given prototype, optionally attaching props as own properties. Basically, Object.create, but without all of the property descriptor jazz.

var moe = _.create(Stooge.prototype, {name: "Moe"});
functions_.functions(object) Alias: methods source
Returns a sorted list of the names of every method in an object — that is to say, the name of every function property of the object.

_.functions(_);
=> ["all", "any", "bind", "bindAll", "clone", "compact", "compose" ...
findKey_.findKey(object, predicate, [context]) source
Similar to _.findIndex but for keys in objects. Returns the key where the predicate truth test passes or undefined. predicate is transformed through iteratee to facilitate shorthand syntaxes.

extend_.extend(destination, *sources) source
Shallowly copy all of the properties in the source objects over to the destination object, and return the destination object. Any nested objects or arrays will be copied by reference, not duplicated. It's in-order, so the last source will override properties of the same name in previous arguments.

_.extend({name: 'moe'}, {age: 50});
=> {name: 'moe', age: 50}
extendOwn_.extendOwn(destination, *sources) Alias: assign source
Like extend, but only copies own properties over to the destination object.

pick_.pick(object, *keys) source
Return a copy of the object, filtered to only have values for the allowed keys (or array of valid keys). Alternatively accepts a predicate indicating which keys to pick.

_.pick({name: 'moe', age: 50, userid: 'moe1'}, 'name', 'age');
=> {name: 'moe', age: 50}
_.pick({name: 'moe', age: 50, userid: 'moe1'}, function(value, key, object) {
  return _.isNumber(value);
});
=> {age: 50}
omit_.omit(object, *keys) source
Return a copy of the object, filtered to omit the disallowed keys (or array of keys). Alternatively accepts a predicate indicating which keys to omit.

_.omit({name: 'moe', age: 50, userid: 'moe1'}, 'userid');
=> {name: 'moe', age: 50}
_.omit({name: 'moe', age: 50, userid: 'moe1'}, function(value, key, object) {
  return _.isNumber(value);
});
=> {name: 'moe', userid: 'moe1'}
defaults_.defaults(object, *defaults) source
Returns object after filling in its undefined properties with the first value present in the following list of defaults objects.

var iceCream = {flavor: "chocolate"};
_.defaults(iceCream, {flavor: "vanilla", sprinkles: "lots"});
=> {flavor: "chocolate", sprinkles: "lots"}
clone_.clone(object) source
Create a shallow-copied clone of the provided plain object. Any nested objects or arrays will be copied by reference, not duplicated.

_.clone({name: 'moe'});
=> {name: 'moe'};
tap_.tap(object, interceptor) source
Invokes interceptor with the object, and then returns object. The primary purpose of this method is to "tap into" a method chain, in order to perform operations on intermediate results within the chain.

_.chain([1,2,3,200])
  .filter(function(num) { return num % 2 == 0; })
  .tap(alert)
  .map(function(num) { return num * num })
  .value();
=> // [2, 200] (alerted)
=> [4, 40000]
toPath_.toPath(path) source
Ensures that path is an array. If path is a string, it is wrapped in a single-element array; if it is an array already, it is returned unmodified.

_.toPath('key');
=> ['key']
_.toPath(['a', 0, 'b']);
=> ['a', 0, 'b'] // (same array)
_.toPath is used internally in has, get, invoke, property, propertyOf and result, as well as in iteratee and all functions that depend on it, in order to normalize deep property paths. You can override _.toPath if you want to customize this behavior, for example to enable Lodash-like string path shorthands. Be advised that altering _.toPath will unavoidably cause some keys to become unreachable; override at your own risk.

// Support dotted path shorthands.
var originalToPath = _.toPath;
_.mixin({
  toPath: function(path) {
    return _.isString(path) ? path.split('.') : originalToPath(path);
  }
});
_.get({a: [{b: 5}]}, 'a.0.b');
=> 5
get_.get(object, path, [default]) source
Returns the specified property of object. path may be specified as a simple key, or as an array of object keys or array indexes, for deep property fetching. If the property does not exist or is undefined, the optional default is returned.

_.get({a: 10}, 'a');
=> 10
_.get({a: [{b: 2}]}, ['a', 0, 'b']);
=> 2
_.get({a: 10}, 'b', 100);
=> 100
has_.has(object, key) source
Does the object contain the given key? Identical to object.hasOwnProperty(key), but uses a safe reference to the hasOwnProperty function, in case it's been overridden accidentally.

_.has({a: 1, b: 2, c: 3}, "b");
=> true
property_.property(path) source
Returns a function that will return the specified property of any passed-in object. path may be specified as a simple key, or as an array of object keys or array indexes, for deep property fetching.

var stooge = {name: 'moe'};
'moe' === _.property('name')(stooge);
=> true

var stooges = {moe: {fears: {worst: 'Spiders'}}, curly: {fears: {worst: 'Moe'}}};
var curlysWorstFear = _.property(['curly', 'fears', 'worst']);
curlysWorstFear(stooges);
=> 'Moe'
propertyOf_.propertyOf(object) source
Inverse of _.property. Takes an object and returns a function which will return the value of a provided property.

var stooge = {name: 'moe'};
_.propertyOf(stooge)('name');
=> 'moe'
matcher_.matcher(attrs) Alias: matches source
Returns a predicate function that will tell you if a passed in object contains all of the key/value properties present in attrs.

var ready = _.matcher({selected: true, visible: true});
var readyToGoList = _.filter(list, ready);
isEqual_.isEqual(object, other) source
Performs an optimized deep comparison between the two objects, to determine if they should be considered equal.

var stooge = {name: 'moe', luckyNumbers: [13, 27, 34]};
var clone  = {name: 'moe', luckyNumbers: [13, 27, 34]};
stooge == clone;
=> false
_.isEqual(stooge, clone);
=> true
isMatch_.isMatch(object, properties) source
Tells you if the keys and values in properties are contained in object.

var stooge = {name: 'moe', age: 32};
_.isMatch(stooge, {age: 32});
=> true
isEmpty_.isEmpty(collection) source
Returns true if collection has no elements. For strings and array-like objects _.isEmpty checks if the length property is 0. For other objects, it returns true if the object has no enumerable own-properties. Note that primitive numbers, booleans and symbols are always empty by this definition.

_.isEmpty([1, 2, 3]);
=> false
_.isEmpty({});
=> true
isElement_.isElement(object) source
Returns true if object is a DOM element.

_.isElement(jQuery('body')[0]);
=> true
isArray_.isArray(object) source
Returns true if object is an Array.

(function(){ return _.isArray(arguments); })();
=> false
_.isArray([1,2,3]);
=> true
isObject_.isObject(value) source
Returns true if value is an Object. Note that JavaScript arrays and functions are objects, while (normal) strings and numbers are not.

_.isObject({});
=> true
_.isObject(1);
=> false
isArguments_.isArguments(object) source
Returns true if object is an Arguments object.

(function(){ return _.isArguments(arguments); })(1, 2, 3);
=> true
_.isArguments([1,2,3]);
=> false
isFunction_.isFunction(object) source
Returns true if object is a Function.

_.isFunction(alert);
=> true
isString_.isString(object) source
Returns true if object is a String.

_.isString("moe");
=> true
isNumber_.isNumber(object) source
Returns true if object is a Number (including NaN).

_.isNumber(8.4 * 5);
=> true
isFinite_.isFinite(object) source
Returns true if object is a finite Number.

_.isFinite(-101);
=> true

_.isFinite(-Infinity);
=> false
isBoolean_.isBoolean(object) source
Returns true if object is either true or false.

_.isBoolean(null);
=> false
isDate_.isDate(object) source
Returns true if object is a Date.

_.isDate(new Date());
=> true
isRegExp_.isRegExp(object) source
Returns true if object is a RegExp.

_.isRegExp(/moe/);
=> true
isError_.isError(object) source
Returns true if object inherits from an Error.

try {
  throw new TypeError("Example");
} catch (o_O) {
  _.isError(o_O);
}
=> true
isSymbol_.isSymbol(object) source
Returns true if object is a Symbol.

_.isSymbol(Symbol());
=> true
isMap_.isMap(object) source
Returns true if object is a Map.

_.isMap(new Map());
=> true
isWeakMap_.isWeakMap(object) source
Returns true if object is a WeakMap.

_.isWeakMap(new WeakMap());
=> true
isSet_.isSet(object) source
Returns true if object is a Set.

_.isSet(new Set());
=> true
isWeakSet_.isWeakSet(object) source
Returns true if object is a WeakSet.

_.isWeakSet(WeakSet());
=> true
isArrayBuffer_.isArrayBuffer(object) source
Returns true if object is an ArrayBuffer.

_.isArrayBuffer(new ArrayBuffer(8));
=> true
isDataView_.isDataView(object) source
Returns true if object is a DataView.

_.isDataView(new DataView(new ArrayBuffer(8)));
=> true
isTypedArray_.isTypedArray(object) source
Returns true if object is a TypedArray.

_.isTypedArray(new Int8Array(8));
=> true
isNaN_.isNaN(object) source
Returns true if object is NaN.
Note: this is not the same as the native isNaN function, which will also return true for many other not-number values, such as undefined.

_.isNaN(NaN);
=> true
isNaN(undefined);
=> true
_.isNaN(undefined);
=> false
isNull_.isNull(object) source
Returns true if the value of object is null.

_.isNull(null);
=> true
_.isNull(undefined);
=> false
isUndefined_.isUndefined(value) source
Returns true if value is undefined.

_.isUndefined(window.missingVariable);
=> true
Utility Functions
noConflict_.noConflict() source
Give control of the global _ variable back to its previous owner. Returns a reference to the Underscore object.

var underscore = _.noConflict();
The _.noConflict function is not present if you use the EcmaScript 6, AMD or CommonJS module system to import Underscore.

identity_.identity(value) source
Returns the same value that is used as the argument. In math: f(x) = x
This function looks useless, but is used throughout Underscore as a default iteratee.

var stooge = {name: 'moe'};
stooge === _.identity(stooge);
=> true
constant_.constant(value) source
Creates a function that returns the same value that is used as the argument of _.constant.

var stooge = {name: 'moe'};
stooge === _.constant(stooge)();
=> true
noop_.noop() source
Returns undefined irrespective of the arguments passed to it. Useful as the default for optional callback arguments.

obj.initialize = _.noop;
times_.times(n, iteratee, [context]) source
Invokes the given iteratee function n times. Each invocation of iteratee is called with an index argument. Produces an array of the returned values.

_.times(3, function(n){ genie.grantWishNumber(n); });
random_.random(min, max) source
Returns a random integer between min and max, inclusive. If you only pass one argument, it will return a number between 0 and that number.

_.random(0, 100);
=> 42
mixin_.mixin(object) source
Allows you to extend Underscore with your own utility functions. Pass a hash of {name: function} definitions to have your functions added to the Underscore object, as well as the OOP wrapper. Returns the Underscore object to facilitate chaining.

_.mixin({
  capitalize: function(string) {
    return string.charAt(0).toUpperCase() + string.substring(1).toLowerCase();
  }
});
_("fabio").capitalize();
=> "Fabio"
iteratee_.iteratee(value, [context]) source
Generates a callback that can be applied to each element in a collection. _.iteratee supports a number of shorthand syntaxes for common callback use cases. Depending upon value's type, _.iteratee will return:

// No value
_.iteratee();
=> _.identity()

// Function
_.iteratee(function(n) { return n * 2; });
=> function(n) { return n * 2; }

// Object
_.iteratee({firstName: 'Chelsea'});
=> _.matcher({firstName: 'Chelsea'});

// Anything else
_.iteratee('firstName');
=> _.property('firstName');
The following Underscore methods transform their predicates through _.iteratee: countBy, every, filter, find, findIndex, findKey, findLastIndex, groupBy, indexBy, map, mapObject, max, min, partition, reject, some, sortBy, sortedIndex, and uniq

You may overwrite _.iteratee with your own custom function, if you want additional or different shorthand syntaxes:

// Support `RegExp` predicate shorthand.
var builtinIteratee = _.iteratee;
_.iteratee = function(value, context) {
  if (_.isRegExp(value)) return function(obj) { return value.test(obj) };
  return builtinIteratee(value, context);
};
uniqueId_.uniqueId([prefix]) source
Generate a globally-unique id for client-side models or DOM elements that need one. If prefix is passed, the id will be appended to it.

_.uniqueId('contact_');
=> 'contact_104'
escape_.escape(string) source
Escapes a string for insertion into HTML, replacing &, <, >, ", `, and ' characters.

_.escape('Curly, Larry & Moe');
=> "Curly, Larry &amp; Moe"
unescape_.unescape(string) source
The opposite of escape, replaces &amp;, &lt;, &gt;, &quot;, &#x60; and &#x27; with their unescaped counterparts.

_.unescape('Curly, Larry &amp; Moe');
=> "Curly, Larry & Moe"
result_.result(object, property, [defaultValue]) source
If the value of the named property is a function then invoke it with the object as context; otherwise, return it. If a default value is provided and the property doesn't exist or is undefined then the default will be returned. If defaultValue is a function its result will be returned.

var object = {cheese: 'crumpets', stuff: function(){ return 'nonsense'; }};
_.result(object, 'cheese');
=> "crumpets"
_.result(object, 'stuff');
=> "nonsense"
_.result(object, 'meat', 'ham');
=> "ham"
now_.now() source
Returns an integer timestamp for the current time, using the fastest method available in the runtime. Useful for implementing timing/animation functions.

_.now();
=> 1392066795351
template_.template(templateString, [settings]) source
Compiles JavaScript templates into functions that can be evaluated for rendering. Useful for rendering complicated bits of HTML from JSON data sources. Template functions can both interpolate values, using <%= … %>, as well as execute arbitrary JavaScript code, with <% … %>. If you wish to interpolate a value, and have it be HTML-escaped, use <%- … %>. When you evaluate a template function, pass in a data object that has properties corresponding to the template's free variables. The settings argument should be a hash containing any _.templateSettings that should be overridden.

var compiled = _.template("hello: <%= name %>");
compiled({name: 'moe'});
=> "hello: moe"

var templateText = _.template("<b><%- value %></b>");
template({value: '<script>'});
=> "<b>&lt;script&gt;</b>"
You can also use print from within JavaScript code. This is sometimes more convenient than using <%= ... %>.

var compiled = _.template("<% print('Hello ' + epithet); %>");
compiled({epithet: "stooge"});
=> "Hello stooge"
If ERB-style delimiters aren't your cup of tea, you can change Underscore's template settings to use different symbols to set off interpolated code. Define an interpolate regex to match expressions that should be interpolated verbatim, an escape regex to match expressions that should be inserted after being HTML-escaped, and an evaluate regex to match expressions that should be evaluated without insertion into the resulting string. Note that if part of your template matches more than one of these regexes, the first will be applied by the following order of priority: (1) escape, (2) interpolate, (3) evaluate. You may define or omit any combination of the three. For example, to perform Mustache.js-style templating:

_.templateSettings = {
  interpolate: /\{\{(.+?)\}\}/g
};

var templateText = _.template("Hello {{ name }}!");
template({name: "Mustache"});
=> "Hello Mustache!"
By default, template places the values from your data in the local scope via the with statement. However, you can specify a single variable name with the variable setting. This can significantly improve the speed at which a template is able to render.

_.template("Using 'with': <%= data.answer %>", {variable: 'data'})({answer: 'no'});
=> "Using 'with': no"
Precompiling your templates can be a big help when debugging errors you can't reproduce. This is because precompiled templates can provide line numbers and a stack trace, something that is not possible when compiling templates on the client. The source property is available on the compiled template function for easy precompilation.

<script>
  JST.project = <%= _.template(jstText).source %>;
</script>
Object-Oriented Style
You can use Underscore in either an object-oriented or a functional style, depending on your preference. The following two lines of code are identical ways to double a list of numbers. source, source

_.map([1, 2, 3], function(n){ return n * 2; });
_([1, 2, 3]).map(function(n){ return n * 2; });
Chaining
Calling chain will cause all future method calls to return wrapped objects. When you've finished the computation, call value to retrieve the final value. Here's an example of chaining together a map/flatten/reduce, in order to get the word count of every word in a song.

var lyrics = [
  {line: 1, words: "I'm a lumberjack and I'm okay"},
  {line: 2, words: "I sleep all night and I work all day"},
  {line: 3, words: "He's a lumberjack and he's okay"},
  {line: 4, words: "He sleeps all night and he works all day"}
];

_.chain(lyrics)
  .map(function(line) { return line.words.split(' '); })
  .flatten()
  .reduce(function(counts, word) {
    counts[word] = (counts[word] || 0) + 1;
    return counts;
  }, {})
  .value();

=> {lumberjack: 2, all: 4, night: 2 ... }
In addition, the Array prototype's methods are proxied through the chained Underscore object, so you can slip a reverse or a push into your chain, and continue to modify the array.

chain_.chain(obj) source
Returns a wrapped object. Calling methods on this object will continue to return wrapped objects until value is called.

var stooges = [{name: 'curly', age: 25}, {name: 'moe', age: 21}, {name: 'larry', age: 23}];
var youngest = _.chain(stooges)
  .sortBy(function(stooge){ return stooge.age; })
  .map(function(stooge){ return stooge.name + ' is ' + stooge.age; })
  .first()
  .value();
=> "moe is 21"
value_.chain(obj).value() source
Extracts the value of a wrapped object.

_.chain([1, 2, 3]).reverse().value();
=> [3, 2, 1]
Links & Suggested Reading
Underscore.lua, a Lua port of the functions that are applicable in both languages. Includes OOP-wrapping and chaining. (source)

Dollar.swift, a Swift port of many of the Underscore.js functions and more. (source)

Underscore.m, an Objective-C port of many of the Underscore.js functions, using a syntax that encourages chaining. (source)

_.m, an alternative Objective-C port that tries to stick a little closer to the original Underscore.js API. (source)

Underscore.php, a PHP port of the functions that are applicable in both languages. Tailored for PHP 5.4 and made with data-type tolerance in mind. (source)

Underscore-perl, a Perl port of many of the Underscore.js functions, aimed at on Perl hashes and arrays. (source)

Underscore.cfc, a Coldfusion port of many of the Underscore.js functions. (source)

Underscore.string, an Underscore extension that adds functions for string-manipulation: trim, startsWith, contains, capitalize, reverse, sprintf, and more.

Underscore-java, a java port of the functions that are applicable in both languages. Includes OOP-wrapping and chaining. (source)

Ruby's Enumerable module.

Prototype.js, which provides JavaScript with collection functions in the manner closest to Ruby's Enumerable.

Oliver Steele's Functional JavaScript, which includes comprehensive higher-order function support as well as string lambdas.

Michael Aufreiter's Data.js, a data manipulation + persistence library for JavaScript.

Python's itertools.

PyToolz, a Python port that extends itertools and functools to include much of the Underscore API.

Funcy, a practical collection of functional helpers for Python, partially inspired by Underscore.

Notes
On the use of < in Underscore
Underscore functions that depend on ordering, such as _.sortBy and _.sortedIndex, use JavaScript’s built-in relational operators, specifically the “less than” operator <. It is important to understand that these operators are only meaningful for numbers and strings. You can throw any value to them, but JavaScript will convert the operands to string or number first before performing the actual comparison. If you pass an operand that cannot be meaningfully converted to string or number, it ends up being NaN by default. This value is unsortable.

Ideally, the values that you are sorting should either be all (meaningfully convertible to) strings or all (meaningfully convertible to) numbers. If this is not the case, you have two options:

_.filter out all unsortable values first.
Pick a target type, i.e., either string or number, and pass an iteratee to your Underscore function that will convert its argument to a sensible instance of the target type. For example, if you have an array of numbers that you want to sort and that may occasionally contain null or undefined, you can control whether you want to sort these before or after all numbers by passing an iteratee to _.sortBy that returns -Infinity or +Infinity for such values, respectively. Or maybe you want to treat them as zeros; it is up to you. The same iteratee can also be passed to other Underscore functions to ensure that the behavior is consistent.
Change Log
1.13.6 — September 24, 2022 — Diff — Docs
Hotfix for version 1.13.5 to remove a postinstall script from the package.json, which unexpectedly broke many people's builds.

1.13.5 — September 23, 2022 — Diff — Docs
Adds a module sub-entry to the package.json’s exports.require condition. When a bundling tool, such as Rollup with recent versions of @rollup/plugin-node-resolve, takes the exports map very literally, this should prevent situations in which the final bundle includes multiple copies of Underscore in different module formats.
Updates to the testing infrastructure and development dependencies.
No code changes.
1.13.4 — June 2, 2022 — Diff — Docs
Fixes a compatibility issue with WebPack module federation.
Documentation improvements.
1.13.3 — April 23, 2022 — Diff — Docs
Fixes a compatibility issue with ExtendScript.
Various improvements to testing and continuous integration, including the addition of security scanning and a reduced carbon footprint.
1.13.2 — December 16, 2021 — Diff — Docs
Fixes a regression introduced in 1.9.0 that caused _.sample and _.shuffle to no longer work on strings.
Fixes an issue in IE8 compatibility code.
Makes the website mobile-friendly.
Various other minor documentation enhancements and a new test.
1.13.1 — April 15, 2021 — Diff — Docs
Restores the underscore.js alias committed to the GitHub repository.
Adds some build clarifications to the documentation.
No code changes.
1.13.0 — April 9, 2021 — Diff — Docs
Merges the changes from the 1.13.0-0 through 1.13.0-3 preview releases into the main release stream following version 1.12.1. As of this release, ESM support is 100%.
Adds a security policy to the documentation.
Adds funding information to the documentation.
1.13.0-3 — March 31, 2021 — Diff — Docs
Adds a "module" exports condition to the package.json, which should theoretically help to avoid duplicate code bundling with exports-aware build tools.
Re-synchronizes some comments and documentation text with the 1.12.x branch.
1.13.0-2 — March 15, 2021 — Diff — Docs
Fixes the same security issue in _.template as the parallel 1.12.1 release.
1.12.1 — March 15, 2021 — Diff — Docs
Fixes a security issue in _.template that could enable a third party to inject code in compiled templates. This issue affects all versions of Underscore between 1.3.2 and 1.12.0, inclusive, as well as preview releases 1.13.0-0 and 1.13.0-1. The fix in this release is also included in the parallel preview release 1.13.0-2. CVE-2021-23358
Restores an optimization in _.debounce that was unintentionally lost in version 1.9.0 (same as in parallel preview release 1.13.0-0).
Various test and documentation enhancements (same as in parallel preview releases 1.13.0-0 and 1.13.0-1).
1.13.0-1 — March 11, 2021 — Diff — Docs
Fixes an issue that caused aliases to be absent among the named exports in the new native ESM entry point for Node.js 12+.
More test and documentation fixes and enhancements.
1.13.0-0 — March 9, 2021 — Diff — Docs
Adds experimental support for native ESM imports in Node.js. You can now also do named imports or even deep module imports directly from a Node.js process in Node.js version 12 and later. Monolithic imports are recommended for use in production. State (such as mixed-in functions) is shared between CommonJS and ESM consumers.
Renames the UMD bundle to underscore-umd.js for consistency with the other bundle names. An alias named underscore.js is retained for backwards compatibility.
Restores an optimization in _.debounce that was unintentionally lost in version 1.9.0.
Various test and documentation enhancements.
1.12.0 — November 24, 2020 — Diff — Docs
Adds the _.get and _.toPath functions. The latter can be overridden in order to customize the interpretation of deep property paths throughout Underscore. A future version of Underscore-contrib will be providing a ready-made function for this purpose; users will be able to opt in to string-based path shorthands such as 'a.0.b' and 'a[0]["b"]' by using that function from Underscore-contrib to override _.toPath.
Fixes a bug in _.isEqual that caused typed arrays to compare equal when viewing different segments of the same underlying ArrayBuffer.
Improves the compatibility of _.isEqual, _.isDataView, _.isMap, _.isWeakMap and _.isSet with some older browsers, especially IE 11.
Significantly enhances the performance of _.isEmpty and several members of the isType family of functions.
Speeds up _.isEqual comparison of typed arrays and DataViews with idential buffer, byteOffset and byteLength.
Restores cross-browser testing during continuous integration to its former glory and adds documentation about engine compatibility.
Slims down the development dependencies for testing.
1.11.0 — August 28, 2020 — Diff — Docs — Article
Puts the source of every function in a separate module, following up on the move to EcmaScript 6 export notation in version 1.10.0. AMD and CommonJS versions of the function modules are provided as well. This brings perfect treeshaking to all users and unlocks the possibility to create arbitrary custom Underscore builds without code size overhead. modules/index.js is still present and the UMD bundle is still recommended for most users.
Since the modularization obfuscates the diff, piecewise diffs are provided below.
Changes before modularization
Modularization itself
Changes after modularization
Adds a monolithic bundle in EcmaScript 6 module format, underscore-esm.js, as a modern alternative to the monolithic UMD bundle. Users who want to use ES module imports in the browser are advised to use this new bundle instead of modules/index.js, because underscore-esm.js provides the complete Underscore interface in a single download.
Adds a modular version of the annotated source, reflecting the full internal structure of the primary source code.
Adds _.isArrayBuffer, _.isDataView and _.isTypedArray functions, as well as support for the corresponding value types to _.isEqual.
Adds the option to flatten arrays to a specific depth: _.flatten(anArray, 3).
Adds _.transpose as an alias to _.unzip.
Fixes an inconsistency where Array.prototype methods on the Underscore wrapper would error when the wrapped value is null or undefined. These methods now perform a no-op on null values like the other Underscore functions.
Fixes a bug that caused _.first and _.last to return [] instead of undefined for empty arrays when used as an iteratee.
Fixes a regression introduced in version 1.9.0 that caused _.bindAll to return undefined instead of the bound object.
Restores continuous integration testing with Travis CI.
Replaces stigmatizing “whitelist”/“blacklist” terminology in comments and documentation by neutral “allowed”/“disallowed” terminology.
Various clarifications and minor enhancements and fixes to the documentation, source comments and a test.
1.10.2 — March 30, 2020 — Diff — Docs
Fixes a bug introduced with 1.10.0, while using the legacy Node.js require API: var _ = require("underscore")._
1.10.1 — March 30, 2020 — Diff — Docs
Fixed relative links among the ES Modules to include the file extension, for web browser support.
1.10.0 — March 30, 2020 — Diff — Docs
Reformats the source code to use EcmaScript 6 export notation. The underscore.js UMD bundle is now compiled from underlying source modules instead of being the source. From now on, Rollup users have the option to import from the underlying source module in order to enable treeshaking.
Explicitly states in the documentation, and verifies in the unittests, that _.sortedIndex(array, value) always returns the lower bound, i.e., the smallest index, at which value may be inserted in array.
Makes the notation of the _.max unittest consistent with other unittests.
Fixes a bug that would cause infinite recursion if an overridden implementation of _.iteratee attempted to fall back to the original implementation.
Restores compatibility with EcmaScript 3 and ExtendScript.
1.9.2 — Jan 6, 2020 — Diff — Docs
No code changes. Updated a test to help out CITGM.
1.9.1 — May 31, 2018 — Diff — Docs
Fixes edge-case regressions from 1.9.0, including certain forms of calling _.first and _.last on an empty array, and passing arrays as keys to _.countBy and _.groupBy.
1.9.0 — April 18, 2018 — Diff — Docs
Adds the _.restArguments function for variadic function handling.
Adds the _.chunk function for chunking up an array.
Adds a _.isSymbol, _.isMap, _.isWeakMap, _.isSet and _.isWeakSet functions.
_.throttle and _.debounce return functions that now have a .cancel() method, which can be used to cancel any scheduled calls.
_.property now accepts arrays of keys and indexes as path specifiers, for looking up a deep properties of a value.
_.range now accepts negative ranges to generate descending arrays.
Adds support for several environments including: WebWorkers, browserify and ES6 imports.
Removes the component.json as the Component package management system is discontinued.
The placeholder used for partial is now configurable by setting _.partial.placeholder.
_.bindAll now accepts arrays or arguments for keys.
Three years of performance improvements.
1.8.3 — April 2, 2015 — Diff — Docs
Adds an _.create method, as a slimmed down version of Object.create.
Works around an iOS bug that can improperly cause isArrayLike to be JIT-ed. Also fixes a bug when passing 0 to isArrayLike.
1.8.2 — Feb. 22, 2015 — Diff — Docs
Restores the previous old-Internet-Explorer edge cases changed in 1.8.1.
Adds a fromIndex argument to _.contains.
1.8.1 — Feb. 19, 2015 — Diff — Docs
Fixes/changes some old-Internet Explorer and related edge case behavior. Test your app with Underscore 1.8.1 in an old IE and let us know how it's doing...
1.8.0 — Feb. 19, 2015 — Diff — Docs
Added _.mapObject, which is similar to _.map, but just for the values in your object. (A real crowd pleaser.)
Added _.allKeys which returns all the enumerable property names on an object.
Reverted a 1.7.0 change where _.extend only copied "own" properties. Hopefully this will un-break you — if it breaks you again, I apologize.
Added _.extendOwn — a less-useful form of _.extend that only copies over "own" properties.
Added _.findIndex and _.findLastIndex functions, which nicely complement their twin-twins _.indexOf and _.lastIndexOf.
Added an _.isMatch predicate function that tells you if an object matches key-value properties. A kissing cousin of _.isEqual and _.matcher.
Added an _.isError function.
Restored the _.unzip function as the inverse of zip. Flip-flopping. I know.
_.result now takes an optional fallback value (or function that provides the fallback value).
Added the _.propertyOf function generator as a mirror-world version of _.property.
Deprecated _.matches. It's now known by a more harmonious name — _.matcher.
Various and diverse code simplifications, changes for improved cross-platform compatibility, and edge case bug fixes.
1.7.0 — August 26, 2014 — Diff — Docs
For consistency and speed across browsers, Underscore now ignores native array methods for forEach, map, reduce, reduceRight, filter, every, some, indexOf, and lastIndexOf. "Sparse" arrays are officially dead in Underscore.
Added _.iteratee to customize the iterators used by collection functions. Many Underscore methods will take a string argument for easier _.property-style lookups, an object for _.where-style filtering, or a function as a custom callback.
Added _.before as a counterpart to _.after.
Added _.negate to invert the truth value of a passed-in predicate.
Added _.noop as a handy empty placeholder function.
_.isEmpty now works with arguments objects.
_.has now guards against nullish objects.
_.omit can now take an iteratee function.
_.partition is now called with index and object.
_.matches creates a shallow clone of your object and only iterates over own properties.
Aligning better with the forthcoming ECMA6 Object.assign, _.extend only iterates over the object's own properties.
Falsy guards are no longer needed in _.extend and _.defaults—if the passed in argument isn't a JavaScript object it's just returned.
Fixed a few edge cases in _.max and _.min to handle arrays containing NaN (like strings or other objects) and Infinity and -Infinity.
Override base methods like each and some and they'll be used internally by other Underscore functions too.
The escape functions handle backticks (`), to deal with an IE ≤ 8 bug.
For consistency, _.union and _.difference now only work with arrays and not variadic args.
_.memoize exposes the cache of memoized values as a property on the returned function.
_.pick accepts iteratee and context arguments for a more advanced callback.
Underscore templates no longer accept an initial data object. _.template always returns a function now.
Optimizations and code cleanup aplenty.
1.6.0 — February 10, 2014 — Diff — Docs
Underscore now registers itself for AMD (Require.js), Bower and Component, as well as being a CommonJS module and a regular (Java)Script. An ugliness, but perhaps a necessary one.
Added _.partition, a way to split a collection into two lists of results — those that pass and those that fail a particular predicate.
Added _.property, for easy creation of iterators that pull specific properties from objects. Useful in conjunction with other Underscore collection functions.
Added _.matches, a function that will give you a predicate that can be used to tell if a given object matches a list of specified key/value properties.
Added _.constant, as a higher-order _.identity.
Added _.now, an optimized way to get a timestamp — used internally to speed up debounce and throttle.
The _.partial function may now be used to partially apply any of its arguments, by passing _ wherever you'd like a placeholder variable, to be filled-in later.
The _.each function now returns a reference to the list for chaining.
The _.keys function now returns an empty array for non-objects instead of throwing.
… and more miscellaneous refactoring.
1.5.2 — September 7, 2013 — Diff — Docs
Added an indexBy function, which fits in alongside its cousins, countBy and groupBy.
Added a sample function, for sampling random elements from arrays.
Some optimizations relating to functions that can be implemented in terms of _.keys (which includes, significantly, each on objects). Also for debounce in a tight loop.
The _.escape function no longer escapes '/'.
1.5.1 — July 8, 2013 — Diff — Docs
Removed unzip, as it's simply the application of zip to an array of arguments. Use _.zip.apply(_, list) to transpose instead.
1.5.0 — July 6, 2013 — Diff — Docs
Added a new unzip function, as the inverse of _.zip.
The throttle function now takes an options argument, allowing you to disable execution of the throttled function on either the leading or trailing edge.
A source map is now supplied for easier debugging of the minified production build of Underscore.
The defaults function now only overrides undefined values, not null ones.
Removed the ability to call _.bindAll with no method name arguments. It's pretty much always wiser to allow the names of the methods you'd like to bind.
Removed the ability to call _.after with an invocation count of zero. The minimum number of calls is (naturally) now 1.
1.4.4 — January 30, 2013 — Diff — Docs
Added _.findWhere, for finding the first element in a list that matches a particular set of keys and values.
Added _.partial, for partially applying a function without changing its dynamic reference to this.
Simplified bind by removing some edge cases involving constructor functions. In short: don't _.bind your constructors.
A minor optimization to invoke.
Fix bug in the minified version due to the minifier incorrectly optimizing-away isFunction.
1.4.3 — December 4, 2012 — Diff — Docs
Improved Underscore compatibility with Adobe's JS engine that can be used to script Illustrator, Photoshop, and friends.
Added a default _.identity iterator to countBy and groupBy.
The uniq function can now take array, iterator, context as the argument list.
The times function now returns the mapped array of iterator results.
Simplified and fixed bugs in throttle.
1.4.2 — October 6, 2012 — Diff — Docs
For backwards compatibility, returned to pre-1.4.0 behavior when passing null to iteration functions. They now become no-ops again.
1.4.1 — October 1, 2012 — Diff — Docs
Fixed a 1.4.0 regression in the lastIndexOf function.
1.4.0 — September 27, 2012 — Diff — Docs
Added a pairs function, for turning a JavaScript object into [key, value] pairs ... as well as an object function, for converting an array of [key, value] pairs into an object.
Added a countBy function, for counting the number of objects in a list that match a certain criteria.
Added an invert function, for performing a simple inversion of the keys and values in an object.
Added a where function, for easy cases of filtering a list for objects with specific values.
Added an omit function, for filtering an object to remove certain keys.
Added a random function, to return a random number in a given range.
_.debounce'd functions now return their last updated value, just like _.throttle'd functions do.
The sortBy function now runs a stable sort algorithm.
Added the optional fromIndex option to indexOf and lastIndexOf.
"Sparse" arrays are no longer supported in Underscore iteration functions. Use a for loop instead (or better yet, an object).
The min and max functions may now be called on very large arrays.
Interpolation in templates now represents null and undefined as the empty string.
Underscore iteration functions no longer accept null values as a no-op argument. You'll get an early error instead.
A number of edge-cases fixes and tweaks, which you can spot in the diff. Depending on how you're using Underscore, 1.4.0 may be more backwards-incompatible than usual — please test when you upgrade.
1.3.3 — April 10, 2012 — Diff — Docs
Many improvements to _.template, which now provides the source of the template function as a property, for potentially even more efficient pre-compilation on the server-side. You may now also set the variable option when creating a template, which will cause your passed-in data to be made available under the variable you named, instead of using a with statement — significantly improving the speed of rendering the template.
Added the pick function, which allows you to filter an object literal with a list of allowed property names.
Added the result function, for convenience when working with APIs that allow either functions or raw properties.
Added the isFinite function, because sometimes knowing that a value is a number just ain't quite enough.
The sortBy function may now also be passed the string name of a property to use as the sort order on each object.
Fixed uniq to work with sparse arrays.
The difference function now performs a shallow flatten instead of a deep one when computing array differences.
The debounce function now takes an immediate parameter, which will cause the callback to fire on the leading instead of the trailing edge.
1.3.1 — January 23, 2012 — Diff — Docs
Added an _.has function, as a safer way to use hasOwnProperty.
Added _.collect as an alias for _.map. Smalltalkers, rejoice.
Reverted an old change so that _.extend will correctly copy over keys with undefined values again.
Bugfix to stop escaping slashes within interpolations in _.template.
1.3.0 — January 11, 2012 — Diff — Docs
Removed AMD (RequireJS) support from Underscore. If you'd like to use Underscore with RequireJS, you can load it as a normal script, wrap or patch your copy, or download a forked version.
1.2.4 — January 4, 2012 — Diff — Docs
You now can (and probably should, as it's simpler) write _.chain(list) instead of _(list).chain().
Fix for escaped characters in Underscore templates, and for supporting customizations of _.templateSettings that only define one or two of the required regexes.
Fix for passing an array as the first argument to an _.wrap'd function.
Improved compatibility with ClojureScript, which adds a call function to String.prototype.
1.2.3 — December 7, 2011 — Diff — Docs
Dynamic scope is now preserved for compiled _.template functions, so you can use the value of this if you like.
Sparse array support of _.indexOf, _.lastIndexOf.
Both _.reduce and _.reduceRight can now be passed an explicitly undefined value. (There's no reason why you'd want to do this.)
1.2.2 — November 14, 2011 — Diff — Docs
Continued tweaks to _.isEqual semantics. Now JS primitives are considered equivalent to their wrapped versions, and arrays are compared by their numeric properties only (#351).
_.escape no longer tries to be smart about not double-escaping already-escaped HTML entities. Now it just escapes regardless (#350).
In _.template, you may now leave semicolons out of evaluated statements if you wish: <% }) %> (#369).
_.after(callback, 0) will now trigger the callback immediately, making "after" easier to use with asynchronous APIs (#366).
1.2.1 — October 24, 2011 — Diff — Docs
Several important bug fixes for _.isEqual, which should now do better on mutated Arrays, and on non-Array objects with length properties. (#329)
James Burke contributed Underscore exporting for AMD module loaders, and Tony Lukasavage for Appcelerator Titanium. (#335, #338)
You can now _.groupBy(list, 'property') as a shortcut for grouping values by a particular common property.
_.throttle'd functions now fire immediately upon invocation, and are rate-limited thereafter (#170, #266).
Most of the _.is[Type] checks no longer ducktype.
The _.bind function now also works on constructors, a-la ES5 ... but you would never want to use _.bind on a constructor function.
_.clone no longer wraps non-object types in Objects.
_.find and _.filter are now the preferred names for _.detect and _.select.
1.2.0 — October 5, 2011 — Diff — Docs
The _.isEqual function now supports true deep equality comparisons, with checks for cyclic structures, thanks to Kit Cambridge.
Underscore templates now support HTML escaping interpolations, using <%- ... %> syntax.
Ryan Tenney contributed _.shuffle, which uses a modified Fisher-Yates to give you a shuffled copy of an array.
_.uniq can now be passed an optional iterator, to determine by what criteria an object should be considered unique.
_.last now takes an optional argument which will return the last N elements of the list.
A new _.initial function was added, as a mirror of _.rest, which returns all the initial values of a list (except the last N).
1.1.7 — July 13, 2011 — Diff — Docs
Added _.groupBy, which aggregates a collection into groups of like items. Added _.union and _.difference, to complement the (re-named) _.intersection. Various improvements for support of sparse arrays. _.toArray now returns a clone, if directly passed an array. _.functions now also returns the names of functions that are present in the prototype chain.

1.1.6 — April 18, 2011 — Diff — Docs
Added _.after, which will return a function that only runs after first being called a specified number of times. _.invoke can now take a direct function reference. _.every now requires an iterator function to be passed, which mirrors the ES5 API. _.extend no longer copies keys when the value is undefined. _.bind now errors when trying to bind an undefined value.

1.1.5 — March 20, 2011 — Diff — Docs
Added an _.defaults function, for use merging together JS objects representing default options. Added an _.once function, for manufacturing functions that should only ever execute a single time. _.bind now delegates to the native ES5 version, where available. _.keys now throws an error when used on non-Object values, as in ES5. Fixed a bug with _.keys when used over sparse arrays.

1.1.4 — January 9, 2011 — Diff — Docs
Improved compliance with ES5's Array methods when passing null as a value. _.wrap now correctly sets this for the wrapped function. _.indexOf now takes an optional flag for finding the insertion index in an array that is guaranteed to already be sorted. Avoiding the use of .callee, to allow _.isArray to work properly in ES5's strict mode.

1.1.3 — December 1, 2010 — Diff — Docs
In CommonJS, Underscore may now be required with just:
var _ = require("underscore"). Added _.throttle and _.debounce functions. Removed _.breakLoop, in favor of an ES5-style un-break-able each implementation — this removes the try/catch, and you'll now have better stack traces for exceptions that are thrown within an Underscore iterator. Improved the isType family of functions for better interoperability with Internet Explorer host objects. _.template now correctly escapes backslashes in templates. Improved _.reduce compatibility with the ES5 version: if you don't pass an initial value, the first item in the collection is used. _.each no longer returns the iterated collection, for improved consistency with ES5's forEach.

1.1.2 — October 15, 2010 — Diff — Docs
Fixed _.contains, which was mistakenly pointing at _.intersect instead of _.include, like it should have been. Added _.unique as an alias for _.uniq.

1.1.1 — October 5, 2010 — Diff — Docs
Improved the speed of _.template, and its handling of multiline interpolations. Ryan Tenney contributed optimizations to many Underscore functions. An annotated version of the source code is now available.

1.1.0 — August 18, 2010 — Diff — Docs
The method signature of _.reduce has been changed to match the ES5 signature, instead of the Ruby/Prototype.js version. This is a backwards-incompatible change. _.template may now be called with no arguments, and preserves whitespace. _.contains is a new alias for _.include.

1.0.4 — June 22, 2010 — Diff — Docs
Andri Möll contributed the _.memoize function, which can be used to speed up expensive repeated computations by caching the results.

1.0.3 — June 14, 2010 — Diff — Docs
Patch that makes _.isEqual return false if any property of the compared object has a NaN value. Technically the correct thing to do, but of questionable semantics. Watch out for NaN comparisons.

1.0.2 — March 23, 2010 — Diff — Docs
Fixes _.isArguments in recent versions of Opera, which have arguments objects as real Arrays.

1.0.1 — March 19, 2010 — Diff — Docs
Bugfix for _.isEqual, when comparing two objects with the same number of undefined keys, but with different names.

1.0.0 — March 18, 2010 — Diff — Docs
Things have been stable for many months now, so Underscore is now considered to be out of beta, at 1.0. Improvements since 0.6 include _.isBoolean, and the ability to have _.extend take multiple source objects.

0.6.0 — February 24, 2010 — Diff — Docs
Major release. Incorporates a number of Mile Frawley's refactors for safer duck-typing on collection functions, and cleaner internals. A new _.mixin method that allows you to extend Underscore with utility functions of your own. Added _.times, which works the same as in Ruby or Prototype.js. Native support for ES5's Array.isArray, and Object.keys.

0.5.8 — January 28, 2010 — Diff — Docs
Fixed Underscore's collection functions to work on NodeLists and HTMLCollections once more, thanks to Justin Tulloss.

0.5.7 — January 20, 2010 — Diff — Docs
A safer implementation of _.isArguments, and a faster _.isNumber,
thanks to Jed Schmidt.

0.5.6 — January 18, 2010 — Diff — Docs
Customizable delimiters for _.template, contributed by Noah Sloan.

0.5.5 — January 9, 2010 — Diff — Docs
Fix for a bug in MobileSafari's OOP-wrapper, with the arguments object.

0.5.4 — January 5, 2010 — Diff — Docs
Fix for multiple single quotes within a template string for _.template. See: Rick Strahl's blog post.

0.5.2 — January 1, 2010 — Diff — Docs
New implementations of isArray, isDate, isFunction, isNumber, isRegExp, and isString, thanks to a suggestion from Robert Kieffer. Instead of doing Object#toString comparisons, they now check for expected properties, which is less safe, but more than an order of magnitude faster. Most other Underscore functions saw minor speed improvements as a result. Evgeniy Dolzhenko contributed _.tap, similar to Ruby 1.9's, which is handy for injecting side effects (like logging) into chained calls.

0.5.1 — December 9, 2009 — Diff — Docs
Added an _.isArguments function. Lots of little safety checks and optimizations contributed by Noah Sloan and Andri Möll.

0.5.0 — December 7, 2009 — Diff — Docs
[API Changes] _.bindAll now takes the context object as its first parameter. If no method names are passed, all of the context object's methods are bound to it, enabling chaining and easier binding. _.functions now takes a single argument and returns the names of its Function properties. Calling _.functions(_) will get you the previous behavior. Added _.isRegExp so that isEqual can now test for RegExp equality. All of the "is" functions have been shrunk down into a single definition. Karl Guertin contributed patches.

0.4.7 — December 6, 2009 — Diff — Docs
Added isDate, isNaN, and isNull, for completeness. Optimizations for isEqual when checking equality between Arrays or Dates. _.keys is now 25%–2X faster (depending on your browser) which speeds up the functions that rely on it, such as _.each.

0.4.6 — November 30, 2009 — Diff — Docs
Added the range function, a port of the Python function of the same name, for generating flexibly-numbered lists of integers. Original patch contributed by Kirill Ishanov.

0.4.5 — November 19, 2009 — Diff — Docs
Added rest for Arrays and arguments objects, and aliased first as head, and rest as tail, thanks to Luke Sutton's patches. Added tests ensuring that all Underscore Array functions also work on arguments objects.

0.4.4 — November 18, 2009 — Diff — Docs
Added isString, and isNumber, for consistency. Fixed _.isEqual(NaN, NaN) to return true (which is debatable).

0.4.3 — November 9, 2009 — Diff — Docs
Started using the native StopIteration object in browsers that support it. Fixed Underscore setup for CommonJS environments.

0.4.2 — November 9, 2009 — Diff — Docs
Renamed the unwrapping function to value, for clarity.

0.4.1 — November 8, 2009 — Diff — Docs
Chained Underscore objects now support the Array prototype methods, so that you can perform the full range of operations on a wrapped array without having to break your chain. Added a breakLoop method to break in the middle of any Underscore iteration. Added an isEmpty function that works on arrays and objects.

0.4.0 — November 7, 2009 — Diff — Docs
All Underscore functions can now be called in an object-oriented style, like so: _([1, 2, 3]).map(...);. Original patch provided by Marc-André Cournoyer. Wrapped objects can be chained through multiple method invocations. A functions method was added, providing a sorted list of all the functions in Underscore.

0.3.3 — October 31, 2009 — Diff — Docs
Added the JavaScript 1.8 function reduceRight. Aliased it as foldr, and aliased reduce as foldl.

0.3.2 — October 29, 2009 — Diff — Docs
Now runs on stock Rhino interpreters with: load("underscore.js"). Added identity as a utility function.

0.3.1 — October 29, 2009 — Diff — Docs
All iterators are now passed in the original collection as their third argument, the same as JavaScript 1.6's forEach. Iterating over objects is now called with (value, key, collection), for details see _.each.

0.3.0 — October 29, 2009 — Diff — Docs
Added Dmitry Baranovskiy's comprehensive optimizations, merged in Kris Kowal's patches to make Underscore CommonJS and Narwhal compliant.

0.2.0 — October 28, 2009 — Diff — Docs
Added compose and lastIndexOf, renamed inject to reduce, added aliases for inject, filter, every, some, and forEach.

0.1.1 — October 28, 2009 — Diff — Docs
Added noConflict, so that the "Underscore" object can be assigned to other variables.

0.1.0 — October 28, 2009 — Docs
Initial release of Underscore.js.

A DocumentCloud Project

*/