﻿/***********************************************************************************************************************
*	Copyright: © 2015-2024 Ozan Nurettin Süel (sicherheitsschmiede)                              *
*	License: Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt]                                       *
*	Authors: Ozan Nurettin Süel (UIManufaktur)										                         * 
***********************************************************************************************************************/
module uim.core.datatypes.string_;

import uim.core;

@safe:

/// create a string with defined length and content
string fill(size_t width, string fillText = "0") {
	if (width == 0 || fillText.length == 0) {
		return null;
	}

	string filledText;
	while (filledText.length < width) {
		filledText ~= fillText;
	}
	filledText.length = width; // cut result to length
	return filledText;
}

unittest {
	assert(fill(10, "0").length == 10);
	assert(fill(10, "0") == "0000000000");
	assert(fill(10, "TXT") == "TXTTXTTXTT");
}

string bind(string source, STRINGAA replaceMap, string placeHolder = "{{%s}}") {
	import std.string;

	string updatedText = source;
	replaceMap.byKeyValue
		.each!(kv => updatedText = std.string.replace(updatedText, placeHolder.format(kv.key), kv
				.value));

	return updatedText;
}

unittest {
	assert("{{abc}}".bind(["abc": "xyz"]) == "xyz");
	assert("0{{abc}}0".bind(["abc": "xyz"]) == "0xyz0");
}

bool endsWith(string text, string[] endings) {
	if (text.length == 0) {
		return false;
	}

	return endings.length > 0
		? endings.any!(ending => ending.length > 0 && text[$ - ending.length .. $] == ending)
		: false;
}
///
unittest {
	assert("ABC".endsWith(["C"]));
	assert(!"".endsWith(["C"]));
	assert(!"ABC".endsWith([""]));
}

// #region contains
bool containsAny(string[] bases, string[] values...) {
	return containsAny(bases, values.dup);
}

unittest {
	assert(["One Two Three"].containsAny("One"));
	assert(!["One Two Three", "Eight Seven Six"].containsAny("Five", "Four"));
	assert(!["One Two Three"].containsAny("Five", "Four"));
}

bool containsAny(string[] bases, string[] values) {
	return bases.any!(base => base.containsAny(values));
}

unittest {
	assert(["One Two Three"].containsAny(["One"]));
	assert(!["One Two Three", "Eight Seven Six"].containsAny(["Five", "Four"]));
	assert(!["One Two Three"].containsAny(["Five", "Four"]));
}

bool containsAny(string base, string[] values...) {
	return containsAny(base, values.dup);
}

bool containsAny(string base, string[] values) {
	return values.any!(value => base.contains(value));
}

bool containsAll(string[] bases, string[] values...) {
	return containsAll(bases, values.dup);
}

unittest {
	assert(["One Two Three"].containsAll("One"));
	assert(!["One Two Three", "Eight Seven Six"].containsAll("Five", "Four", "Six"));
	assert(!["One Two Three"].containsAll("Five", "Four"));
}

bool containsAll(string[] bases, string[] values) {
	return bases.all!(base => base.containsAll(values));
}

unittest {
	assert(["One Two Three"].containsAll(["One"]));
	assert(!["One Two Three", "Eight Seven Six"].containsAll([
			"Five", "Four", "Six"
		]));
	assert(!["One Two Three"].containsAll(["Five", "Four"]));
}

bool containsAll(string base, string[] values...) {
	return containsAll(base, values.dup);
}

bool containsAll(string base, string[] values) {
	return values.all!(value => base.contains(value));
}

unittest {
	assert("One Two Three".contains("One"));
/* 	assert(!"One Two Three".contains("Five", "Four", "Three"));
	assert(!"One Two Three".contains("Five", "Four"));
 */}

bool contains(string text, string checkValue) {
	return (text.length == 0 || checkValue.length == 0 || checkValue.length > text.length) 
		? false
		: (text.indexOf(checkValue) >= 0);
}

/* bool hasValue(string base, string checkValue) {
	if (base.length == 0 || checkValue.length == 0 || checkValue.length > base.length) {
		return false;
	}
	return (base.indexOf(checkValue) >= 0);
} */
// #endregion has

// #region remove
pure string[] removeValues(string[] values, string[] removingValues...) {
	return removeValues(values, removingValues.dup);
}

pure string[] removeValues(string[] values, string[] removingValues) {
	string[] results = values;
	removingValues
		.each!(value => results = results.removeValue(value));

	return results;
}

unittest {
	assert(removeValues(["a", "b", "c"], "b") == ["a", "c"]);
	assert(removeValues(["a", "b", "c", "b"], "b") == ["a", "c"]);

	assert(removeValues(["a", "b", "c"], "a", "b") == ["c"]);
	assert(removeValues(["a", "b", "c", "b"], "a", "b") == ["c"]);
}

pure string[] removeValue(string[] values, string valueToRemove) {
	auto updatedValues = values.dup;
	return valueToRemove.length == 0
		? updatedValues
		: updatedValues
		.filter!(value => value != valueToRemove)
		.array;
}

