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