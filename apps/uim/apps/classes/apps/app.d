module uim.apps.classes.apps.app;

import uim.apps;

@safe:
class DApp : UIMObject, IApp {
  mixin(ApplicationThis!());

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    _controllerRegistry = new DControllerRegistry;
    _modelRegistry = new DModelRegistry;
    _viewRegistry = new DViewRegistry;

    return true;
  }

  // #region controllers
  mixin(MixinRegistry!("Controller", "Controllers"));
  unittest {
    auto app = new DApp;
    assert(app.controllers.length == 0);
    assert(ControllerRegistry.length == 0);

    app.controller("test", new DController);
    assert(app.controllers.length == 1);
    assert(ControllerRegistry.length == 0);

    ControllerRegistry.register("test", new DController);
    ControllerRegistry.register("test1", new DController);
    assert(app.controllers.length == 1);
    assert(ControllerRegistry.length == 2);

    app.removeController("test");
    assert(app.controllers.length == 0);
    assert(ControllerRegistry.length == 2);
  }
  // #endregion controllers

  // #region models
  mixin(MixinRegistry!("Model", "Models"));
  unittest {
    auto app = new DApp;
    assert(app.models.length == 0);
    assert(ModelRegistry.length == 0);

    app.model("test", new DModel);
    assert(app.models.length == 1);
    assert(ModelRegistry.length == 0); // Unchanged

    ModelRegistry.register("test", new DModel);
    ModelRegistry.register("test1", new DModel);
    assert(app.models.length == 1); // Unchanged
    assert(ModelRegistry.length == 2);

    app.removeModel("test");
    assert(app.models.length == 0);
    assert(ModelRegistry.length == 2); // Unchanged
  }
  // #endregion models

  // #region views
  mixin(MixinRegistry!("View", "Views"));
  unittest {
    auto app = new DApp;
    assert(app.views.length == 0);
    assert(ViewRegistry.length == 0);

    app.view("test", new DView);
    assert(app.views.length == 1);
    assert(ViewRegistry.length == 0); // Unchanged

    ViewRegistry.register("test", new DView);
    ViewRegistry.register("test1", new DView);
    assert(app.views.length == 1); // UNchanged
    assert(ViewRegistry.length == 2);

    app.removeView("test");
    assert(app.views.length == 0);
    assert(ViewRegistry.length == 2); // UNchanged
  }
  // #endregion views

  void response(HTTPServerRequest req, HTTPServerResponse res) {
    // TODO 
  }
}
