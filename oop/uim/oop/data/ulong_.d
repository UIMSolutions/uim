/***********************************************************************************
*	Copyright: ©2015-2024 Ozan Nurettin Süel (sicherheitsschmiede)                   *
*	License  : Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt] *
*	Author   : Ozan Nurettin Süel (Sicherheitsschmiede)										           * 
***********************************************************************************/
module uim.oop.data.ulong_;

import uim.oop;

class DUlongData : DData {
  this() { super(); }
  this(ulong newValue) { this().value(newValue); }

  mixin(TProperty!("ulong", "value"));
  unittest {
    ulong myValue = 42L;
    assert(UlongData(myValue).value == myValue);

    auto data = new DUlongData;
    data.value(myValue);
    assert(data.value == myValue);

    data = new DUlongData;
    data.value = myValue;
    assert(data.value == myValue);
 }
}
auto UlongData() { return new DUlongData; }
auto UlongData(ulong newValue) { return new DUlongData(newValue); }
