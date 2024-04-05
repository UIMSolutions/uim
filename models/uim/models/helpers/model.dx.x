module uim.models.helpers.model;

import uim.models;
@safe:

bool isNull(DModel aModel) {
  return (aModel is null ? true : false);
}
unittest {
  DModel model;
  assert(model is null); 

  model = new DModel;
  assert(!model is null); 
}

bool isNull(IModel aModel) {
  return (aModel is null ? true : false);
}
unittest {
  IModel model;
  assert(model is null); 

  model = new DModel;
  assert(!model is null); 
}
