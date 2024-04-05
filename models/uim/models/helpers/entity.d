module uim.models.helpers.entity;

import uim.models;
@safe:

bool isNull(IEntity anEntity) {
  return (anEntity is null ? true : false);
}

unittest {
  /* IEntity entity;
  assert(entity is null); 

  // entity = new DEntity;
  assert(!entity is null); */
}
