module uim.models.interfaces.modelmanager;

import uim.models;
@safe:

interface IModelManager {
  void modelContainer(DModelContainer aContainer);
  DModelContainer modelContainer();

  void models(IModel[string] someModels);
  void models(IModel[] someModels...);
  void models(IModel[] someModels);
  
  IModel[] models();
  string[] modelNames();

  // set & get model
  IModel model(string aName);
  void model(IModel aModel);
  void model(string aName, IModel aModel);

  void hasModel(string aName); 

  void addModel(IModel aModel); 
  void addModel(string aName, IModel aModel);

  void updateModel(string aName, IModel aModel); 
  void updateModel(IModel aModel); 

  void removeModel(string aName); 
}
