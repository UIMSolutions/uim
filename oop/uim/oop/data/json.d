/***********************************************************************************
*	Copyright: ©2015-2024 Ozan Nurettin Süel (sicherheitsschmiede)                   *
*	License  : Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt] *
*	Author   : Ozan Nurettin Süel (Sicherheitsschmiede)										           * 
***********************************************************************************/
module oop.uim.oop.data.json;

import uim.oop;

class DJsonData : DData {
  this() { super(); }
  this(json newValue) { this().value(newValue); }

  mixin(TProperty!("Json", "value"));
  unittest {
    json myValue = true;
    assert(JsonData(myValue).value == myValue);

    auto data = new DJsonData;
    data.value(myValue);
    assert(data.value == myValue);

    data = JsonData(false);
    data.value = myValue;
    assert(data.value == myValue);
 }
}
auto JsonData() { return new DJsonData; }
auto JsonData(json newValue) { return new DJsonData(newValue); }
