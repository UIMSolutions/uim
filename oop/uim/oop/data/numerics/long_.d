/***********************************************************************************
*	Copyright: ©2015-2024 Ozan Nurettin Süel (sicherheitsschmiede)                   *
*	License  : Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt] *
*	Author   : Ozan Nurettin Süel (Sicherheitsschmiede)										           * 
***********************************************************************************/
module uim.oop.data.long_;

import uim.oop;

class DLongData : DData {
  this() { super(); }
  this(long newValue) { this().value(newValue); }

  mixin(TProperty!("long", "value"));
  unittest {
    long myValue = 42L;
    assert(LongData(myValue).value == myValue);

    auto data = new DLongData;
    data.value(myValue);
    assert(data.value == myValue);

    data = new DLongData;
    data.value = myValue;
    assert(data.value == myValue);
 }
}
auto LongData() { return new DLongData; }
auto LongData(long newValue) { return new DLongData(newValue); }
