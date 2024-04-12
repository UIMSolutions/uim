/***********************************************************************************
*	Copyright: © 2015-2024 Ozan Nurettin Süel (sicherheitsschmiede)                   *
*	License  : Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt] *
*	Author   : Ozan Nurettin Süel (Sicherheitsschmiede)										           * 
***********************************************************************************/
module uim.oop.core.object;

@safe:
import uim.oop;

class Obj {
	this() { init; }

	void init(this O)() {
	}

	mixin(PropertyDefinition!("DPropertyObj[string]", "_properties", "properties")); 
	mixin(PropertyDefinition!("DMethod[string]", "_methods", "methods")); 
	// mixin(PropertyDefinition!("DEvent[string]", "_events", "events")); 
	mixin(PropertyDefinition!("DAggregation[string]", "_aggregations", "aggregations")); 
	mixin(PropertyDefinition!("DOOPAssociation[string]", "_associations", "associations")); 

	string namespace() { return "uim.oop"; }
	string fullname()  { return namespace~"."~this.className; }
	string fullpath()  { return fullname.replace(".", "/"); }

	O add(this O)(PropertyObj aProperty) {
		if (aProperty) {
			if (aProperty.name) _properties[aProperty.name] = aProperty;
		}
		return cast(O)this;
	}
	O add(this O)(Event aEvent) {
		if (aEvent) {
			if (aEvent.name) _events[aEvent.name] = aEvent;
		}
		return cast(O)this;
	}
	O add(this O)(Method aMethod) {
		if (aMethod) {
			if (aMethod.name) _methods[aMethod.name] = aMethod;
		}
		return cast(O)this;
	}
	O add(this O)(Aggregation anAggregation) {
		if (anAggregation) {
			if (anAggregation.name) _aggregations[anAggregation.name] = anAggregation;
		}
		return cast(O)this;
	}
	O add(this O)(Association anAssociation) {
		if (anAssociation) {
			if (anAssociation.name) _associations[anAssociation.name] = anAssociation;
		}
		return cast(O)this;
	}

	O remove(this O)(PropertyObj aProperty) {
		if (aProperty) {
			if (aProperty.name in _properties) _properties.remove(aProperty.name);
			else foreach(k, v; _properties) if (v == aProperty) _properties.remove(aProperty.name); 
		}
		return cast(O)this;
	}

/* 	Json toJson() {
		auto result = Json.emptyObject;
		result["Fullname"] = fullname;
		result["Properties"] = _properties.toJson;
		result["Methods"] = _methods.toJson;
		result["Events"] = _events.toJson;
		result["Aggregations"] = _aggregations.toJson;
		result["Associations"] = _associations.toJson;
		
		return result;
	} */

	override string toString() { return ""; }
}
auto OBJ() { return new Obj; }

/* auto toJson(PropertyObj[string] keyPairs) {
	auto result = Json.emptyObject;
	keyPairs.byKeyValue.each!(kv => result[kv.key] = kv.value.toJson; }
	return result;
} 

auto toJson(Method[string] keyPairs) {
	auto result = Json.emptyObject;
	keyPairs.byKeyValue.each!(kv => result[kv.key] = kv.value.toJson);
	return result;
} 

auto toJson(Event[string] keyPairs) {
	auto result = Json.emptyObject;
	foreach(k, v; keyPairs) { result[k] = v.toJson; }
	return result;
} 
auto toJson(Aggregation[string] keyPairs) {
	auto result = Json.emptyObject;
	foreach(k, v; keyPairs) { result[k] = v.toJson; }
	return result;
} 
auto toJson(Association[string] keyPairs) {
	auto result = Json.emptyObject;
	foreach(k, v; keyPairs) { result[k] = v.toJson; }
	return result;
} 
 */
version(test_uim_oop) { unittest {
	class DTestClass : Obj {
		this() { super(); init;  }
		void init(this O)() {
			foreach (memberName; __traits(allMembers, O)) {
				static if ((memberName != "this") && (memberName != "__ctor") && (memberName != "init")&& (memberName != "factory") && (memberName != "Monitor")) { 
					enum name = "O."~memberName;
					foreach (attr; __traits(getAttributes, mixin(name))) {
						if (typeid(attr) == typeid(OOP_PROPERTY)) { this.add(new DPropertyObj(attr.name, attr.datatype, attr.defaultValue, attr.readOnly)); }
						if (typeid(attr) == typeid(OOP_METHOD)) { this.add(new Method(attr.name)); }
						if (typeid(attr) == typeid(OOP_EVENT)) { this.add(new DEvent(attr.name)); }
						if (typeid(attr) == typeid(OOP_AGGREGATION)) { this.add(new Aggregation(attr.name)); }
						if (typeid(attr) == typeid(OOP_ASSOCIATION)) { this.add(new Association(attr.name)); }
					}
				}
			}
		}
		mixin(OOPPROPERTY!("counter", "int", "0"));
		mixin(OOPPROPERTY!("values", "string[]"));
		mixin(OOPEVENT!("counterEVENT"));
		mixin(OOPMETHOD!("counterM"));
		mixin(OOPAGGREGATION!("counterAGG", "string"));
		mixin(OOPASSOCIATION!("counterASS", "string"));
	}
}}