/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.doubles.amperes.micro;

/* Unit of capacitance, equivalent to 10E-6 amperes

Inheritance
any <- float <- double <- ampere <- microampere
Traits
is.dataFormat.floatingPoint
is.dataFormat.big
means.measurement.dimension.electricCurrent
means.measurement.units.si.ampere
has.measurement.fundamentalComponent.ampere
means.measurement.prefix.micro */

import uim.models;

@safe:
class DMicroAmpereAttribute : DAmpereAttribute {
  mixin(AttributeThis!("MicroAmpere"));

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    registerPath("attributes.microampere");

    return true;
  }
}

mixin(AttributeCalls!("MicroAmpere"));

  unittest {
    // TODO
  }
