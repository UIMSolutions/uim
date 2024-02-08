module uim.models.interfaces.model;

import uim.models;
@safe:

interface IModel {
  IModelManager manager();
  
  string registerPath();

  DModel create();
  DModel copy(); 
}