unittest {
	assert(removeValue(["a", "b", "c"], "b") == ["a", "c"]);
	assert(removeValue(["a", "b", "c", "b"], "b") == ["a", "c"]);
}
// #endregion remove

/// Unique - Reduce duplicates in array
string[] unique(string[] someValues) {
	STRINGAA results;
	foreach (value; someValues) {
		results[value] = value;
	}
	return results.keys.array;
}

version (test_uim_core) {
	unittest {
		assert(["a", "b", "c"].unique == ["a", "b", "c"]);
		assert(["a", "b", "c", "c"].unique == ["a", "b", "c"]);
	}
}

bool startsWith(string text, string[] startings) {
	if (text.length == 0) {
		return false;
	}

	return startings.length > 0
		? startings.any!(starting => starting.length > 0 && text.indexOf(starting) == 0) : false;
}

unittest {
	assert("ABC".startsWith(["A"]));
	assert(!"".startsWith(["A"]));
	assert(!"ABC".startsWith([""]));
}

string toString(string[] values) {
	return "%s".format(values);
}

string quotes(string text, string leftAndRight) {
	return leftAndRight ~ text ~ leftAndRight;
}

string quotes(string text, string left, string right) {
	return left ~ text ~ right;
}

// TODO
/* 
string[] toStrings(T...)(T someValues...){
	return someValues.map!(value => "%s".format(value)).array;
}
unittest {
	debug writeln(toStrings(1, 2));
	debug writeln(toStrings(1, "a"));
} */

string indent(in string text, size_t indent = 2) {
	if (indent == 0) {
		return text;
	}

	return fill(indent, " ") ~ text;
}

unittest {
	assert(indent("Hallo").length == 7);
	assert(indent("Hallo") == "  Hallo");
	assert(indent("Hallo", 3).length == 8);
	assert(indent("Hallo", 3) == "   Hallo");
}

size_t[] indexOfAll(string text, string searchTxt) {
	if (text.indexOf(searchTxt) == -1)
		return [];

	size_t[] results;
	size_t currentPos = 0;
	while ((currentPos < text.length) && (currentPos >= 0)) {
		currentPos = text.indexOf(searchTxt, currentPos);
		if ((currentPos < text.length) && (currentPos >= 0)) {
			results ~= currentPos;
			currentPos++;
		}
	}

	return results;
}

version (test_uim_core) {
	unittest {
	}
}

// subString() - returns a part of a string.
// aText - String value
// startPos - Required. Specifies where to start in the string. Starting with 0 (first letter)
// -- A positive number - Start at a specified position in the string
// -- A negative number - Start at a specified position from the end of the string
// -- 0 - Start at the first character in string
string subString(string aText, long startPos) {
	if (startPos == 0) {
		return aText;
	}

	return startPos > 0
		? (startPos >= aText.length ? aText : aText[startPos .. $]) : (
			-startPos >= aText.length ? aText : aText[0 .. $ + startPos]);
}

unittest {
	assert("This is a test".subString(4) == " is a test");
	assert("This is a test".subString(-4) == "This is a ");
}

// same like subString(), with additional parameter length
// length	- Specifies the length of the returned string. Default is to the end of the string.
// A positive number - The length to be returned from the start parameter
// Negative number - The length to be returned from the end of the string
// If the length parameter is 0, NULL, or FALSE - it return an empty string
string subString(string aText, size_t startPos, long aLength) {
	auto myText = subString(aText, startPos);
	return aLength > 0
		? (myText.length >= aLength ? myText[0 .. aLength] : myText) : (
			myText.length >= -aLength ? myText[$ + aLength .. $] : myText);
}

unittest {
	assert("0123456789".subString(4, 2) == "45");
	assert("0123456789".subString(-4, 2) == "01");
	assert("0123456789".subString(-4, -2) == "45");
}

// TODO
string capitalizeWords(string aText, string separator = " ") {
	return capitalize(std.string.split(aText, separator)).join(separator);
}

version (test_uim_core) {
	unittest {
		assert("this is a test".capitalizeWords == "This Is A Test");
		assert("this  is  a  test".capitalizeWords == "This  Is  A  Test");
	}
}

size_t[string] countWords(string aText, bool caseSensitive = true) {
	size_t[string] results;

	// TODO missing caseSensitive = false
	std.string.split(aText, " ")
		.each!(word => results[word] = word in results ? results[word] + 1 : 1);

	return results;
}

unittest {
	// assert(countWords("This is a test")["this"] == 0);
	assert(countWords("this is a test")["this"] == 1);
	assert(countWords("this is a this")["this"] == 2);
}

string repeat(string text, size_t times) {
	string result;
	for (auto i = 0; i < times; i++) {
		result ~= text;
	}
	return result;
}

unittest {
	assert(repeat("bla", 0) is null);
	assert(repeat("bla", 2) == "blabla");
}

string firstElement(string text, string separator = ".") {
	if (text.length == 0) {
		return text;
	}

	auto firstIndex = text.countUntil(separator);
	return firstIndex < 0
		? text : text[0 .. firstIndex];
}

unittest {
	assert("a/b/c".firstElement("/") == "a");
	assert("a.b.c".firstElement(".") == "a");
}

