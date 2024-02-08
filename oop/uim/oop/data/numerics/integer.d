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
  this() {
    super();
  }

  this(int newValue) {
    this().value(newValue);
  }

  mixin(TProperty!("int", "value"));
  unittest {
    assert(IntegerData(2) == 2);
    assert(IntegerData(2).value(1) == 1);
  }

  O add(this O)(int opValue) {
    _value += opValue;
    return cast(O) this;
  }

  unittest {
    auto value = new DIntegerData;
    assert(value.add(2) == 2);
    assert(value.add(2).add(2) == 4);
  }

  O add(this O)(DIntegerData opValue) {
    _value += opValue.value;
    return cast(O) this;
  }

  unittest {
    assert(IntegerData(2).add(IntegerData(2)) == 4);
  }

  O sub(this O)(int opValue) {
    _value -= opValue;
    return cast(O) this;
  }

  unittest {
    assert(IntegerData(2).sub(2) == 0);
    assert(IntegerData(2).sub(2).sub(2) == -2);
  }

  O sub(this O)(DIntegerData opValue) {
    _value -= opValue.value;
    return cast(O) this;
  }

  unittest {
    assert(IntegerData(2).sub(IntegerData(2)) == 0);
  }

  O mul(this O)(int opValue) {
    _value *= opValue;
    return cast(O) this;
  }

  unittest {
    assert(IntegerData(2).mul(2) == 4);
  }

  O mul(this O)(DIntegerData opValue) {
    _value *= opValue.value;
    return cast(O) this;
  }
  ///
  unittest {
    assert(IntegerData(2).mul(IntegerData(2)) == 4);
  }

  O div(this O)(int opValue) {
    _value /= opValue;
    return cast(O) this;
  }

  unittest {
    assert(IntegerData(2).div(2) == 1);
  }

  O div(this O)(DIntegerData opValue) {
    _value /= opValue.value;
    return cast(O) this;
  }

  unittest {
    assert(IntegerData(2).div(IntegerData(2)) == 1);
  }

  DIntegerData opBinary(string op)(int opValue) {
    auto result = IntegerData(_value);
    static if (op == "+")
      return result.add(opValue);
    else static if (op == "-")
      return result.sub(opValue);
    else static if (op == "*")
      return result.mul(opValue);
    else static if (op == "/")
      return result.div(opValue);
    else
      static assert(0, "Operator " ~ op ~ " not implemented");
  }

  unittest {
    assert((IntegerData(2) + 2) == 4);
    assert((IntegerData(2) - 2) == 0);
    assert((IntegerData(2) * 2) == 4);
    assert((IntegerData(2) / 2) == 1);
  }

  DIntegerData opBinary(string op)(DIntegerData opValue) {
    auto result = IntegerData(_value);
    static if (op == "+")
      return result.add(opValue);
    else static if (op == "-")
      return result.sub(opValue);
    else static if (op == "*")
      return result.mul(opValue);
    else static if (op == "/")
      return result.div(opValue);
    else
      static assert(0, "Operator " ~ op ~ " not implemented");
  }

  unittest {
    assert((IntegerData(2) + IntegerData(2)) == 4);
    assert((IntegerData(2) - IntegerData(2)) == 0);
    assert((IntegerData(2) * IntegerData(2)) == 4);
    assert((IntegerData(2) / IntegerData(2)) == 1);
  }

  bool opEquals(int check) {
    return _value == check;
  }
  override bool isEqual(IData checkData) { 
    if (auto data = cast(DIntegerData)checkData) {
      return _value == data.value; 
    }
    return false; 
  }

  unittest {
    assert((IntegerData(2) + IntegerData(2)) == 4);
    assert((IntegerData(2) - IntegerData(2)) == 0);
    assert((IntegerData(2) * IntegerData(2)) == 4);
    assert((IntegerData(2) / IntegerData(2)) == 1);
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
