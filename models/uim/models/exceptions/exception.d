/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.models.exceptions.exception;import uim.models;@safe:// Model exception.class DModelException : UIMException {  mixin(ExceptionThis!("Model"));  override bool initialize(Json[string] initData = null) {    if (!super.initialize(initData)) {      return false;    }    messageTemplate("default", "Exception in libary uim-models");    return true;  }}mixin(ExceptionCalls!("Model"));