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
  mixin(AttributeThis!("CelsiusAttribute"));

  // Initialization hook method.
  override bool initialize(IData[string] configSettings = null) {
    super.initialize(configSettings);

    this
      .name("celsius")
      .registerPath("celsius");
  }
}
mixin(AttributeCalls!("CelsiusAttribute"));

version(test_uim_models) { unittest {
    // TODO
  }
}