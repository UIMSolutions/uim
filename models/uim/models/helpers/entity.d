/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.models.helpers.entity;import uim.models;@safe:bool isNull(IEntity entity) {  return (entity is null ? true : false);}unittest {  /* IEntity entity;  assert(entity.isNull);   // entity = new DEntity;  assert(!entity.isNull); */}