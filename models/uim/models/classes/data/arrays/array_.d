/*********************************************************************************************************
	Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.values.arrays.array_;

import uim.models;

@safe:
class DArrayValue : DData {
  mixin(ValueThis!("ArrayValue"));  
  this(DData[] values) {
    this();
    _items = values.dup;
  }

  DData[] _items;

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this
      .isArray(true);
  }

  DArrayValue add(DData[] values...) { 
    this.add(values.dup); 
    return this; }

  DArrayValue add(DData[] values) {
    _items ~= values.dup; 
    return this;
  }
  /// 
  unittest {
    writeln(ArrayValue.add(StringValue("1x"), StringValue("2x")).values.map!(v => v.toString).array);
  }
  
  alias opEquals = DData.opEquals;

  DData[] values() { return _items; }

  override DData copy() {
    return ArrayValue(attribute, toJson);
  }
  override DData dup() {
    return copy;
  }

  override string toString() {
    return "["~_items.map!(item => item.toString).join(",")~"]";
  }
}
mixin(ValueCalls!("ArrayValue")); 
auto ArrayValue(DData[] values) { return new DArrayValue(values); } 

///
unittest {
  auto value = new DArrayValue;
  assert(value.isArray);
}