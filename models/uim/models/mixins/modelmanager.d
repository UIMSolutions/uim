/*********************************************************************************************************
	Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel, mailto:ons@sicherheitsschmiede.de                                                      
**********************************************************************************************************/
module uim.models.mixins.modelmanager;

import uim.models;
@safe:

mixin template ModelContainerTemplate() {
  // #region modelContainer
  protected DModelContainer _modelContainer;  
  DModelContainer modelContainer() {
    if (_modelContainer) return _modelContainer;
    return (_manager ? manager.modelContainer : null); 
  }  
  void modelContainer(DModelContainer aModelContainer) {    
    _modelContainer = aModelContainer;
  }  
  // #endregion modelContainer
}

mixin template ModelManagerTemplate() {
  // #region models
    void models(IModel[string] someModels) {
      someModels.byKeyValue.each!(kv => model(kv.key, kv.value));
    }

    void models(IModel[] someModels) {
      someModels.each!(col => model(col));
    }

    IModel[] models() { 
      if (modelContainer) return modelContainer.values;
      return null; 
    }
    string[] modelNames() {
      if (modelContainer) return modelContainer.keys;
      return null;
    }
  // #endregion models

  // #region model
    IModel model(string aName = null) {
      if (_modelContainer is null) return null;

      return (aName ? _modelContainer[aName, NullModel] : _modelContainer[_defaultModel]);
    }

    void model(IModel aModel) {
      if (aModel) model(aModel.name, aModel);
    }
    void model(string aName, IModel aModel) {
      if (modelContainer) modelContainer[aName] = aModel;
    }
  // #endregion model
  
 IModel model(string aName) {
    return (_modelContainer ? _modelContainer[aName] : null);
  }
  void model(string aName, IModel aModel) {
    if (_modelContainer) _modelContainer[aName] = aModel;
  }

  bool hasModel(string aName) {
    return (_modelContainer ? !(_modelContainer[aName] is null) : false);
  }

  // Add model if not exitst
  void addModel(IModel aModel) {
    if (aModel) addModel(aModel.name, aModel);
  }
  void addModel(string aName, IModel aModel) {
    if (_modelContainer && aModel && !hasModel(aName)) _modelContainer.add(aName, aModel);
  }

  // Update existing model
  void updateModel(IModel aModel) {
     if (aModel) updateModel(aModel.name, aModel);
  }
  void updateModel(string aName, IModel aModel) {
    if (aModel && hasModel(aName)) _modelContainer.update(aName, aModel);
  }

  // Remove existing model
  void removeModel(IModel aModel) {
    if (aModel) removeModel(aModel.name);
  }
  void removeModel(string aName) {
    if (_modelContainer && hasModel(aName)) _modelContainer.remove(aName);
  }
}