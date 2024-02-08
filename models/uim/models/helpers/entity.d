module uim.models.helpers.entity;

import uim.models;
@safe:

bool isNull(DEntity anEntity) {
  return (anEntity is null ? true : false);
}
unittest {
  DEntity entity;
  assert(entity.isNull); 

  entity = new DEntity;
  assert(!entity.isNull); 
}

bool isNull(IEntity anEntity) {
  return (anEntity is null ? true : false);
}
unittest {
  IEntity entity;
  assert(entity.isNull); 

  entity = new DEntity;
  assert(!entity.isNull); 
}
