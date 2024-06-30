/***********************************************************************************************************************
*	Copyright: © 2015-2024 Ozan Nurettin Süel (sicherheitsschmiede)                              *
*	License: Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt]                                       *
*	Authors: Ozan Nurettin Süel (UIManufaktur)										                         * 
***********************************************************************************************************************/
module uim.core.web.html;

import uim.core;

@safe:
// #region startTag
string htmlStartTag(string name, string id, string[] classes, string[string] attributes/* , bool isClosed = false */) {
	if (!id.isEmpty) {
		attributes.remove("id");
	}
	return htmlStartTag(
		name.strip, 
		id.strip, 
		classes.map!(cl => cl.strip).uniq.array.sort!("a < b").join(" "), 
		attributes.keys.sort!("a < b")
			.map!(key => `%s="%s"`.format(key.strip, attributes[key]))
			.join(" ")
	);
}

/* string htmlStartTag(string tag, bool isClosed = false) {
	return isClosed
		? "<" ~ tag ~ "/>"
		: "<" ~ tag ~ ">";
}

string htmlStartTag(string tag, string attributes, bool isClosed = false) {
	return attributes
		? (isClosed 
			? "<%s %s/>".format(tag, attributes) 
			: "<%s %s>".format(tag, attributes)
		)
		: htmlStartTag(tag, isClosed);
}
 */

string htmlStartTag(string name, string id = null, string classes = null, string attributes = null) {
	string startTag;
	startTag ~= "<" ~ name;
	startTag ~= !id.isEmpty ? ` id="` ~ id ~ `"` : null;
	startTag ~= !classes.isEmpty ? ` class="` ~ classes ~ `"` : null;
	startTag ~= !attributes.isEmpty ? ` ` ~ attributes : null;
	startTag ~= ">";
	return startTag;
}

unittest {
	assert(htmlStartTag("hello") == "<hello>");
	assert(htmlStartTag("hello", "x") == `<hello id="x">`);
	assert(htmlStartTag("hello", "x", "abc def") == `<hello id="x" class="abc def">`);
	assert(htmlStartTag("hello", "x", "abc def", `alpha="Alpha" beta="Beta"`) == `<hello id="x" class="abc def" alpha="Alpha" beta="Beta">`);
	assert(htmlStartTag("hello", null, "abc def") == `<hello class="abc def">`);
	assert(htmlStartTag("hello", null, "abc def", `alpha="Alpha" beta="Beta"`) == `<hello class="abc def" alpha="Alpha" beta="Beta">`);
	assert(htmlStartTag("hello", null, null, `alpha="Alpha" beta="Beta"`) == `<hello alpha="Alpha" beta="Beta">`);
}
// #region startTag

string doubleTag(string name) {
	return "<" ~ name ~ ">";
}

unittest {
}

// #region htmlEndTag 
string htmlEndTag(string tag) {
	return "</" ~ tag ~ ">";
}
// #endregion htmlEndTag 

string htmlDoubleTag(string tag, string content = null) {
	return htmlStartTag(tag) ~ content ~ htmlEndTag(tag);
}
unittest {
	assert(htmlDoubleTag("p") == "<p></p>");
	assert(htmlDoubleTag("p", "some content") == "<p>some content</p>");
}

string htmlDoubleTag(string tag, string[] classes, string content = null) {
	return htmlStartTag(tag, null, classes, null) ~ content ~ htmlEndTag(tag);
}
unittest {
	assert(htmlDoubleTag("p", ["x", "b"], "some content") == "<p class=\"x b\">some content</p>");
	assert(htmlDoubleTag("p", null, "some content") == "<p>some content</p>");
}

string htmlDoubleTag(string tag, string id, string[] classes, string content = null) {
	return htmlStartTag(tag, id, classes, null) ~ content ~ htmlEndTag(tag);
}

string htmlDoubleTag(string tag, string[] classes, string[string] attributes, string content = null) {
	return htmlStartTag(tag, null, classes, attributes) ~ content ~ htmlEndTag(tag);
}

string htmlDoubleTag(string tag, string id, string[] classes, string[string] attributes, string content = null) {
	return htmlStartTag(tag, id, classes, attributes) ~ content ~ htmlEndTag(tag);
}

string htmlSingleTag(string tag) {
	return htmlStartTag(tag);
}

string htmlSingleTag(string tag, STRINGAA attributes) {
	return htmlStartTag(tag, null, null, attributes);
}
