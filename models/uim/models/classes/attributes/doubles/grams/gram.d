/*********************************************************************************************************
  Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.doubles.grams.gram;

/* Unit of measure for mass in grams

Inheritance
any <- float <- double <- gram
Traits
is.dataFormat.floatingPoint
is.dataFormat.big
means.measurement.dimension.mass
means.measurement.units.si.gram
has.measurement.fundamentalComponent.gram */

import uim.models;

@safe:
class DGramAttribute : DDoubleAttribute {
  mixin(AttributeThis!("GramAttribute"));

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this
      .name("gram")
      .registerPath("gram");
  }
}
mixin(AttributeCalls!("GramAttribute"));

version(test_uim_models) { unittest {
    // TODO
  }
}