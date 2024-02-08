/***********************************************************************************
*	Copyright: ©2015-2024 Ozan Nurettin Süel (sicherheitsschmiede)                   *
*	License  : Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt] *
*	Author   : Ozan Nurettin Süel (Sicherheitsschmiede)										           * 
***********************************************************************************/
module oop.uim.oop.data.scalars.boolean;

import uim.oop;

class DBoolData : DData {
  this() { super(); }
  this(bool newValue) { this().value(newValue); }

  mixin(TProperty!("bool", "value"));
  unittest {
    bool myValue = true;
    assert(BoolData(myValue).value == myValue);

    auto data = new DBoolData;
    data.value(myValue);
    assert(data.value == myValue);

    data = BoolData(false);
    data.value = myValue;
    assert(data.value == myValue);
 }
}
auto BoolData() { return new DBoolData; }
auto BoolData(bool newValue) { return new DBoolData(newValue); }
