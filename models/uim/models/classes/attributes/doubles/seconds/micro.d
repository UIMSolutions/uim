/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.models.classes.attributes.doubles.seconds.micro;

/* Unit of measure for time in 10E-6 microseconds

any <- float <- double <- microsecond <- microMicroSecond
 
is.dataFormat.floatingPoint
is.dataFormat.big
means.measurement.dimension.time
means.measurement.units.si.microsecond
has.measurement.fundamentalComponent.microsecond
means.measurement.duration.microseconds
means.measurement.prefix.micro */

import uim.models;

@safe:
class DMicroSecondAttribute : DSecondAttribute {
  mixin(AttributeThis!("MicroSecond"));

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    name("microsecond");
    registerPath("microsecond");

    return true;
  }
}

mixin(AttributeCalls!("MicroSecond"));

unittest {
  assert(MicroSecondAttribute);
}
