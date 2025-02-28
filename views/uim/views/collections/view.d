/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.views.collections.view;

import uim.views;
@safe:

version (test_uim_views) {
  unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
  }
} 


// An object Collection for Widget.
class DWidgetCollection : DCollection!DWidget {
}

auto WidgetCollection() {
  return new DWidgetCollection;
}

unittest {
  assert(WidgetCollection);

  auto widgets = WidgetCollection;
}