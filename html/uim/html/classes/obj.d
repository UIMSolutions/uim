module uim.html.classes.obj;

import uim.html;

@safe:

class DH5Obj {
	this() {
		initialize;
	}

	this(string newContent) {
		this().addContent(newContent);
	}

	this(DH5Obj[] newContent...) {
		this().addContent(newContent);
	}

	this(DH5Obj[] newContent) {
		this().addContent(newContent);
	}

	this(DH5 newContent) {
		this().addContent(newContent);
	}

	this(string[] newClasses) {
		this().addClasses(newClasses);
	}

	this(string[] newClasses, string newContent) {
		this(newClasses).addContent(newContent);
	}

	this(string[] newClasses, DH5Obj[] newContent...) {
		this(newClasses).addContent(newContent);
	}

	this(string[] newClasses, DH5Obj[] newContent) {
		this(newClasses).addContent(newContent);
	}

	this(string[] newClasses, DH5 newContent) {
		this(newClasses).addContent(newContent);
	}

	this(STRINGAA newAttributes) {
		this().addAttributes(newAttributes);
	}

	this(STRINGAA newAttributes, string newContent) {
		this(newAttributes).addContent(newContent);
	}

	this(STRINGAA newAttributes, DH5Obj[] newContent...) {
		this(newAttributes).addContent(newContent);
	}

	this(STRINGAA newAttributes, DH5Obj[] newContent) {
		this(newAttributes).addContent(newContent);
	}

	this(STRINGAA newAttributes, DH5 newContent) {
		this(newAttributes).addContent(newContent);
	}

	this(string[] newClasses, STRINGAA newAttributes) {
		this(newClasses).addAttributes(newAttributes);
	}

	this(string[] newClasses, STRINGAA newAttributes, string newContent) {
		this(newClasses, newAttributes).addContent(newContent);
	}

	this(string[] newClasses, STRINGAA newAttributes, DH5Obj[] newContent...) {
		this(newClasses, newAttributes).addContent(newContent);
	}

	this(string[] newClasses, STRINGAA newAttributes, DH5Obj[] newContent) {
		this(newClasses, newAttributes).addContent(newContent);
	}

	this(string[] newClasses, STRINGAA newAttributes, DH5 newContent) {
		this(newClasses, newAttributes).addContent(newContent);
	}

	this(string newId, DH5Obj[] newContent...) {
		this(newContent.dup).id(newId);
	}

	this(string newId, DH5Obj[] newContent) {
		this(newContent).id(newId);
	}

	this(string newId, DH5 newContent) {
		this(newContent).id(newId);
	}

	this(string newId, string[] newClasses) {
		this(newClasses).id(newId);
	}

	this(string newId, string[] newClasses, string newContent) {
		this(newId, newClasses).addContent(newContent);
	}

	this(string newId, string[] newClasses, DH5Obj[] newContent...) {
		this(newId, newClasses).addContent(newContent);
	}

	this(string newId, string[] newClasses, DH5Obj[] newContent) {
		this(newId, newClasses).addContent(newContent);
	}

	this(string newId, string[] newClasses, DH5 newContent) {
		this(newId, newClasses).addContent(newContent);
	}

	this(string newId, STRINGAA newAttributes) {
		this(newAttributes).id(newId);
	}

	this(string newId, STRINGAA newAttributes, string newContent) {
		this(newId, newAttributes).addContent(newContent);
	}

	this(string newId, STRINGAA newAttributes, DH5Obj[] newContent...) {
		this(newId, newAttributes).addContent(newContent);
	}

	this(string newId, STRINGAA newAttributes, DH5Obj[] newContent) {
		this(newId, newAttributes).addContent(newContent);
	}

	this(string newId, STRINGAA newAttributes, DH5 newContent) {
		this(newId, newAttributes).addContent(newContent);
	}

	this(string newId, string[] newClasses, STRINGAA newAttributes) {
		this(newId, newClasses).addAttributes(newAttributes);
	}

	this(string newId, string[] newClasses, STRINGAA newAttributes, string newContent) {
		this(newId, newClasses, newAttributes).addContent(newContent);
	}

	this(string newId, string[] newClasses, STRINGAA newAttributes, DH5Obj[] newContent...) {
		this(newId, newClasses, newAttributes).addContent(newContent);
	}

