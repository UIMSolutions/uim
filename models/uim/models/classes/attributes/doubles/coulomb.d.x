module uim.models.classes.attributes.doubles.coulomb;

import uim.models;

@safe:

// Unit of measure for electric charge or amount of electricity in coulombs

/* means.measurement.dimension.electricCharge
means.measurement.units.si.coulomb
has.measurement.fundamentalComponent.second
has.measurement.fundamentalComponent.ampere */
class DCoulombAttribute : DDoubleAttribute {
  mixin(AttributeThis!("CoulombAttribute"));

  // Initialization hook method.
  override bool initialize(IData[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    name("coulomb");
    registerPath("coulomb");

    return true;
  }
}

mixin(AttributeCalls!("CoulombAttribute"));

version (test_uim_models) {
  unittest {
    // TODO
  }
}
