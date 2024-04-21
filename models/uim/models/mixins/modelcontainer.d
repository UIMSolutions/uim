/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel, mailto:ons@sicherheitsschmiede.de                                                      
**********************************************************************************************************/
module uim.models.mixins.modelcontainer;

import uim.models;
@safe:

mixin template TModelContainer() {
  // #region modelContainer
  protected IModelContainer _modelContainer;  
  DModelContainer modelContainer() {
    if (_modelContainer) return _modelContainer;
    return (_manager ? manager.modelContainer : null); 
  }  
  void modelContainer(DModelContainer aModelContainer) {    
    _modelContainer = aModelContainer;
  }  
  // #endregion modelContainer
}
