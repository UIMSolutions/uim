/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.consoles;

mixin(ImportPhobos!());

// Dub
public {
  import colored;
  import vibe.d;
  import vibe.http.session : HttpSession = Session;
}

public { // uim libraries
  import uim.core;
  import uim.oop;
  import uim.errors;
}

public { // uim.filesystem libraries
  import uim.consoles.classes;
  import uim.consoles.enumerations;
  import uim.consoles.errors;
  import uim.consoles.exceptions;
  import uim.consoles.factories;
  import uim.consoles.helpers;
  import uim.consoles.interfaces;
  import uim.consoles.mixins;
  import uim.consoles.repositories;
  import uim.consoles.tests;
}

