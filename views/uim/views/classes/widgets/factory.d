/****************************************************************************************************************
* Copyright: © 2018-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.views.classes.widgets.factory;

import uim.views;
@safe:

// An object Factory for Widget.
class DWidgetFactory : DFactory!DWidget {

  IWidget widget(string name, Json[string] options) {
    switch(name.lower) {
      case "hidden": return null; 
      default: return null; 
    }
  }
}
auto WidgetFactory() { // Singleton
  return DWidgetFactory.factory;
}