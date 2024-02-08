/***********************************************************************************
*	Copyright: ©2015-2024 Ozan Nurettin Süel (sicherheitsschmiede)                   *
*	License  : Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt] *
*	Author   : Ozan Nurettin Süel (Sicherheitsschmiede)										           * 
***********************************************************************************/
module uim.oop.data.integer;

import uim.oop;

@safe:
/// IntegerData class wraps a value of the primitive type int in an object. 
class DIntegerData : DData {


  unittest {
    assert(IntegerData(2).add(IntegerData(2)) == 4);
  }

  

  

  override string toString() {
    return to!string(_value);
  }

  unittest {
    assert(IntegerData(2).toString == "2");
  }
}

auto IntegerData() {
  return new DIntegerData;
}

auto IntegerData(int value) {
  return new DIntegerData(value);
}

unittest {
  assert(IntegerData(1) == 1);
}