	this(string newId, string[] newClasses, STRINGAA newAttributes, DH5Obj[] newContent) {
		this(newId, newClasses, newAttributes).addContent(newContent);
	}

	this(string newId, string[] newClasses, STRINGAA newAttributes, DH5 newContent) {
		this(newId, newClasses, newAttributes).addContent(newContent);
	}

	bool initialize() {
		// Clear variables
		_css = CSSRules;
		_classes = null;
		_attributes = null;
		_html = null;
		_js = null;

		return true;
	}

	mixin(OProperty!("bool", "single", "false"));
	mixin(OProperty!("string", "tag"));
	mixin(OProperty!("string", "id"));
	mixin(OProperty!("DH5Obj[]", "html"));

	protected string _js;
	@property string js() {
		return _js;
	}

	O js(this O)(string[] codes...) {
		codes.each!(code => _js ~= c).array;
		return cast(O) this;
	}

/* 	O js(this O)(DJS[] codes...) {
		foreach (c; codes)
			_js ~= c.toString;
		return cast(O) this;
	} */

	// classes - wrapper for class attribute
	// The class attribute is used to set one or more classnames for an element. 
	protected string[] _classes;
	auto classes() {
		return uniq(_classes.sort.array).array;
	}
	// Set classes
	O classes(this O)(string[] values...) {
		this.classes(values.dup);
		return cast(O) this;
	}

	O classes(this O)(string[] values) {
		_classes = uniq( // no doubles
			values
				.filter!(v => v.length > 0) // take only strings with value
				.map!(v => v.strip.split(" ")) // separate class values
				.join // [[]] to []
				
		).array; // back as []
		return cast(O) this;
	}
	// Change classes
	O addClasses(this O)(string[] values...) {
		this.addClasses(values.dup);
		return cast(O) this;
	}

	O addClasses(this O)(string[] values) {
		this.classes(classes ~ values);
		return cast(O) this;
	}

	O removeClasses(this O)(string[] values...) {
		this.removeClasses(values.dup);
		return cast(O) this;
	}

	O removeClasses(this O)(string[] values) {
		foreach (value; values) {
			classes(
				classes.filter!(
					a => value.length > 0 && a != value
			).array
			);
		}
		return cast(O) this;
	}

	O clearClasses(this O)() {
		_classes = null;
		return cast(O) this;
	}

	/// Attributes of HTML element
	mixin(XStringAA!"attributes");
	O addAttributes(this O)(STRINGAA newAttributes) {
		foreach (k, v; newAttributes) {
			_attributes[k] = v;
		}
		return cast(O) this;
	}

	// Work with single Attribute
	string attribute(string name) {
		return (name in _attributes ? _attributes[name] : "");
	}

	O attribute(this O)(string name, string value) {
		_attributes[name] = value;
		return cast(O) this;
	}

	O attribute(this O)(string name, bool value) {
		if (value)
			attribute(name, "true");
		else
			attribute(name, "false");
		return cast(O) this;
	}

	O removeAttribute(this O)(string name) {
		_attributes.remove(name);
		return cast(O) this;
	}

	// Global HTML attributes	
	O accesskey(this O)(string value) {
		if (value.length > 0)
			attributes["accesskey"] = value;
		return cast(O) this;
	}

	O contenteditable(this O)(bool value) {
		if (value)
			attributes["contenteditable"] = "true";
		return cast(O) this;
	}

	O contextmenu(this O)(string value) {
		if (value.length > 0)
			attributes["contextmenu"] = value;
		return cast(O) this;
	}

	O dir(this O)(string value) {
		if (value.length > 0)
			attributes["dir"] = value;
		return cast(O) this;
	}

	O draggable(this O)(bool value) {
		if (value)
			attributes["draggable"] = "true";
		return cast(O) this;
	}

	O dropzone(this O)(string value) {
		if (value.length > 0)
			attributes["dropzone"] = value;
		return cast(O) this;
	}

	O hidden(this O)(bool value) {
		if (value)
			attributes["hidden"] = "true";
		return cast(O) this;
	}

	O lang(this O)(string value) {
		if (value.length > 0)
			attributes["lang"] = value;
		return cast(O) this;
	}

	O spellcheck(this O)(bool value) {
		if (value)
			attributes["spellcheck"] = "true";
		return cast(O) this;
	}

	O style(this O)(string value) {
		if (value.length > 0)
			attributes["style"] = value;
		return cast(O) this;
	}

