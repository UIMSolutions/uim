/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.models.classes.models.registry;

import uim.models;

@safe:
class DModelRegistry : DObjectRegistry!DModel{
}
auto ModelRegistry() { 
  return DModelRegistry.registration;
}

unittest {
/*   assert(ModelRegistry.register("mvc/model",  new DModel).paths == ["mvc/model"]);
  assert(ModelRegistry.register("mvc/model2", new DModel).paths.length == 2); */
}