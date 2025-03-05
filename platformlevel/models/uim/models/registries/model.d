/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.models.registries.model;

import uim.models;

@safe:
class DModelRegistry : DObjectRegistry!DModel{
}

// Singleton
auto ModelRegistration() { 
  return DModelRegistry.registration;
}

unittest {
/*   assert(ModelRegistration.register("mvc/model",  new DModel).paths == ["mvc/model"]);
  assert(ModelRegistration.register("mvc/model2", new DModel).paths.length == 2); */
}