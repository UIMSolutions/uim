module uim.models.classes.attributes.doubles.volts.mega;

/* Unit of power, equivalent to 10E6 volts

Inheritance
any <- float <- double <- volt <- megavolt
Traits
is.dataFormat.floatingPoint
is.dataFormat.big
means.measurement.dimension.electromotiveForce
means.measurement.units.si.volt
has.measurement.fundamentalComponent.kilogram
has.measurement.fundamentalComponent.meter
has.measurement.fundamentalComponent.second
has.measurement.fundamentalComponent.ampere
means.measurement.prefix.mega */

import uim.models;

@safe:
class DMegaVoltAttribute : DVoltAttribute {
  mixin(AttributeThis!("MegaVoltAttribute"));

  // Initialization hook method.
  override bool initialize(IData[string] configData = null) {
    super.initialize(configData);

    this
      .name("megavolt")
      .registerPath("megavolt");
  }
}
mixin(AttributeCalls!("MegaVoltAttribute"));

version(test_uim_models) { unittest {
    // TODO
  }
}