module uim.models.classes.model;

import uim.models;

@safe:
class DModel : IModel { 
  this() { this.name("Model").className("Model"); }
  this(Json configSettings) { this().initialize(configSettings); }
  this(IModelManager aManager, Json configSettings = Json(null)) { this().manager(aManager).initialize(configSettings); }

  this(string aName, Json configSettings = Json(null)) { this(configSettings).name(aName); }
  this(STRINGAA someParameters, Json configSettings = Json(null)) { this(configSettings).parameters(someParameters); }

  this(IModelManager aManager, string aName, Json configSettings = Json(null)) { this(aManager, configSettings).name(aName); }
  this(IModelManager aManager, STRINGAA someParameters, Json configSettings = Json(null)) { this(aManager, configSettings).parameters(someParameters); }

  this(string aName, STRINGAA someParameters, Json configSettings = Json(null)) { this(name, configSettings).parameters(someParameters); }
  this(IModelManager aManager, string aName, STRINGAA someParameters, Json configSettings = Json(null)) { this(aManager, name, configSettings).parameters(someParameters); }

  void initialize(Json configSettings = Json(null)) {}

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