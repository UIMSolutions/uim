/*********************************************************************************************************
	Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
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
  mixin(AttributeThis!("MicroAmpereAttribute"));

  // Initialization hook method.
  override void initialize(IData[string] configSettings = null) {
    super.initialize(configSettings);

    this
      .name("microAmpere")
      .registerPath("microAmpere");
  }
}
mixin(AttributeCalls!("MicroAmpereAttribute"));

version(test_uim_models) { unittest {
    // TODO
  }
}