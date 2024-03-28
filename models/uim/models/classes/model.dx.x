module uim.models.classes.model;

import uim.models;

@safe:
class DModel : IModel {
    mixin TConfigurable!();

    this() {
        initialize;
    }

    bool initialize(IData[string] initData = null) {
        configuration(MemoryConfiguration);
        configuration.data(initData);
        
        return true;
    }
    
    
      this() {
    this.name("Model");
    className("Model");
  }

  this(IData[string]  configData) {
    this(); initialize(configData);
  }

  this(IModelManager aManager, IData[string] configData = null) {
    this(configData); manager(aManager);
  }

  this(string aName, IData[string] configData = null) {
    this(configData).name(aName);
  }

  this(STRINGAA someParameters, IData[string] configData = null) {
    this(configData);
    parameters(someParameters);
  }

  this(IModelManager aManager, string aName, IData[string] configData = null) {
    this(aManager, configData);
    name(aName);
  }

  this(IModelManager aManager, STRINGAA someParameters, IData[string] configData = null) {
    this(aManager, configData);
    parameters(someParameters);
  }

  this(string aName, STRINGAA someParameters, IData[string] configData = null) {
    this(name, configData);
    parameters(someParameters);
  }

  this(IModelManager aManager, string aName, STRINGAA someParameters, IData[string] configData = null) {
    this(aManager, name, configData);
    parameters(someParameters);
  }

  bool initialize(IData[string] initData = null) {
    configuration(MemoryConfiguration);
    configuration.data(initData);
    return true;
  }

  mixin(TProperty!("string", "name"));
  mixin(TProperty!("string", "className"));
  mixin(TProperty!("string", "registerPath"));
  mixin(TProperty!("IModelManager", "manager"));
  mixin(TProperty!("STRINGAA", "parameters"));

  /**
    * Default config
    * These are merged with user-provided config when the component is used.
    */
  mixin(TProperty!("IData[string]", "defaultConfig"));

  // Configuration of mvcobject
  mixin(TProperty!("Json", "config"));

  DModel create() {
    return Model;
  }

  DModel copy() {
    auto result = create;
    // result.fromJson(this.toJson);
    return result;
  }
}

mixin(ModelCalls!("Model", "DModel"));

version (test_uim_models) {
  unittest {
    assert(Model);
    assert(Model.name == "Model");
  }
}
