/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.oop.classes.data.scalars.scalar;

import uim.oop;

@safe:

class DScalarData : DData {
  this() {
    super();
  }

  // Initialization hook method.
  override bool initialize(IData[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    isScalar(true);

    return true;
  }
}

auto ScalarData() {
  return new DScalarData;
}
