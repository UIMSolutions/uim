/***********************************************************************************
*	Copyright: ©2015-2024 Ozan Nurettin Süel (sicherheitsschmiede)                   *
*	License  : Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt] *
*	Author   : Ozan Nurettin Süel (Sicherheitsschmiede)										           * 
***********************************************************************************/
module uim.oop.core.element;

import uim.oop;

@safe:

class DOOPElement : ICloneable {
  this() {
  }

  this(string newName) {
    this();
    this.name = newName;
  }

  string namespace() {
    return "uim.oop";
  }

  string fullname() {
    return namespace ~ "." ~ this.className;
  }

  string fullpath() {
    return fullname.replace(".", "/");
  }

  mixin(PropertyDefinition!("string", "_name", "name", true, true));

  /* 	Bson toBson() {
		Bson result = Bson.emptyObject;

		return result;
	}*/

  mixin CloneableTemplate;

  Json toJson() {
    auto result = Json.emptyObject;
    result["namespace"] = namespace;
    result["classname"] = this.className;
    result["fullname"] = fullname;
    result["namespace"] = fullpath;
    return result;
  }

  override string toString() {
    return `{"name":"%s"}`.format(_name);
  }
}

auto OOPElement() {
  return new DOOPElement;
}

auto OOPElement(string aName) {
  return new DOOPElement(aName);
}

unittest {
  auto element = new DOOPElement;
  assert(element.namespace == "uim.oop");
  assert(element.className == "DOOPElement");
  assert(element.fullname == "uim.oop.DOOPElement");
  assert(element.fullpath == "uim/oop/DOOPElement");

  assert(OOPElement("test").name == "test");
  assert(OOPElement("test").name("test2").name == "test2");

  assert(element.create.className == "DOOPElement");
  assert(element.clone.className == "DOOPElement"); 
  assert(element.clone(Json(null)).className == "DOOPElement"); 
}
