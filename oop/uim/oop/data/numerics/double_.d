/***********************************************************************************
*	Copyright: ©2015-2024 Ozan Nurettin Süel (sicherheitsschmiede)                   *
*	License  : Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt] *
*	Author   : Ozan Nurettin Süel (Sicherheitsschmiede)										           * 
***********************************************************************************/
module uim.oop.data.double_;

import uim.oop;

class DDoubleData : DData {
  this() { super(); }
  this(double newValue) { this().value(newValue); }

  mixin(TProperty!("double", "value"));
  unittest {
    double myValue = 42.0;
    assert(DoubleData(myValue).value == myValue);

    auto data = new DDoubleData;
    data.value(myValue);
    assert(data.value == myValue);

    data = new DDoubleData;
    data.value = myValue;
    assert(data.value == myValue);
 }
}
auto DoubleData() { return new DDoubleData; }
auto DoubleData(double newValue) { return new DDoubleData(newValue); }
