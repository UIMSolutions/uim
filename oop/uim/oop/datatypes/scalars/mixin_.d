module uim.oop.datatypes.scalars.mixin_;

import uim.oop; 
 
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
