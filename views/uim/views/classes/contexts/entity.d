/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.views.classes.contexts.entity;

import uim.views;
@safe:

version (test_uim_views) {
  unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
  }
}

class DEntityContext : DFormContext {
  mixin(ContextThis!("Entity"));

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    return true;
  }
}

unittest {
  auto context = new DEntityContext;
  assert(context !is null);
}
