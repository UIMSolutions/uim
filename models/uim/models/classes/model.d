module uim.models.classes.model;

import uim.models;

@safe:
class DModel : IModel { 
  this() { this.name("Model").className("Model"); }
  this(Json configData) { this().initialize(configData); }
  this(IModelManager aManager, IData[string] configData = null) { this().manager(aManager).initialize(configData); }

  this(string aName, IData[string] configData = null) { this(configData).name(aName); }
  this(STRINGAA someParameters, IData[string] configData = null) { this(configData).parameters(someParameters); }

  this(IModelManager aManager, string aName, IData[string] configData = null) { this(aManager, configData).name(aName); }
  this(IModelManager aManager, STRINGAA someParameters, IData[string] configData = null) { this(aManager, configData).parameters(someParameters); }

  this(string aName, STRINGAA someParameters, IData[string] configData = null) { this(name, configData).parameters(someParameters); }
  this(IModelManager aManager, string aName, STRINGAA someParameters, IData[string] configData = null) { this(aManager, name, configData).parameters(someParameters); }

  void initialize(IData[string] configData = null) {}

  mixin(OProperty!("string", "name"));
  mixin(OProperty!("string", "className"));
  mixin(OProperty!("string", "registerPath"));
  mixin(OProperty!("IModelManager", "manager"));
  mixin(OProperty!("STRINGAA", "parameters"));

  /**
    * Default config
    * These are merged with user-provided config when the component is used.
    */
  mixin(OProperty!("Json", "defaultConfig"));

  // Configuration of mvcobject
  mixin(OProperty!("Json", "config"));

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

version(test_uim_models) { unittest { 
  assert(Model);
  assert(Model.name == "Model");
}} 