module uim.views.classes.widgets.factory;

import uim.views;
@safe:

// An object Factory for Widget.
class DWidgetFactory : DFactory!DWidget {
}
auto WidgetFactory() { // Singleton
  return DWidgetFactory.factory;
}