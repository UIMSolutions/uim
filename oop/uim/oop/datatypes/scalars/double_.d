/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.data.scalars.double_;

import uim.models;

@safe:
class DDoubleData : DData {
  mixin(DataThis!("DoubleData", "double"));

  // Initialization hook method.
  override bool initialize(IData[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    isDouble(true);

    return true;
  }

  // #region Getter & Setter
    double get() {
      return _value;
    }
    void set(double newValue) {
      _value = newValue;
    }
    mixin(DataGetSetTemplate!("0.0", "double"));
    unittest {
      /* auto data = DoubleData(0.0);
      data.set(1.1);
      writeln(data); */
    }
  // #endregion Getter & Setter
  ///
  unittest {
    /* double myValue = 42.0;
    auto data = DoubleData(myValue);
    assert(data.get == myValue);

    data = new DDoubleData;
    data.set(myValue);
    assert(data.get == myValue);

    data = new DDoubleData;
    data.value = myValue;
    assert(data.get == myValue); */ 
  }


  // #region equal
    mixin(ScalarDataOpEquals!("double"));

    override bool isEqual(IData[string] checkData) {
      return false;
    }

    override bool isEqual(IData checkData) {
      if (checkData.isNull || key != checkData.key) {
        return false;
      }
      if (auto data = cast(DDoubleData) checkData) {
        return (get == data.get);
      }
      return false;
    }

    override bool isEqual(Json checkValue) {
      if (checkValue.isNull || !checkValue.isFloat) {
        return false;
      }

      return (get == checkValue.get!double);
    }

    override bool isEqual(string checkValue) {
      return (get == to!double(checkValue));
    }

    bool isEqual(double checkValue) {
      return (get == checkValue);
    }
    ///
    unittest {
      auto data100 = DoubleData;
      data100.set(100.0);
      auto dataIs100 = DoubleData;
      dataIs100.set(100.0);
      auto dataNot100 = DoubleData;
      dataNot100.set(400.0);
      // assert(data100 == dataIs100);
      assert(data100 == Json(100.0));
      assert(data100 == "100.0");
      assert(data100 == 100.0);

      // assert(data100 != dataNot100);
      assert(data100 != Json(10.0));
      assert(data100 != "10.0");
      assert(data100 != 10.0);
    }
  // #endregion equal

  override IData clone() {
    return DoubleData; // TODO (attribute, toJson);
  }

  double toDouble() {
    if (isNull)
      return 0;
    return _value;
  }

  mixin DataConvertTemplate;
}

mixin(DataCalls!("DoubleData", "double"));

unittest {
  /*alias Alias = ;
  
  assert(DoubleData("100").toDouble == 100);
  assert(DoubleData(Json(100)).toDouble == 100);
  assert(DoubleData("200").toDouble != 100);
  assert(DoubleData(Json(200)).toDouble != 100);

  assert(DoubleData("100").toString == "100");
  assert(DoubleData(Json(100)).toString == "100");
  assert(DoubleData("200").toString != "100");
  assert(DoubleData(Json(200)).toString != "100");

  assert(DoubleData("100").toJson == Json(100));
  assert(DoubleData(Json(100)).toJson == Json(100));
  assert(DoubleData("200").toJson != Json(100));
  assert(DoubleData(Json(200)).toJson != Json(100)); 
  */
}

///
unittest {
  /* auto boolValue = new DBoolData(true);
  assert(boolValue == true);
  assert(boolValue != false); */
}
