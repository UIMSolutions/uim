module uim.models.classes.attributes.doubles.celsius;

// Unit of measure for temperature in degrees celsius
/* is.dataFormat.floatingPoint
is.dataFormat.big
means.measurement.dimension.temperature
means.measurement.units.si.celsius
has.measurement.fundamentalComponent.kelvin */

import uim.models;

@safe:
class DCelsiusAttribute : DDoubleAttribute {
  mixin(AttributeThis!("Celsius"));

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) { return false; }

    name("celsius");
    registerPath("celsius");

    return true;
  }
}
mixin(AttributeCalls!("Celsius"));

version(test_uim_models) { unittest {
    // TODO
  }
}