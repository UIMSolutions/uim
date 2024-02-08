/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.doubles.amperes.milli;

/* Unit of capacitance, equivalent to 10E-3 amperes

Inheritance
any <- float <- double <- ampere <- milliampere
Traits
is.dataFormat.floatingPoint
is.dataFormat.big
means.measurement.dimension.electricCurrent
means.measurement.units.si.ampere
has.measurement.fundamentalComponent.ampere
means.measurement.prefix.milli */

import uim.models;

@safe:
class DMilliAmpereAttribute : DAmpereAttribute {
  mixin(AttributeThis!("MilliAmpereAttribute"));

  // Initialization hook method.
  override bool initialize(IData[string] configData = null) {
    super.initialize(configData);

    this
      .name("milliAmpere")
      .registerPath("milliAmpere");
  }
}
mixin(AttributeCalls!("MilliAmpereAttribute"));

version(test_uim_models) { unittest {
    // TODO
  }
}