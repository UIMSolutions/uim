/***********************************************************************************
*	Copyright: ©2015-2024 Ozan Nurettin Süel (sicherheitsschmiede)                   *
*	License  : Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt] *
*	Author   : Ozan Nurettin Süel (Sicherheitsschmiede)										           * 
***********************************************************************************/
module uim.oop.core.element;

import uim.oop;
@safe:

class DOOPElement {
	this() {}
	this(string newName) { this();
this.name = newName; }

	string namespace() { return "uim.oop"; }
	string classname() { return "Element"; }
	string fullname()  { return namespace~"."~classname; }
	string fullpath()  { return fullname.replace(".", "/"); }

	mixin(PropertyDefinition!("string", "_name", "name", true, true));

/* 	Bson toBson() {
		Bson result = Bson.emptyObject;

		return result;
	}*/
	Json toJson() {
		auto result = Json.emptyObject;
result["namespace"] = namespace;	
result["classname"] = classname;
		result["fullname"] = fullname;
		result["namespace"] = fullpath;
		return result;
	}
 
	override string toString() {
		return `{"name":"%s"}`.format(_name);
	}
}
auto OOPElement() { return new DOOPElement; }
auto OOPElement(string aName) { return new DOOPElement(aName); }

unittest {
auto element = new DOOPElement;
		assert(element.namespace == "uim.oop");
		assert(element.classname == "Element");
		assert(element.fullname == "uim.oop.Element");
		assert(element.fullpath == "uim/oop/Element");

		assert(OOPElement("test").name == "test");
		assert(OOPElement("test").name("test2").name == "test2");
}