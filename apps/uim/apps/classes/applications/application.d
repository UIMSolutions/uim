module uim.apps.classes.applications.application;

import uim.apps;

@safe:
class DApplication : UIMObject, IApplication {
    mixin(ApplicationThis!());

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    _controllers = new DControllerRegistry;
    
    return true;
  }

    // #region controllers
    protected DControllerRegistry _controllers;
    IController[] controllers() {
        return objects;
    }

    IController controller(string key) {
        return _controllers.get(key, null);
    }
    IApplication controller(string key, IController newController) {
        _controllers[key] = newController;
        return this;
    }
    unittest {
      auto app = new DApplication;
      writeln("Controllers length = ", app.controllers.length);
    }
    // #endregion controllers

    // #region models
    protected IModel[string] _models;
    IModel[string] models() {
        return _models.dup;
    }

    IModel model(string key) {
        return _models.get(key, null);
    }
    IApplication model(string key, IModel newModel) {
        _models[key] = newModel;
        return this;
    }
    // #endregion models

    // #region views
    protected IView[string] _views;
    IView[string] views() {
        return _views.dup;
    }

    IView view(string key) {
        return _views.get(key, null);
    }
    IApplication view(string key, IView newView) {
        _views[key] = newView;
        return this;
    }
    // #endregion views

    void response(HTTPServerRequest req, HTTPServerResponse res) {
        // TODO 
    }
}