	O tabindex(this O)(string value) {
		if (value.length > 0)
			attributes["tabindex"] = value;
		return cast(O) this;
	}

	O title(this O)(string value) {
		if (value.length > 0)
			attributes["title"] = value;
		return cast(O) this;
	}

	O translate(this O)(bool value) {
		if (value)
			attributes["translate"] = "true";
		return cast(O) this;
	}

	//	Should be @safe ...bool opEquals(DH5Obj value) { return (this == value); }
	bool opEquals(string html) {
		return (toString == html);
	}

	void opIndexAssign(T)(T value, string key) {
		_attributes[key] = "%s".format(value);
	}

	void opIndexAssign(bool value, string key) {
		_attributes[key] = "%s".format((value) ? "true" : "false");
	}

	void opIndexAssign(T)(T value, string key, T notValue) {
		if (value != notValue)
			_attributes[key] = "%s".format(value);
	}

	void opIndexAssign(bool value, string key, bool notValue) {
		if (value != notValue)
			_attributes[key] = "%s".format((value) ? "true" : "false");
	}

	// TODO correct?
	string opBinary(string op)(string rhs) {
		static if (op == "~")
			return toString ~ rhs;
		else
			return null;
	}

	string opBinary(string op)(DH5Obj rhs) {
		static if (op == "~")
			return toString ~ rhs.toString;
		else
			return null;
	}

	// Get content - Always array of DH5Obj 
	DH5Obj[] content() {
		return _html;
	}

	// Setting content
	O content(this O)(string[] newContent...) {
		this.content(newContent.dup);
		return cast(O) this;
	}

	O content(this O)(string[] newContent) {
		this.content(newContent.map!(c => c.length > 0 ? cast(DH5Obj) H5String(c) : null).array);
		return cast(O) this;
	}

	O content(this O)(DH5Obj[] newContent...) {
		this.content(newContent.dup);
		return cast(O) this;
	}

	O content(this O)(DH5Obj[] newContent) {
		_html = newContent.filter!(a => a !is null).array;
		return cast(O) this;
	}

	O content(this O)(DH5 newContent) {
		_html = newContent.objs;
		return cast(O) this;
	}

	// Changing content
	O addContent(this O)(string[] newContent...) {
		this.addContent(newContent.dup);
		return cast(O) this;
	}

	O addContent(this O)(string[] newContent) {
		this.addContent(newContent.map!(c => c.length > 0 ? cast(DH5Obj) H5String(c) : null).array);
		return cast(O) this;
	}

	O addContent(this O)(DH5Obj[] newContent...) {
		this.addContent(newContent.dup);
		return cast(O) this;
	}

	O addContent(this O)(DH5Obj[] newContent) {
		_html ~= newContent.filter!(a => a !is null).array;
		return cast(O) this;
	}

	O addContent(this O)(DH5 newContent) {
		_html ~= newContent.objs;
		return cast(O) this;
	}

	// Clear content
	O clearContent(this O)() {
		_html = [];
		return cast(O) this;
	}

	DCSSRules _css;
	DCSSRules css() {
		return _css;
	}

	O clearCss(this O)() {
		_css = CSSRules;
		return cast(O) this;
	}

	O css(this O)(string aSelector, string name, string value) {
		return this.css(CSSRule(aSelector, name, value));
	}

	O css(this O)(string aSelector, STRINGAA someDeclarations) {
		return this.css(CSSRule(aSelector, someDeclarations));
	}

	O opCall(this O)(DCSSRule aRule) {
		return this.css(aRule);
	}

	O opCall(this O)(DCSSRules aRules) {
		return this.css(aRules);
	}

	O css(this O)(DCSSRule aRule) {
		_css(aRule);
		return cast(O) this;
	}

	O css(this O)(DCSSRules aRules) {
		_css(aRules);
		return cast(O) this;
	}

	// Using OpCalls is adding, not setting
	O opCall(this O)(string newContent) {
		this.addContent(newContent);
		return cast(O) this;
	}

	O opCall(this O)(DH5Obj[] newContent...) {
		this.addContent(newContent.dup);
		return cast(O) this;
	}

	O opCall(this O)(DH5Obj[] newContent) {
		this.addContent(newContent);
		return cast(O) this;
	}

	O opCall(this O)(string[] newClasses) {
		this.addClasses(newClasses);
		return cast(O) this;
	}

