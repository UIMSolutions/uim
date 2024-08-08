/***********************************************************************************************************************
*	Copyright: © 2015-2024 Ozan Nurettin Süel (sicherheitsschmiede)                              *
*	License: Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt]                                       *
*	Authors: Ozan Nurettin Süel (UIManufaktur)										                         * 
***********************************************************************************************************************/
module uim.core.datatypes.string_;

import uim.core;

@safe:

V Null(V : string)() {
	return null;
}

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
 */
}

bool contains(string text, string checkValue) {
	return (text.length == 0 || checkValue.length == 0 || checkValue.length > text.length)
		? false : (text.indexOf(checkValue) >= 0);
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
	return pathItems.stripText(" ", separator, " ")
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
// #region stripText
string[] stripText(string[] texts, string[] chars...) {
	return stripText(texts, chars.dup);
}

string[] stripText(string[] texts, string[] chars) {
	return texts
		.map!(text => stripText(text, chars))
		.array;
}

string stripText(string text, string[] chars...) {
	return stripText(text, chars.dup);
}

string stripText(string text, string[] chars) {
	if (text.isEmpty) {
		return null;
	}
	if (chars.isEmpty) {
		return text.strip;
	}
	foreach (c; chars) {
		text = text.strip(c);
	}
	return text;
}

unittest {
	assert("a".stripText == "a");
	assert(" a".stripText == "a");
	assert("a ".stripText == "a");
	assert(" a ".stripText == "a");

	assert("a".stripText(["."]) == "a");
	assert(" a".stripText(["."]) == " a");
	assert("a ".stripText(["."]) == "a ");
	assert(" a ".stripText(["."]) == " a ");

	assert("a".stripText(".") == "a");
	assert(" a".stripText(".") == " a");
	assert("a ".stripText(".") == "a ");
	assert(" a ".stripText(".") == " a ");

	assert("a".stripText(".") == "a");
	assert(".a".stripText(".") == "a");
	assert("a.".stripText(".") == "a");
	assert(".a.".stripText(".") == "a");

	assert("a".stripText(".") == "a");
	assert(".a".stripText(".") == "a");
	assert("a.".stripText(".") == "a");
	assert(".a.".stripText(".") == "a");

	assert("a".stripText(" ") == "a");
	assert(".a".stripText(" ") == ".a");
	assert("a.".stripText(" ") == "a.");
	assert(".a.".stripText(" ") == ".a.");

	assert("a".stripText(".", " ") == "a");
	assert(".a ".stripText(".", " ") == "a");
	assert(" a.".stripText(".", " ") == "a");
	assert(" .a. ".stripText(".", " ") == ".a.");
	assert(" .a. ".stripText(" ", ".") == "a");

	assert(["a", "b", "c"].stripText == ["a", "b", "c"]);
	assert([" a", "b ", " c "].stripText == ["a", "b", "c"]);
	assert([".a", "b.", ".c."].stripText(["."]) == ["a", "b", "c"]);
}
// #endregion stripText

// #region stripTextLeft
string[] stripTextLeft(string[] texts, string[] chars...) {
	return stripTextLeft(texts, chars.dup);
}

string[] stripTextLeft(string[] texts, string[] chars) {
	return texts
		.map!(text => stripTextLeft(text, chars))
		.array;
}

string stripTextLeft(string text, string[] chars...) {
	return stripTextLeft(text, chars.dup);
}

string stripTextLeft(string text, string[] chars) {
	if (text.isEmpty) {
		return null;
	}
	if (chars.isEmpty) {
		return stripLeft(text);
	}
	foreach (c; chars) {
		text = stripLeft(text, c);
	}
	return text;
}

unittest {
	assert("a".stripTextLeft == "a");
	assert(" a".stripTextLeft == "a");
	assert("a ".stripTextLeft == "a ");
	assert(" a ".stripTextLeft == "a ");

	assert("a".stripTextLeft(["."]) == "a");
	assert(" a".stripTextLeft(["."]) == " a");
	assert("a ".stripTextLeft(["."]) == "a ");
	assert(" a ".stripTextLeft(["."]) == " a ");

	assert("a".stripTextLeft(".") == "a");
	assert(" a".stripTextLeft(".") == " a");
	assert("a ".stripTextLeft(".") == "a ");
	assert(" a ".stripTextLeft(".") == " a ");

	assert("a".stripTextLeft(".") == "a");
	assert(".a".stripTextLeft(".") == "a");
	assert("a.".stripTextLeft(".") == "a.");
	assert(".a.".stripTextLeft(".") == "a.");

	assert("a".stripTextLeft(".") == "a");
	assert(".a".stripTextLeft(".") == "a");
	assert("a.".stripTextLeft(".") == "a.");
	assert(".a.".stripTextLeft(".") == "a.");

	assert("a".stripTextLeft(" ") == "a");
	assert(".a".stripTextLeft(" ") == ".a");
	assert("a.".stripTextLeft(" ") == "a.");
	assert(".a.".stripTextLeft(" ") == ".a.");

	assert("a".stripTextLeft(".", " ") == "a");
	assert(".a ".stripTextLeft(".", " ") == "a ");
	assert(" a.".stripTextLeft(".", " ") == "a.");
	assert(" .a. ".stripTextLeft(".", " ") == ".a. ");
	assert(" .a. ".stripTextLeft(" ", ".") == "a. ");

	assert(["a", "b", "c"].stripTextLeft == ["a", "b", "c"]);
	assert([" a", "b ", " c "].stripTextLeft == ["a", "b ", "c "]);
	assert([".a", "b.", ".c."].stripTextLeft(["."]) == ["a", "b.", "c."]);
}
// #endregion stripTextLeft

// #region stripTextRight
string[] stripTextRight(string[] texts, string[] chars...) {
	return stripTextRight(texts, chars.dup);
}

string[] stripTextRight(string[] texts, string[] chars) {
	return texts
		.map!(text => stripTextRight(text, chars))
		.array;
}

string stripTextRight(string text, string[] chars...) {
	return stripTextRight(text, chars.dup);
}

string stripTextRight(string text, string[] chars) {
	if (text.isEmpty) {
		return null;
	}
	if (chars.isEmpty) {
		return stripRight(text);
	}
	foreach (c; chars) {
		text = stripRight(text, c);
	}
	return text;
}

unittest {
	assert("a".stripTextRight == "a");
	assert(" a".stripTextRight == " a");
	assert("a ".stripTextRight == "a");
	assert(" a ".stripTextRight == " a");

	assert("a".stripTextRight(["."]) == "a");
	assert(" a".stripTextRight(["."]) == " a");
	assert("a ".stripTextRight(["."]) == "a ");
	assert(" a ".stripTextRight(["."]) == " a ");

	assert("a".stripTextRight(".") == "a");
	assert(" a".stripTextRight(".") == " a");
	assert("a ".stripTextRight(".") == "a ");
	assert(" a ".stripTextRight(".") == " a ");

	assert("a".stripTextRight(".") == "a");
	assert(".a".stripTextRight(".") == ".a");
	assert("a.".stripTextRight(".") == "a");
	assert(".a.".stripTextRight(".") == ".a");

	assert("a".stripTextRight(".") == "a");
	assert(".a".stripTextRight(".") == ".a");
	assert("a.".stripTextRight(".") == "a");
	assert(".a.".stripTextRight(".") == ".a");

	assert("a".stripTextRight(" ") == "a");
	assert(".a".stripTextRight(" ") == ".a");
	assert("a.".stripTextRight(" ") == "a.");
	assert(".a.".stripTextRight(" ") == ".a.");

	assert("a".stripTextRight(".", " ") == "a");
	assert(".a ".stripTextRight(".", " ") == ".a");
	assert(" a.".stripTextRight(".", " ") == " a");
	assert(" .a. ".stripTextRight(".", " ") == " .a.");
	assert(" .a. ".stripTextRight(" ", ".") == " .a");
}
// #endregion stripTextRight
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

string ifNull(string[] values...) {
	foreach (value; values) {
		if (!value.isNull) {
			return value;
		}
	}
	return null;
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

string ifEmpty(string[] values...) {
	foreach (value; values) {
		if (value.length > 0) {
			return value;
		}
	}
	return null;
}

bool isIn(string value, string[] values) {
	return canFind(values, value);
}

unittest {
	assert("a".isIn(["a", "b", "c"]));
	assert(!"x".isIn(["a", "b", "c"]));
}

// #region mustache
string mustache(string text, STRINGAA items) {
	items.byKeyValue.each!(item => text = text.mustache(item.key, item.value));
	return text;
}

string mustache(string text, string key, string value) {
	return std.string.replace(text, "{" ~ key ~ "}", value);
}

unittest {
	assert("A:{a}, B:{b}".mustache(["a": "x", "b": "y"]) == "A:x, B:y");
	assert("A:{a}, B:{b}".mustache(["a": "a", "b": "b"]) != "A:x, B:y");
}
// #endregion mustache

// #region doubleMustache
string doubleMustache(string text, STRINGAA items) {
	items.byKeyValue.each!(item => text = text.doubleMustache(item.key, item.value));
	return text;
}

string doubleMustache(string text, string key, string value) {
	return std.string.replace(text, "{{" ~ key ~ "}}", value);
}

unittest {
	assert("A:{{a}}, B:{{b}}".doubleMustache(["a": "x", "b": "y"]) == "A:x, B:y");
	assert("A:{{a}}, B:{{b}}".doubleMustache(["a": "a", "b": "b"]) != "A:x, B:y");

	string text = "A:{{a}}, B:{{b}}";
	assert(text.doubleMustache(["a": "x", "b": "y"]) == "A:x, B:y");
	assert(text == "A:{{a}}, B:{{b}}");
}
// #endregion doubleMustache

string match(K)(string[K] matchValues, K key, string defaultValue = null) {
	return key in matchValues
		? matchValues[key] : defaultValue;
}

// #region md5
string[] md5(string[] values) {
	return values.map!(value => md5(value)).array;
}

string md5(string value) {
	return toHexString(md5Of(value).dup);
}

unittest {
	assert(md5("abc") == "900150983CD24FB0D6963F7D28E17F72");
	assert("abc".md5 == "900150983CD24FB0D6963F7D28E17F72");
	assert("abc".md5 != "");

	assert(md5(["abc", "xyz"]) == [
			"900150983CD24FB0D6963F7D28E17F72", "D16FB36F0911F878998C136191AF705E"
		]);
	assert(["abc", "xyz"].md5 == [
			"900150983CD24FB0D6963F7D28E17F72", "D16FB36F0911F878998C136191AF705E"
		]);
	assert(["abc", "xyz"].md5 != ["", ""]);
}
// #endregion md5

// #region camelize
// Returns the input lower_case_delimited_string as a CamelCasedString.
string[] camelize(string[] texts, string delimiter = "_") {
	return texts.map!(text => text.camelize(delimiter)).array;
}

string camelize(string text, string delimiter = "_") {
	string cacheKey = __FUNCTION__ ~ delimiter;

	string result; // = _caching(cacheKey, text);
	if (result.isNull) {
		result = std.string.replace(humanize(text, delimiter), " ", "");
		// _caching(cacheKey, text, result);
	}

	return result;
}

unittest {
	assert("aa".camelize == "Aa");
	assert(["aa", "bb"].camelize == ["Aa", "Bb"]);
}
// #endregion camelize

/**
     * Returns the input CamelCasedString as an dashed-string.
     *
     * Also replaces underscores with dashes
     * Params:
     * string text The string to dasherize.
     */
/* static string dasherize(string stringToDasherize) {
    return delimit(stringToDasherize.replace("_", "-"), "-");
  } */

// #region humanize
/**
     * Returns the input lower_case_delimited_string as "A Human Readable String".
     * (Underscores are replaced by spaces and capitalized following words.)
     */
string[] humanize(string[] texts, string delimiter = "_") {
	return texts.map!(text => humanize(text, delimiter)).array;
}

string humanize(string text, string delimiter = "_") {
	auto cacheKey = __FUNCTION__ ~ delimiter;

	string result; // = _caching(cacheKey, text);
	if (result.isEmpty) {
		string[] parts = std.string.split(std.string.replace(text, delimiter, " "), " ");
		result = parts.map!(part => std.string.capitalize(part)).join(" ");
		// _caching(cacheKey, text, result);
	}

	return result;
}

unittest {
	assert(["i_am_not_here", "where_are_you"].humanize == [
			"I Am Not Here", "Where Are You"
		]);
	assert("hello_world_and_mars".humanize == "Hello World And Mars");
}
// #endregion humanize

// #region underscore
// Returns the input CamelCasedString as an underscored_string. Also replaces dashes with underscores
string[] underscore(string[] texts) {
	return texts.map!(text => text.underscore).array;
}

string underscore(string text) {
	return delimit(std.string.replace(text, "-", "_"), "_");
}

unittest {
	writeln("underscore");
	writeln(underscore("camel-cased-input-string"));
	writeln(underscore("  camel-cased-input-string  "));

	writeln(underscore("camel-cased-input-string"));
	writeln(underscore("  camel-cased-input-string  "));
}
// #endregion underscore

// Expects a CamelCasedInputString, and produces a lower_case_delimited_string
string[] delimit(string[] texts, string delimiter = "_") {
	return texts.map!(text => text.delimit(delimiter)).array;
}

string delimit(string text, string delimiter = "_") {
	// auto cacheKey = __FUNCTION__ ~ delimiter;
	string result; // = _caching(cacheKey, text);

	if (result.isEmpty) {
		/* auto regex = regex(r"/(?<=\\w)([A-Z])/");
      result = text.replaceAll(regex, delimiter ~ "\\1").lower; */
		// _caching(cacheKey, text, result);
		dchar lastChar;
		foreach (index, c; text) {
			result ~= std.uni.isUpper(c) && index > 0 && !std.uni.isWhite(lastChar)
				? delimiter ~ c : "" ~ c;
			lastChar = c;
		}
	}
	return result.lower;
}

unittest {
	writeln("delimit");
	writeln(delimit("CamelCasedInputString"));
	writeln(delimit("  CamelCasedInputString  x"));
	writeln(delimit("  CamelCasedInputString  x"));
	writeln(delimit("xX  CamelCasedInputString  xX"));
}

// Return myword in singular form.
string singularize(string pluralWord) {
	/*     if (isSet(_cache["singularize"][pluralWord])) {
      return _cache["singularize"][pluralWord];
    }
 */
	/* auto irregularWords = _cache.get("irregular", null);
    if (!irregularWords.isSet("singular")) {
      mywordList = _irregular.values;
      static.irregularWords.set("singular", "/(.*?(?:\\b|_))(" ~ mywordList.join("|") ~ ")my/i");

      myupperWordList = mywordList.capitalize;
      static.irregularWords.set("singularUpper", "/(.*?(?:\\b|[a-z]))("~myupperWordList.join("|""))
        .")my/";
    }

    if (
      preg_match(irregularWords["singular"], pluralWord, myregs) ||
      preg_match(irregularWords["singularUpper"], pluralWord, myregs)
      ) {
      mysuffix = array_search(myregs[2].lower, _irregular, true);
      mysuffix = mysuffix ? subString(mysuffix, 1) : "";
      // _cache["singularize"][pluralWord] = myregs[1] ~ subString(myregs[2], 0, 1) ~ mysuffix;

      return _cache["singularize"][pluralWord];
    }
    if (!_cache.isSet("uninflected")) {
      _cache["uninflected"] = "/^(" ~ _uninflected.join("|") ~ ")my/i";
    }
    if (preg_match(_cache["uninflected"], pluralWord, myregs)) {
      _cache["pluralize"][pluralWord] = pluralWord;

      return pluralWord;
    }

    foreach (myrule, myreplacement; _singular) {
      if (preg_match(myrule, pluralWord)) {
        _cache["singularize"][pluralWord] = to!string(preg_replace(myrule, myreplacement, pluralWord));
        return _cache["singularize"][pluralWord];
      }
    }
    // _cache["singularize"][pluralWord] = pluralWord;

    return pluralWord; */
	return null;
}

// #region tableize
// Returns corresponding table name for given model myclassname. ("people" for the model class "Person").
string[] tableize(string[] classnames) {
	return classnames.map!(name => name.tableize).array;
}

string tableize(string classname) {
	string result; // = _caching(__FUNCTION__, myclassname);
	if (result.isEmpty) {
		result = classname.underscore.pluralize;
		// _caching(__FUNCTION__, myclassname, result);
	}
	return result;
}

unittest {
	// 
}
// #endregion tableize

// #region classify
// Returns uim model class name ("Person" for the database table "people".) for given database table.
string[] classify(string[] tableNames) {	
	return tableNames.map!(name => name.classify).array;
}

string classify(string tableName) {
	string result; // = _caching(__FUNCTION__, mytableName);

	if (result.isEmpty) {
		result = tableName.singularize.camelize;
		// _caching(__FUNCTION__, mytableName, result);
	}
	return result;
}
// #endregion classify

/**
     * Returns camelBacked version of an underscored string.
     * returns string in variable form
     */
string variable(string stringToConvert) {
	string result; // = // _caching(__FUNCTION__, stringToConvert);
	if (result.isEmpty) {
		string camelized = stringToConvert.underscore.camelize;
		string replaced = subString(camelized, 0, 1).lower;
		result = replaced ~ subString(camelized, 1);
		// _caching(__FUNCTION__, stringToConvert, result);
	}
	return result;
}

// Return myword in plural form.
string pluralize(string singularWord) {
	/* auto pluralizeWords = _cache.get("pluralize", null);
	if (pluralizeWords.isSet(singularWord)) { // Found in cache
		return pluralizeWords[singularWord];
	}

	auto irregularWords = _cache.get("irregular", null);
	if (irregularWords.isNull("pluralize")) {
		mywords = _irregular.keys;
		static.irregularWords["pluralize"] = "/(.*?(?:\\b|_))(" ~ join("|", mywords)~")my/i";

		myupperWords = array_map("ucfirst", mywords);
		static.irregularWords.set("upperPluralize", "/(.*?(?:\\b|[a-z]))(" ~ join("|", myupperWords) ~ ")my/");
	}
	if (
		preg_match(irregularWords["pluralize"], singularWord, myregs) ||
		preg_match(irregularWords["upperPluralize"], singularWord, myregs)
		) {
		pluralizeWords[singularWord] = myregs[1] ~ subString(myregs[2], 0, 1)
			.subString(
				_irregular[strtolower(myregs[2])], 1);

		return pluralizeWords[singularWord];
	}
	if (!_cache.isSet("uninflected")) {
		_cache.set("uninflected", "/^(" ~ _uninflected.join("|") ~ ")my/i");
	}
	if (preg_match(_cache["uninflected"], singularWord, myregs)) {
		pluralizeWords[singularWord] = singularWord;

		return singularWord;
	}
	foreach (_plural as myrule : myreplacement) {
		if (preg_match(myrule, singularWord)) {
			pluralizeWords[singularWord] = (string) preg_replace(myrule, myreplacement, singularWord);

			return pluralizeWords[singularWord];
		}
	}
	return singularWord; */
	return null;
}

// Cache inflected values, and return if already available
STRINGAA[string] _cache;
string _caching(string inflectionType, string originalValue, string inflectedValue = null) {
	originalValue = "_" ~ originalValue;
	inflectionType = "_" ~ inflectionType;
	if (!inflectedValue.isEmpty) {
		if (!_cache.isSet(inflectionType)) {
			_cache[inflectionType] = null;	
		}
		_cache[inflectionType][originalValue] = inflectedValue;
		return inflectedValue;
	}

	return _cache.isSet(inflectionType) && _cache[inflectionType].isSet(originalValue)
		? _cache[inflectionType][originalValue] : null;
}

bool isBoolean(string value) {
	return ["yes", "no", "true", "false", "0", "1", "on", "off"].has(value.lower);
}