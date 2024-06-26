/***********************************************************************************************************************
*	Copyright: © 2015-2024 Ozan Nurettin Süel (sicherheitsschmiede)                              *
*	License: Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt]                                       *
*	Authors: Ozan Nurettin Süel (UIManufaktur)										                         * 
***********************************************************************************************************************/
module uim.core.web.html;

import uim.core;

@safe:
// #region startTag
string htmlStartTag(string name, string id = null, string classes = null, string attributes = null) {
	string startTag;
	startTag ~= "<" ~ name;
	startTag ~= !id.isEmpty ? ` id="` ~ id ~ `"` : null;
	startTag ~= !classes.isEmpty ? ` class="` ~ classes ~ `"` : null;
	startTag ~= !attributes.isEmpty ? ` ` ~ attributes : null;
	startTag ~= ">";
	return startTag;
}
unittest{
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

// #region createHtmlStartTag 
string createHtmlStartTag(string tag, bool close = false) {
	if (close)
		return "<" ~ tag ~ "/>";
	return "<" ~ tag ~ ">";
}

string createHtmlStartTag(string tag, STRINGAA attributes, bool isCompact = false) {
	if (attributes) {
		string attValue = attributes.byKeyValue
			.map!(kv => `%s="%s"`.format(kv.key, kv.value()))
			.join(" ");

		return isCompact
			? "<%s %s/>".format(tag, attValue) : "<%s %s>".format(tag, attValue);
	}
	return createHtmlStartTag(tag, isCompact);
}
// #endregion createHtmlStartTag 

// #region createHtmlEndTag 
string createHtmlEndTag(string tag) {
	return "</" ~ tag ~ ">";
}
// #endregion createHtmlEndTag 

string createHtmlDoubleTag(string tag, string[] content...) {
	return createHtmlDoubleTag(tag, content.dup);
}

string createHtmlDoubleTag(string tag, string[] content) {
	if (content) {
		return createHtmlStartTag(tag) ~ content.join("") ~ createHtmlEndTag(tag);
	}
	return createHtmlStartTag(tag, true);
}

string createHtmlDoubleTag(string tag, STRINGAA attributes, string[] content...) {
	if (content) {
		return createHtmlStartTag(tag, attributes) ~ content.join("") ~ createHtmlEndTag(tag);
	}
	return createHtmlStartTag(tag, attributes, true);
}

string createHtmlSingleTag(string tag) {
	return createHtmlStartTag(tag);
}

string createHtmlSingleTag(string tag, STRINGAA attributes) {
	return createHtmlStartTag(tag, attributes);
}