	O opCall(this O)(string[] newClasses, string newContent) {
		this(newClasses).addContent(newContent);
		return cast(O) this;
	}

	O opCall(this O)(string[] newClasses, DH5Obj[] newContent...) {
		this(newClasses).addContent(newContent.dup);
		return cast(O) this;
	}

	O opCall(this O)(string[] newClasses, DH5Obj[] newContent) {
		this(newClasses).addContent(newContent);
		return cast(O) this;
	}

	O opCall(this O)(STRINGAA newAttributes) {
		add(someAttributes);
		return cast(O) this;
	}

	O opCall(this O)(STRINGAA newAttributes, string newContent) {
		this(newAttributes).addContent(newContent);
		return cast(O) this;
	}

	O opCall(this O)(STRINGAA newAttributes, DH5Obj[] newContent...) {
		this(newAttributes).addContent(newContent.dup);
		return cast(O) this;
	}

	O opCall(this O)(STRINGAA newAttributes, DH5Obj[] newContent) {
		this(newAttributes).addContent(newContent);
		return cast(O) this;
	}

	O opCall(this O)(string[] newClasses, STRINGAA newAttributes) {
		this(newClasses).addAttributes(someAttributes);
		return cast(O) this;
	}

	O opCall(this O)(string[] newClasses, STRINGAA newAttributes, string newContent) {
		this(newClasses, newAttributes).addContent(newContent);
		return cast(O) this;
	}

	O opCall(this O)(string[] newClasses, STRINGAA newAttributes, DH5Obj[] newContent...) {
		this(newClasses, newAttributes).addContent(newContent.dup);
		return cast(O) this;
	}

	O opCall(this O)(string[] newClasses, STRINGAA newAttributes, DH5Obj[] newContent) {
		this(newClasses, newAttributes).addContent(newContent);
		return cast(O) this;
	}

	O opCall(this O)(string newId, DH5Obj[] newContent...) {
		this(newContent.dup).id(newId);
		return cast(O) this;
	}

	O opCall(this O)(string newId, DH5Obj[] newContent) {
		this(newContent).id(newId);
		return cast(O) this;
	}

	O opCall(this O)(string newId, string[] newClasses) {
		this(newClasses).id(newId);
		return cast(O) this;
	}

	O opCall(this O)(string newId, string[] newClasses, string newContent) {
		this(newId, newClasses).addContent(newContent);
		return cast(O) this;
	}

	O opCall(this O)(string newId, string[] newClasses, DH5Obj[] newContent...) {
		this(newId, newClasses).addContent(newContent.dup);
		return cast(O) this;
	}

	O opCall(this O)(string newId, string[] newClasses, DH5Obj[] newContent) {
		this(newId, newClasses).addContent(newContent);
		return cast(O) this;
	}

	O opCall(this O)(string newId, STRINGAA newAttributes) {
		this(someAttributes).id(newId);
		return cast(O) this;
	}

	O opCall(this O)(string newId, STRINGAA newAttributes, string newContent) {
		this(newId, newAttributes).addContent(newContent);
		return cast(O) this;
	}

	O opCall(this O)(string newId, STRINGAA newAttributes, DH5Obj[] newContent...) {
		this(newId, newAttributes).addContent(newContent.dup);
		return cast(O) this;
	}

	O opCall(this O)(string newId, STRINGAA newAttributes, DH5Obj[] newContent) {
		this(newId, newAttributes).addContent(newContent);
		return cast(O) this;
	}

	O opCall(this O)(string newId, string[] newClasses, STRINGAA newAttributes) {
		this(newId, newClasses).addAttributes(newAttributes);
		return cast(O) this;
	}

	O opCall(this O)(string newId, string[] newClasses, STRINGAA newAttributes, string newContent) {
		this(newId, newClasses, newAttributes).addContent(newContent);
		return cast(O) this;
	}

	O opCall(this O)(string newId, string[] newClasses, STRINGAA newAttributes, DH5Obj[] newContent...) {
		this(newId, newClasses, newAttributes).addContent(newContent.dup);
		return cast(O) this;
	}

	O opCall(this O)(string newId, string[] newClasses, STRINGAA newAttributes, DH5Obj[] newContent) {
		this(newId, newClasses, newAttributes).addContent(newContent);
		return cast(O) this;
	}

	O opCall(this O)(DH5 newContent) {
		add(newContent.objs);
		return cast(O) this;
	}

/* 	O opCall(this O)(DJS code) {
		this.js(code);
		return cast(O) this;
	} */

