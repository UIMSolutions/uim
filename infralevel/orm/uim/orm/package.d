/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.orm;

mixin(ImportPhobos!());

// Dub
public {
  import colored;
  import vibe.d;
  import vibe.http.session : HttpSession = Session;
}

public { // uim libraries
  import import uim.baselevel;
}

public { // uim.filesystem libraries
  import uim.orm.classes;
  import uim.orm.collections;
  import uim.orm.enumerations;
  import uim.orm.errors;
  import uim.orm.exceptions;
  import uim.orm.factories;
  import uim.orm.helpers;
  import uim.orm.interfaces;
  import uim.orm.mixins;
  import uim.orm.registries;
  import uim.orm.tests;
}

/* public { // uim.filesystem libraries
  mixin(Imports!("uim.orm", [
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
} */
