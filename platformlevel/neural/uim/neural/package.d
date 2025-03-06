/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.neural;

mixin(ImportPhobos!());

public { // uim libraries
  import uim.infralevel;
}

public { // uim.filesystem libraries
  mixin(Imports!("uim.neural", [
      "classes",
      "collections",
      "enumerations",
      "errors",
      "exceptions",
      "factories",
      "helpers",
      "interfaces",
      "mixins",
      "registries",
      "tests"
  ]));
}