	// Shorties for lazy people ;-) - For Best Practice use long names
	O add(this O)(string[] newClasses) {
		this.addClasses(newClasses);
		return cast(O) this;
	}

	O add(this O)(STRINGAA newAttributes) {
		this.addAttributes(someAttributes);
		return cast(O) this;
	}

	O add(this O)(string newContent) {
		this.addContent(newContent);
		return cast(O) this;
	}

	O add(this O)(DH5Obj[] newContent...) {
		this.addContent(newContent.dup);
		return cast(O) this;
	}

	O add(this O)(DH5Obj[] newContent) {
		this.addContent(newContent);
		return cast(O) this;
	}

	O add(this O)(DH5 newContent) {
		this.addContent(newContent);
		return cast(O) this;
	}

	O clear(this O)() {
		_css = CSSRules;
		_html = [];
		_js = "";
		return cast(O) this;
	}

	O clearHtml(this O)() {
		_html = [];
		return cast(O) this;
	}

	O clearJs(this O)() {
		_js = "";
		return cast(O) this;
	}

	/* accesskey - specifies a shortcut key to activate/focus an element. */
	//	mixin(H5Attribute("accesskey"));
	//	// classname (class) - Specifies one or more classnames for an element (refers to a class in a style sheet)
	//	mixin(H5Attribute("classname", "class"));
	//
	//	// contenteditable - Specifies whether the content of an element is editable or not
	//	mixin(H5BoolAttribute("contenteditable"));
	//
	//	// contextmenu -	Specifies a context menu for an element. The context menu appears when a user right-clicks on the element
	//	mixin(H5Attribute("contextmenu"));

	//					data-* 	Used to store custom data private to the page or application
	//						dir 	Specifies the text direction for the content in an element
	//							draggable 	Specifies whether an element is draggable or not
	//								dropzone 	Specifies whether the dragged data is copied, moved, or linked, when dropped
	//								hidden 	Specifies that an element is not yet, or is no longer, relevant
	//								id 	Specifies a unique id for an element
	//									lang 	Specifies the language of the element's content
	//spellcheck 	Specifies whether the element is to have its spelling and grammar checked or not
	//style 	Specifies an inline CSS style for an element
	//tabindex 	Specifies the tabbing order of an element
	//title 	Specifies extra information about an element
	//translate 	Specifies whether the content of an element should be translated or not

	bool isBoolAttribute(string name) {
		/* if (name in [
				"async":true, 
				"autocomplete":true, 
				"autofocus":true, 
				"autoplay":true, 
				"border":true, 
				"challenge":true, 
				"checked":true, 
				"compact":true, 
				"contenteditable":true, 
				"controls":true, 
				"default":true,
				"defer":true,
				"disabled":true,
				"formNoValidate":true,
				"frameborder":true,
				"hidden":true,
				"indeterminate":true,
				"ismap":true,
				"loop":true,
				"multiple":true,
				"muted":true,
				"nohref":true,
				"noresize":true,
				"noshade":true,
				"novalidate":true,
				"nowrap":true,
				"open":true,
				"readonly":true,
				"required":true,
				"reversed":true, 
				"scoped":true,
				"scrolling":true,
				"seamless":true,
				"selected":true,
				"sortable":true,
				"spellcheck":true,
				"translate":true]) { return true; }  */
		return false;
	}

	string attsToHTML() {
		string[] items;
		_attributes.byKey
			.array
			.sort!("a < b")
			.each!((key) {
				switch (key.toLower) {
				case "id":
					this.id(_attributes[key]);
					_attributes.remove(key);
					break;
				case "class":
					this.addClasses(_attributes[key].split(" "));
					_attributes.remove(key);
					break;
				default:
					if (isBoolAttribute(key) || key == _attributes[key])
						items ~= key;
					else
						items ~= key.toLower ~ `="` ~ _attributes[key] ~ `"`;
					break;
				}
			});
		return " " ~ items.join(" ");
	}

	DH5Obj copy() {
		auto result = H5Obj(
			id.dup,
			classes.dup,
			attributes.dup,
			content.dup
		);
		/*     .css(CSSRules.dup)
    .js(this.js.dup);
 */
		return H5Obj;
	}

