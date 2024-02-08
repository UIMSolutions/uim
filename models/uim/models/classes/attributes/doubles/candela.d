module uim.models.classes.attributes.doubles.candela;

// candela
// Unit of measure for luminous intensity in candelas

import uim.models;

@safe:
class DCandelaAttribute : DDoubleAttribute {
  mixin(AttributeThis!("CandelaAttribute"));

  // Initialization hook method.
  override bool initialize(IData[string] configData = null) {
    super.initialize(configData);

/* is.dataFormat.floatingPoint
is.dataFormat.big
means.measurement.dimension.luminousIntensity
means.measurement.units.si.candela
has.measurement.fundamentalComponent.candela */

    this
      .name("candela")
      .registerPath("candela");
  }
}
mixin(AttributeCalls!("CandelaAttribute"));

version(test_uim_models) { unittest {
    // TODO
  }
}