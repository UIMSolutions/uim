/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.oop.datatypes.scalars.scalar;

import uim.oop;

@safe:

class DScalarData : DData {
  mixin(DataThis!("Scalar"));
/*
  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    isScalar(true);

    return true;
  }

  override size_t length() {
    return 1;
  }

  override bool isEqual(IData[string] checkData) {
    return false;
  } */
}

mixin(DataCalls!("Scalar"));