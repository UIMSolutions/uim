module uim.models.helpers.entity;

import uim.models;
@safe:

bool isNull(IEntity entity) {
  return (entity is null ? true : false);
}

unittest {
  /* IEntity entity;
  assert(entity.isNull); 

  // entity = new DEntity;
  assert(!entity.isNull); */
}
