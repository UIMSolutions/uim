/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.models;

mixin(ImportPhobos!());

// Dub
public {
  import colored;
  import vibe.d;
}

public { // uim libraries
  import uim.core;
  import uim.oop;
  import uim.mvc;
}

public { // uim.filesystem libraries
  mixin(Imports!("uim.models", [
      "classes",
      "collections",
      "enumerations",
      "errors",
      "exceptions",
      "factories",
      "helpers",
      "interfaces",
      "mixins",
      "repositories",
      "tests"
  ]));
}