module uim.views.classes.widgets.collection;

import uim.views;
@safe:

// An object Collection for Widget.
class DWidgetCollection : DCollection!DWidget {
}
auto WidgetCollection() { // Singleton
  return new DWidgetCollection;
}