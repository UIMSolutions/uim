module models.uim.models.helpers.model;

import uim.models;
@safe:

bool isNull(DModel aModel) {
  return (aModel is null ? true : false);
}
unittest {
  DModel model;
  assert(model.isNull); 

  model = new DModel;
  assert(!model.isNull); 
}

bool isNull(IModel aModel) {
  return (aModel is null ? true : false);
}
unittest {
  IModel model;
  assert(model.isNull); 

  model = new DModel;
  assert(!model.isNull); 
}
