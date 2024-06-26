module uim.models.classes.models.model;

import uim.models;

@safe:
class DModel : UIMObject, IModel {
  mixin(ModelThis!(""));

  this(IModelManager aManager, Json[string] configData = null) {
    this(configData);
    manager(aManager);
  }

  this(STRINGAA someParameters, Json[string] configData = null) {
    this(configData);
    parameters(someParameters);
  }

  this(IModelManager aManager, string aName, Json[string] configData = null) {
    this(aManager, configData);
    name(aName);
  }

  this(IModelManager aManager, STRINGAA someParameters, Json[string] configData = null) {
    this(aManager, configData);
    parameters(someParameters);
  }

  this(string aName, STRINGAA someParameters, Json[string] configData = null) {
    this(name, configData);
    parameters(someParameters);
  }

  this(IModelManager aManager, string aName, STRINGAA someParameters, Json[string] configData = null) {
    this(aManager, name, configData);
    parameters(someParameters);
  }
  override bool initialize(Json[string] initData = null) {
     if (!super.initialize(initData)) {
      return false;
    }
 
    return true;
  }

  mixin(TProperty!("string", "classname"));
  mixin(TProperty!("string", "registerPath"));
  mixin(TProperty!("IModelManager", "manager"));
  mixin(TProperty!("STRINGAA", "parameters"));

  /**
    * Default config
    * These are merged with user-provided config when the component is used.
    */
  // TODO mixin(TProperty!("Json[string]", "defaultConfig"));

  // Configuration of mvcobject
  mixin(TProperty!("Json", "config"));

  DModel create() {
    return Model;
  }

  IModel clone() {
    auto result = create;
    // result.fromJson(toJson);
    return result;
  }
}

mixin(ModelCalls!(""));

version (test_uim_models) {
  unittest {
    assert(Model);
    assert(Model.name == "Model");
  }
}