	DH5Obj clone() {
		auto result = H5Obj(
			id ~ to!string(uniform(1, 10_000)),
			classes.dup,
			attributes.dup,
			content.dup
		);
		/*     .css(CSSRules.dup)
    .js(this.js.dup);
 */
		return H5Obj;
	}

	string renderCSS(STRINGAA bindings = null) {
		if (auto result = _css.toString)
			return htmlDoubleTag("style", result);
		return null;
	}

	string renderHTML(STRINGAA bindings = null) {
		string first;
		string attsHTML = attsToHTML;
		// firstTag
		first ~= "<" ~ _tag;

		if (!_id.isEmpty)
			first ~= ` id="` ~ _id ~ `"`;

		if (!_classes.isEmpty) {
			first ~= ` class="` ~ _classes.unique.sort
				.filter!(cl => cl.length > 0)
				.map!(cl => cl.strip)
				.join(" ") ~ `"`;
		}

		if (!_attributes.isEmpty)
			first ~= attsHTML;
		first ~= ">";

		return _single
			? first : "first ~ _html.toString ~ htmlEndTag(_tag)";
	}

	string renderJS(STRINGAA bindings = null) {
		if (_js.length > 0)
			return htmlDoubleTag("script", this.js);
		return null;
	}

	string render(STRINGAA bindings = null) {
		string result;
		result ~= renderCSS;
		result ~= renderHTML;
		result ~= renderJS;
		result = result.doubleMustache(bindings);

		return result;
	}

	override string toString() {
		return toString(null);
	}

	string toString(STRINGAA parameters) {
		return render(parameters);
	}

	string toJS(string target = null) {
		string result;
		// TODO
		/* result = jsCreateElement(target, _tag, _classes, _attributes); //, _html.toString); // Not finish TODO
		foreach (index, h5; _html) {
			if (h5) {
				auto node = "child" ~ to!string(index);
				if (cast(DH5String) h5)
					result ~= "let " ~ node ~ "=document.createTextNode('" ~ h5.toString.replace("'", "\\'") ~ "');";
				else
					result ~= h5.toJS(node);
				result ~= target ~ ".appendChild(" ~ node ~ ");";
			}
		} */
		return result;
	}

	/// generate HTML in pretty format
	string toPretty(int intendSpace = 0, int step = 2) {
		string result = htmlStartTag(this.tag, null, null, this.attributes).indent(intendSpace);
		if (!single) {
			result ~= "\n";
			result ~= _html.map!(a => a ? a.toPretty(intendSpace + step, step) ~ "\n" : "").join;
			result ~= htmlEndTag(this.tag).indent(intendSpace);
		}
		return result;
	}

	version (test_uim_html) {
		unittest {
			/*
		writeln(H5Obj.tag("div").toPretty);
		writeln("---------");
		writeln(H5Obj.tag("div")(H5Obj.tag("div")).toPretty);
		writeln("---------");
		writeln(H5Obj.tag("div")(H5Obj.tag("div")(H5Obj.tag("div"))).toPretty);
		*/
		}
	}
}

auto H5Obj() {
	return new DH5Obj();
}

auto H5Obj(string newContent) {
	return new DH5Obj(newContent);
}

auto H5Obj(DH5Obj[] newContent...) {
	return new DH5Obj(newContent.dup);
}

auto H5Obj(DH5Obj[] newContent) {
	return new DH5Obj(newContent);
}

auto H5Obj(DH5 newContent) {
	return new DH5Obj(newContent);
}

auto H5Obj(string newId, string[] newClasses) {
	return new DH5Obj(newId, newClasses);
}

auto H5Obj(string newId, string[] newClasses, string newContent) {
	return new DH5Obj(newId, newClasses, newContent);
}

auto H5Obj(string newId, string[] newClasses, DH5Obj[] newContent...) {
	return new DH5Obj(newId, newClasses, newContent.dup);
}

auto H5Obj(string newId, string[] newClasses, DH5Obj[] newContent) {
	return new DH5Obj(newId, newClasses, newContent);
}

auto H5Obj(string newId, string[] newClasses, DH5 newContent) {
	return new DH5Obj(newId, newClasses, newContent);
}

auto H5Obj(string newId, STRINGAA newAttributes) {
	return new DH5Obj(newId, newAttributes);
}

auto H5Obj(string newId, STRINGAA newAttributes, string newContent) {
	return new DH5Obj(newId, newAttributes, newContent);
}

