module uim.models.classes.attributes.doubles.candela;

// candela
// Unit of measure for luminous intensity in candelas

import uim.models;

@safe:
class DCandelaAttribute : DDoubleAttribute {
  mixin(AttributeThis!("Candela"));

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    /* is.dataFormat.floatingPoint
is.dataFormat.big
means.measurement.dimension.luminousIntensity
means.measurement.units.si.candela
has.measurement.fundamentalComponent.candela */

    name("candela");
    registerPath("candela");

    return true;
  }
}

mixin(AttributeCalls!("Candela"));

version (test_uim_models) {
  unittest {
    // TODO
  }
}