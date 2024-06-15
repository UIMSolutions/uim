/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
module uim.models.classes.data.scalars.boolean;

import uim.models;

@safe:
class DBooleanData : DScalarData {
  mixin(DataThis!("Boolean"));
  mixin TDataConvert;

  this(bool newValue) {
    this().set(newValue);
  }

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    isBoolean(true);
    typeName("boolean");

    return true;
  }



  // #region opCmp
 /*  alias opCmp = Object.opCmp;
  int opCmp(bool valueToCompare) {
    if (value < valueToCompare)
      return -1;

    return value > valueToCompare
      ? 1 : 0;
  }
  ///
  unittest {
    auto valueA = true.toJson;
    auto valueB = false.toJson;
    // todo assert(valueA > false);
    // todo assert(valueB < true);
  }

  int opCmp(DBooleanData aValue) {
    return aValue
      ? opCmp(aValue.value()) : -1;
  } */
  // #endregion opCmp

  // #region clone
 override IData clone() {
    return BooleanData(getBool);
  } 
  // #endregion clone
}

mixin(DataCalls!("Boolean"));
auto BooleanData(bool newValue) {
  return new DBooleanData(newValue);
} 

unittest {
  // todo assert(true.toJson == true);
  // todo assert(false.toJson != true);
  /* // todo assert(BooleanData.value(true) == true);
    // todo assert(BooleanData.set(true.toJson) == true);
    // todo assert(BooleanData.value(false) != true);
    // todo assert(BooleanData.set(false.toJson) != true); */

  auto BooleanData = BooleanData;

  BooleanData.set("true");
  // todo assert(BooleanData.value());

  BooleanData.set("false");
  // todo assert(!BooleanData.value());

  BooleanData.set("on");
  // todo assert(BooleanData.value());

  BooleanData.set("off");
  // todo assert(!BooleanData.value());

  BooleanData.set("1");
  // todo assert(BooleanData.value());

  BooleanData.set("0");
  // todo assert(!BooleanData.value());

  BooleanData.value(true);
  // todo assert(BooleanData.fromString(BooleanData.toString).value());
  // todo assert(BooleanData.fromJson(BooleanData.toJson).value());

  BooleanData.value(false);
  // todo assert(!BooleanData.fromString(BooleanData.toString).value());
  // todo assert(!BooleanData.fromJson(BooleanData.toJson).value());
}

/* booleanean

Optional<DynamicConstantDesc<Booleanean>>
describeConstable()
Returns an Optional containing the nominal descriptor for this instance.
booleanean
equals(Object obj)
Returns true if and only if the argument is not null and is a Booleanean object that represents the same booleanean value as this object.
static booleanean
getBooleanean(String name)
Returns true if and only if the system property named by the argument exists and is equal to, ignoring case, the string "true".
int
hashCode()
Returns a hash code for this Booleanean object.
static int
hashCode(booleanean value)
Returns a hash code for a booleanean value; compatible with Booleanean.hashCode().
static booleanean
logicalAnd(booleanean a, booleanean b)
Returns the result of applying the logical AND operator to the specified booleanean operands.
static booleanean
logicalOr(booleanean a, booleanean b)
Returns the result of applying the logical OR operator to the specified booleanean operands.
static booleanean
logicalXor(booleanean a, booleanean b)
Returns the result of applying the logical XOR operator to the specified booleanean operands.
static booleanean
parseBooleanean(String s)
Parses the string argument as a booleanean.
String
toString()
Returns a String object representing this Booleanean's value.
static String
toString(booleanean b)
Returns a String object representing the specified booleanean.
static Booleanean
valueOf(booleanean b)
Returns a Booleanean instance representing the specified booleanean value.
static Booleanean
valueOf(String s)
Returns a Booleanean with a value represented by the specified string.
 */
