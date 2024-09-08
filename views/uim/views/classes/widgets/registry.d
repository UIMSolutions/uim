module uim.views.classes.widgets.registry;

import uim.views;
@safe:

// An object registry for Widget.
class DWidgetRegistry : DObjectRegistry!DWidget {
}
auto WidgetRegistry() { // Singleton
  return DWidgetRegistry.registry;
}