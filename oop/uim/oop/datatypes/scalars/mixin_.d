module uim.oop.datatypes.scalars.mixin_;

import uim.oop; 
 
 string scalarOpCall(string[] datatypes) {
    return `
override void opCall(IData checkValue) {
  set(checkValue);
}

override void opCall(Json checkValue) {
  set(checkValue);
}

override void opCall(string checkValue) {
  set(checkValue);
}`
        ~ datatypes.map!(datatype => `
void opCall(%s checkValue) { set(checkValue); }`.format(datatype))
        .join();
}

template ScalarOpCall(string[] datatypes) {
    const char[] ScalarOpCall = scalarOpCall(datatypes);
}

string scalarOpEquals(string[] datatypes) {
    return `
override bool opEquals(IData checkValue) {
  return isEqual(checkValue);
}

override bool opEquals(Json checkValue) {
  return isEqual(checkValue);
}

override bool opEquals(string checkValue) {
  return isEqual(checkValue);
}`
        ~ datatypes.map!(datatype => `
bool opEquals(%s checkValue) { return isEqual(checkValue); }`.format(datatype))
        .join();
}

template ScalarOpEquals(string[] datatypes) {
    const char[] ScalarOpEquals = scalarOpEquals(datatypes);
}
