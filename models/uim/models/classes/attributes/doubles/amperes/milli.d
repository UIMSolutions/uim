/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
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
  mixin(AttributeThis!("MilliAmpere"));

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    registerPath("attributes.milliampere");

    return true;
  }
}

mixin(AttributeCalls!("MilliAmpere"));

unittest {
  // TODO
}
