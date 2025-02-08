/****************************************************************************************************************
* Copyright: © 2018-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.views.classes.widgets.registry;

import uim.views;
@safe:

// An object registry for Widget.
class DWidgetRegistry : DObjectRegistry!DWidget {
}
/* auto WidgetRegistry() { // Singleton
  return DWidgetRegistry.registry;
} */