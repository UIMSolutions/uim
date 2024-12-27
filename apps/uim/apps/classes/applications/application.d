module uim.apps.classes.applications.application;

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
      writeln("Controllers length = ", app.controllers.length);
      writeln("Singleton Controllers length = ", ControllerRegistry.length);

      app.controller("test", new DController);
      writeln("Controllers length = ", app.controllers.length);
      writeln("Singleton Controllers length = ", ControllerRegistry.length);

      ControllerRegistry.register("test", new DController);
      ControllerRegistry.register("test1", new DController);
      writeln("Controllers length = ", app.controllers.length);
      writeln("Singleton Controllers length = ", ControllerRegistry.length);

      app.removeController("test");
      writeln("Controllers length = ", app.controllers.length);
      writeln("Singleton Controllers length = ", ControllerRegistry.length);
    }
    // #endregion controllers

    // #region models
    mixin(MixinRegistry!("Model", "Models"));
    unittest {
      auto app = new DApp;
      writeln("Models length = ", app.models.length);
      writeln("Singleton Models length = ", ModelRegistry.length);

      app.model("test", new DModel);
      writeln("Models length = ", app.models.length);
      writeln("Singleton Models length = ", ModelRegistry.length);

      ModelRegistry.register("test", new DModel);
      ModelRegistry.register("test1", new DModel);
      writeln("Models length = ", app.models.length);
      writeln("Singleton Models length = ", ModelRegistry.length);

      app.removeModel("test");
      writeln("Models length = ", app.models.length);
      writeln("Singleton Models length = ", ModelRegistry.length);
    }
    // #endregion models

    // #region views
    mixin(MixinRegistry!("View", "Views"));
    unittest {
      auto app = new DApp;
      writeln("Views length = ", app.views.length);
      writeln("Singleton Views length = ", ViewRegistry.length);

      app.view("test", new DView);
      writeln("Views length = ", app.views.length);
      writeln("Singleton Views length = ", ViewRegistry.length);

      ViewRegistry.register("test", new DView);
      ViewRegistry.register("test1", new DView);
      writeln("Views length = ", app.views.length);
      writeln("Singleton Views length = ", ViewRegistry.length);

      app.removeView("test");
      writeln("Views length = ", app.views.length);
      writeln("Singleton Views length = ", ViewRegistry.length);
    }
    // #endregion views

    void response(HTTPServerRequest req, HTTPServerResponse res) {
        // TODO 
    }
}
