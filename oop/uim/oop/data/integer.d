/***********************************************************************************
*	Copyright: ©2015 - 2024 Ozan Nurettin Süel (sicherheitsschmiede)                   *
*	License  : Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt] *
*	Author   : Ozan Nurettin Süel (Sicherheitsschmiede)										           * 
***********************************************************************************/
module uim.oop.data.integer;

import uim.oop;

/// Integer class wraps a value of the primitive type int in an object. 
class DInteger : DDatatype {
  this() { super(); }
  this(int newValue) { this(); this.value(newValue); }

  mixin(OProperty!("int", "value"));
  version(test_uim_oop) { unittest { 
    assert(Integer(2) == 2);
    assert(Integer(2).value(1) == 1);
  }}

  O add(this O)(int opValue) { _value += opValue; return cast(O)this; }
  version(test_uim_oop) { unittest {
    auto value = new DInteger;
    assert(value.add(2) == 2);
    assert(value.add(2).add(2) == 4);
  }}

  O add(this O)(DInteger opValue) { _value += opValue.value; return cast(O)this; }
  version(test_uim_oop) { unittest {
		  assert(Integer(2).add(Integer(2)) == 4);
  }}

  O sub(this O)(int opValue) { _value -= opValue; return cast(O)this; }
  version(test_uim_oop) { unittest {
      assert(Integer(2).sub(2) == 0);
      assert(Integer(2).sub(2).sub(2) == -2);
  }}

  O sub(this O)(DInteger opValue) { _value -= opValue.value; return cast(O)this; }
  version(test_uim_oop) { unittest {
    assert(Integer(2).sub(Integer(2)) == 0);
  }}

  O mul(this O)(int opValue) { _value *= opValue; return cast(O)this; }
  version(test_uim_oop) { unittest {
      assert(Integer(2).mul(2) == 4);
  }}

  O mul(this O)(DInteger opValue) { _value *= opValue.value; return cast(O)this; }
  version(test_uim_oop) { unittest { 
    assert(Integer(2).mul(Integer(2)) == 4);
  }}

  O div(this O)(int opValue) { _value /= opValue; return cast(O)this; }
  version(test_uim_oop) { unittest { 
    assert(Integer(2).div(2) == 1);
  }}

  O div(this O)(DInteger opValue) { _value /= opValue.value; return cast(O)this; }
  version(test_uim_oop) { unittest { 
    assert(Integer(2).div(Integer(2)) == 1);
  }}

  DInteger opBinary(string op)(int opValue)
  {
      auto result = Integer(_value);
      static if (op == "+") return result.add(opValue);
      else static if (op == "-") return result.sub(opValue);
      else static if (op == "*") return result.mul(opValue);
      else static if (op == "/") return result.div(opValue);
      else static assert(0, "Operator "~op~" not implemented");
  }
  version(test_uim_oop) { unittest { 
    assert((Integer(2) + 2) == 4);
    assert((Integer(2) - 2) == 0);
    assert((Integer(2) * 2) == 4);
    assert((Integer(2) / 2) == 1);
  }}

  DInteger opBinary(string op)(DInteger opValue)
  {
      auto result = Integer(_value);
      static if (op == "+") return result.add(opValue);
      else static if (op == "-") return result.sub(opValue);
      else static if (op == "*") return result.mul(opValue);
      else static if (op == "/") return result.div(opValue);
      else static assert(0, "Operator "~op~" not implemented");
  }
  version(test_uim_oop) { unittest { 
    assert((Integer(2) + Integer(2)) == 4);
    assert((Integer(2) - Integer(2)) == 0);
    assert((Integer(2) * Integer(2)) == 4);
    assert((Integer(2) / Integer(2)) == 1);
  }}

  bool opEquals(int check) { return _value == check; }
//  bool opEquals(DInteger check) { return _value == check.value; }

  override string toString() {
    return to!string(_value);
  }
  version(test_uim_oop) { unittest { 
    assert(Integer(2).toString == "2");
  }}
}
auto Integer() { return new DInteger; }
auto Integer(int value) { return new DInteger(value); }

   version(test_uim_oop) { unittest {
    assert(Integer(1) == 1);
  }
}