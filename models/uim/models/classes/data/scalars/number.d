/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
module uim.models.classes.data.scalars.number;

import uim.models;

@safe:
class DNumberData : DScalarData {
  mixin(DataThis!("Number"));
  // mixin TDataConvert;
  
  this(double newValue) {
    this().set(newValue);
  }

  this(double newValue, Json[string] initData = null) {
    this(initData).set(newValue);
  }

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    isNumber(true);
    typeName("number");
    set(0.0);

    return true;
  }

  // #region value
    protected double _value;
    @property void value(double newValue) {
        _value = newValue;
    }
    @property double value() {
      return _value;
    }
  // #endregion value

  // #region Getter
    override bool getBoolean() {
      return value > 0; 
    }

    override long getLong() {
      return to!long(value);
    }

    override double getDouble() {
      return to!double(value);
    }

    override string getString() {
      return to!string(value);
    }
  // #region Getter
  // #region operators
  void add(IData opValue) {
    add(opValue.getDouble);
  }

  void add(double opValue) {
    set(getDouble + opValue);
  }

  void sub(IData opValue) {
    sub(opValue.getDouble);
  }

  void sub(double opValue) {
    set(getDouble - opValue);
  }

  void mul(IData opValue) {
    mul(opValue.getDouble);
  }

  void mul(double opValue) {
    set(getDouble * opValue);
  }

  void div(IData opValue) {
    div(opValue.getDouble);
  }

  void div(double opValue) {
    // TODO Catch case opValue = 0
    set(getDouble / opValue);
  }

  DIntegerData opBinary(string op)(double opValue) {
    auto result = IntegerData(_value);

    static if (op == "+")
      add(opValue);
    else static if (op == "-")
      sub(opValue);
    else static if (op == "*")
      mul(opValue);
    else static if (op == "/")
      div(opValue);
    else
      static assert(0, "Operator " ~ op ~ " not implemented");

    return result;
  }

  DIntegerData opBinary(string op)(DIntegerData opValue) {
    auto result = IntegerData;

    result.set(get);
    static if (op == "+")
      add(opValue);
    else static if (op == "-")
      sub(opValue);
    else static if (op == "*")
      mul(opValue);
    else static if (op == "/")
      div(opValue);
    else
      static assert(0, "Operator " ~ op ~ " not implemented");

    return result;
  }
  // #endregion operators

  override IData clone() {
    return NumberData(getDouble);
  }

/*   double toDouble() {
    if (isNull)
      return 0;
    return _value;
  } */


}

mixin(DataCalls!("Number"));
auto NumberData(double newValue, Json[string] initData = null) { return new DNumberData(newValue, initData); }


unittest {
  /*alias Alias = ;
  
// TODO assert(NumberData("100").toDouble == 100);
// TODO assert(NumberData(Json(100)).toDouble == 100);
// TODO assert(NumberData("200").toDouble != 100);
// TODO assert(NumberData(Json(200)).toDouble != 100);

// TODO assert(NumberData("100").toString == "100");
// TODO assert(NumberData(Json(100)).toString == "100");
// TODO assert(NumberData("200").toString != "100");
// TODO assert(NumberData(Json(200)).toString != "100");

// TODO assert(NumberData("100").toJson == Json(100));
// TODO assert(NumberData(Json(100)).toJson == Json(100));
// TODO assert(NumberData("200").toJson != Json(100));
// TODO assert(NumberData(Json(200)).toJson != Json(100)); 
  */
}

///
unittest {
  /* auto boolValue = new DBooleanData(true);
// TODO assert(boolValue == true);
// TODO assert(boolValue != false); */
}