auto H5Obj(string newId, STRINGAA newAttributes, DH5Obj[] newContent...) {
	return new DH5Obj(newId, newAttributes, newContent.dup);
}

auto H5Obj(string newId, STRINGAA newAttributes, DH5Obj[] newContent) {
	return new DH5Obj(newId, newAttributes, newContent);
}

auto H5Obj(string newId, STRINGAA newAttributes, DH5 newContent) {
	return new DH5Obj(newId, newAttributes, newContent);
}

auto H5Obj(string newId, string[] newClasses, STRINGAA newAttributes) {
	return new DH5Obj(newId, newClasses, newAttributes);
}

auto H5Obj(string newId, string[] newClasses, STRINGAA newAttributes, string newContent) {
	return new DH5Obj(newId, newClasses, newAttributes, newContent);
}

auto H5Obj(string newId, string[] newClasses, STRINGAA newAttributes, DH5Obj[] newContent...) {
	return new DH5Obj(newId, newClasses, newAttributes, newContent.dup);
}

auto H5Obj(string newId, string[] newClasses, STRINGAA newAttributes, DH5Obj[] newContent) {
	return new DH5Obj(newId, newClasses, newAttributes, newContent);
}

auto H5Obj(string newId, string[] newClasses, STRINGAA newAttributes, DH5 newContent) {
	return new DH5Obj(newId, newClasses, newAttributes, newContent);
}

auto H5Obj(string[] newClasses) {
	return new DH5Obj(newClasses);
}

auto H5Obj(string[] newClasses, string newContent) {
	return new DH5Obj(newClasses, newContent);
}

auto H5Obj(string[] newClasses, DH5Obj[] newContent...) {
	return new DH5Obj(newClasses, newContent.dup);
}

auto H5Obj(string[] newClasses, DH5Obj[] newContent) {
	return new DH5Obj(newClasses, newContent);
}

auto H5Obj(string[] newClasses, DH5 newContent) {
	return new DH5Obj(newClasses, newContent);
}

auto H5Obj(string[] newClasses, STRINGAA newAttributes) {
	return new DH5Obj(newClasses, newAttributes);
}

auto H5Obj(string[] newClasses, STRINGAA newAttributes, string newContent) {
	return new DH5Obj(newClasses, newAttributes, newContent);
}

auto H5Obj(string[] newClasses, STRINGAA newAttributes, DH5Obj[] newContent...) {
	return new DH5Obj(newClasses, newAttributes, newContent.dup);
}

auto H5Obj(string[] newClasses, STRINGAA newAttributes, DH5Obj[] newContent) {
	return new DH5Obj(newClasses, newAttributes, newContent);
}

auto H5Obj(string[] newClasses, STRINGAA newAttributes, DH5 newContent) {
	return new DH5Obj(newClasses, newAttributes, newContent);
}

auto H5Obj(STRINGAA newAttributes) {
	return new DH5Obj(newAttributes);
}

auto H5Obj(STRINGAA newAttributes, string newContent) {
	return new DH5Obj(newAttributes, newContent);
}

auto H5Obj(STRINGAA newAttributes, DH5Obj[] newContent...) {
	return new DH5Obj(newAttributes, newContent.dup);
}

auto H5Obj(STRINGAA newAttributes, DH5Obj[] newContent) {
	return new DH5Obj(newAttributes, newContent);
}

auto H5Obj(STRINGAA newAttributes, DH5 newContent) {
	return new DH5Obj(newAttributes, newContent);
}

version (test_uim_html) {
	unittest {
		assert(H5Obj);
		assert(H5Obj.tag("testTag").tag == "testTag");
		assert(H5Obj.id("testId").id == "testId");
		assert(H5Obj(["classA", "classB"]).classes == ["classA", "classB"]);

		/* 
	h5 = H5Obj("content");
	assert(H5Obj.id == null);
	assert(H5Obj(["classA", "classB"]).id == null);
	assert(H5Obj(["classA", "classB"], ["a":"x", "b":"y"]).id == null);
	assert(H5Obj(["classA", "classB"], ["a":"x", "b":"y"], "content1").id == null);
	assert(H5Obj(["a":"x", "b":"y"]).id == null);
	assert(H5Obj(["a":"x", "b":"y"], "content1").id == null); */
	}
}

string toPretty(DH5Obj[] objs, int intendSpace = 0, int step = 2) {
	return objs.map!(a => a ? a.toPretty : "").join;
}
