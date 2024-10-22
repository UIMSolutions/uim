/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.views.classes.widgets.locator;

import uim.views;

@safe:

unittest {
  writeln("-----  ", __MODULE__, "\t  -----");
}

/**
 * A registry/factory for input widgets.
 *
 * Can be used by helpers/view logic to build form widgets
 * and other HTML widgets.
 *
 * This class handles the mapping between names and concrete classes.
 * It also has a basic name based dependency resolver that allows
 * widgets to depend on each other.
 *
 * Each widget should expect a StringContents instance as their first
 * argument. All other dependencies will be included after.
 *
 * Widgets can ask for the current view by using the `_view` widget.
 */
class DWidgetLocator {
  // Templates to use.
  protected DStringContents _stringContents;

  // View instance.
  protected IView _view;

  // Array of widgets + widget configuration.
  protected IWidget[string] _widgets = null;

  this(DStringContents newTemplate, DView newView, Json[string] widgets = null) {
    _stringContents = newTemplate;
    _view = newView;

    add(widgets);
  }

  /**
     * Load a config file containing widgets.
     *
     * Widget files should define a `configData` variable containing
     * all the widgets to load. Loaded widgets will be merged with existing* widgets.
     */
  void load(string fileToLoad) {
    // TODO
    /* 
        myloader = new DPhpConfig();
        mywidgets = myloader.read(fileToLoad);
        add(mywidgets); */
  }

  /**
     * Adds or replaces existing widget instances/configuration with new ones.
     *
     * Widget arrays can either be descriptions or instances. For example:
     *
     * ```
     * myregistry.add([
     * "label": new DMyLabelWidget(mytemplates),
     * "checkbox": ["Fancy.MyCheckbox", "label"]
     * ]);
     * ```
     *
     * The above shows how to define widgets as instances or as
     * descriptions including dependencies. Classes can be defined
     * with plugin notation, or fully namespaced class names.
     */
  void add(IWidget[string] newWidgets) {
    Json[] myfiles = null;

    foreach (aKey, mywidget; newWidgets) {
      _widgets[aKey] = mywidget;
    }
    // TODO myfiles.each!(file => load(file)); 
  }

  /**
     * Get a widget.
     *
     * Will either fetch an already created widget, or create a new instance
     * if the widget has been defined. If the widget is undefined an instance of
     * the `_default` widget will be returned. An exception will be thrown if
     * the `_default` widget is undefined.
     */
  IWidget get(string widgetName) {
    if (!_widgets.hasKey(widgetName)) {
      if (_widgets.isEmpty("_default")) {
        throw new DInvalidArgumentException("Unknown widget `%s`".format(widgetName));
      }
      widgetName = "_default";
    }
    return _widgets.get(widgetName, null);
  }

  // Clear the registry and reset the widgets.
  void clear() {
    _widgets = null;
  }

  // Resolves a widget spec into an instance.
  protected IWidget _resolveWidget(Json[string] configData) {
    /* 
        auto myclass = configData.shift();
        auto myclassname = App.classname(myclass, "View/Widget", "Widget");
        if (myclassname.isNull) {
            throw new DInvalidArgumentException("Unable to locate widget class `%s`.".format(myclass));
        } */
    /* if (configData.length > 0) {
            auto myreflection = new DReflectionClass(myclassname);
            auto myarguments = [_stringContents];
            foreach (myrequirement; configData) {
                myarguments ~= myrequirement == "_view"
                    ? _view
                    : get(myrequirement);
            }
            myinstance = myreflection.newInstanceArgs(myarguments);
        } else {
            myinstance = WidgetFactory(_stringContents);
        } */

    // return myinstance;
    return null;
  }
}