string lastElement(string text, string separator = ".") {
	if (text.length == 0) {
		return null;
	}

	auto lastIndex = text.retro.countUntil(separator);
	if (lastIndex < 0) {
		return text;
	}

	return text[($ - lastIndex) .. $];
}

unittest {
	assert("a/b/c".lastElement("/") == "c");
	assert("a.b.c".lastElement(".") == "c");
}

string toPath(string[] pathItems, string separator = ".") {
	return pathItems
		.map!(item => std.string.strip(item))
		.map!(item => std.string.strip(item, separator))
		.map!(item => std.string.strip(item))
		.filter!(item => item.length > 0)
		.join(separator);
}

unittest {
	assert(toPath(["a", "b", "c"]) == "a.b.c");
	assert(toPath(["a ", ".b", "c."]) == "a.b.c");
	assert(toPath(["a ", "", ".b", "c."]) == "a.b.c");

	assert(["a", "b", "c"].toPath("/") == "a/b/c");
	assert(["a ", "/b", "c/"].toPath("/") == "a/b/c");
	assert(["a ", "", "/b", "c/"].toPath("/") == "a/b/c");
}

string lower(string text) {
	return text.toLower;
}

string[] lower(string[] texts) {
	return texts
		.map!(text => text.toLower)
		.array;
}

// region upper
string[] upper(string[] texts) {
	return texts
		.map!(text => text.toUpper)
		.array;
}

unittest {
	assert(["a", "b", "c"].upper.equal(["A", "B", "C"]));
}

string upper(string text) {
	return text.toUpper;
}

unittest {
	assert("a".upper == "A");
}
// #endregion upper

string[] capitalize(string[] texts) {
	return texts
		.map!(text => std.string.capitalize(text))
		.array;
}

unittest {
	// TODO
}

// #region strip
string[] strip(string[] texts) {
	return texts
		.map!(text => std.string.strip(text))
		.array;
}

unittest {
	// TODO
}

string[] stripLeft(string[] texts) {
	return texts
		.map!(text => std.string.stripLeft(text))
		.array;
}

unittest {
	// TODO
}

string[] stripRight(string[] texts) {
	return texts
		.map!(text => std.string.stripRight(text))
		.array;
}
// #endregion strip

// #region replace
string[] replace(string[] texts, string originText, string newText) {
	return texts
		.map!(text => std.string.replace(text, originText, newText))
		.array;
}
// #endregion replace

string[] split(string text, string splitText = " ", int limit) {
	auto splits = std.string.split(text, splitText);
	if (limit > 0 && limit < splits.length) {
		return splits[0 .. limit] ~ splits[limit .. $].join(splitText);
	}
	if (limit < 0 && limit > -splits.length) {
		return splits[0 .. -limit].join(splitText) ~ splits[-limit .. $];
	}
	return splits;
}

unittest {
	// TODO create test
}

// TODO
string[] split(string[] texts, string splitText = " ", int limit = 0) {
	auto splitTexts = texts
		.map!(text => split(text, splitText, limit)).array;
	return join(splitTexts);
}

unittest {
	// TODO create test
}

string ifNull(string value, string defaultValue) {
	return !value.isNull ? value : defaultValue;
}
///
unittest {
	string a = null;
	assert(isNull(a));
	assert(a.isNull);

	a = "";
	assert(!isNull(a));
	assert(!a.isNull);

	a = "xyz";
	assert(!isNull(a));
	assert(!a.isNull);
	assert(!"xyz".isNull);
}

string ifEmpty(string value, string defaultValue) {
	return !value.isEmpty ? value : defaultValue;
}

bool isIn(string value, string[] values) {
	return canFind(values, value);
}

unittest {
	assert("a".isIn(["a", "b", "c"]));
	assert(!"x".isIn(["a", "b", "c"]));
}

string mustache(string text, STRINGAA values) {
	foreach(key, value; values) {
		text = text.mustache(key, value);
	}
	return text;
}
string mustache(string text, string key, string value) {
	return std.string.replace(text, "{"~key~"}", value);
}
unittest {
	assert("A:{a}, B:{b}".mustache(["a":"x", "b":"y"]) == "A:x, B:y");
	assert("A:{a}, B:{b}".mustache(["a":"a", "b":"b"]) != "A:x, B:y");
}

string doubleMustache(string text, STRINGAA values) {
	foreach(key, value; values) {
		text = text.doubleMustache(key, value);
	}
	return text;
}
string doubleMustache(string text, string key, string value) {
	return std.string.replace(text, "{{"~key~"}}", value);
}
unittest {
	assert("A:{{a}}, B:{{b}}".doubleMustache(["a":"x", "b":"y"]) == "A:x, B:y");
	assert("A:{{a}}, B:{{b}}".doubleMustache(["a":"a", "b":"b"]) != "A:x, B:y");

	string text = "A:{{a}}, B:{{b}}";
	assert(text.doubleMustache(["a":"x", "b":"y"]) == "A:x, B:y");
	assert(text == "A:{{a}}, B:{{b}}");
}