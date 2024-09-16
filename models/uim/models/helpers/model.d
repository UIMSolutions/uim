/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.models.helpers.model;import uim.models;@safe:bool isNull(DModel aModel) {  return (aModel is null ? true : false);}unittest {  DModel model;  assert(model.isNull);   model = new DModel;  assert(!model.isNull); }bool isNull(IModel aModel) {  return (aModel is null ? true : false);}unittest {  IModel model;  assert(model.isNull);   model = new DModel;  assert(!model.isNull); }