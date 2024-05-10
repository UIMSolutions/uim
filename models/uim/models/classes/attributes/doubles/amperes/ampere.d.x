/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.doubles.amperes.ampere;

// Unit of measure for electric current in amperes
/** 
 * is.dataFormat.floatingPoint
is.dataFormat.big
means.measurement.dimension.electricCurrent
means.measurement.units.si.ampere
has.measurement.fundamentalComponent.ampere
 */

import uim.models;

@safe:
class DAmpereAttribute : DDoubleAttribute {
  mixin(AttributeThis!("Ampere"));

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    name("ampere");
    registerPath("ampere");

    return true;
  }
}

mixin(AttributeCalls!("Ampere"));

version (test_uim_models) {
  unittest {
    // TODO
  }
}
