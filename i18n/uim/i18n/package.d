/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.i18n;

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
  import uim.i18n.classes;
  import uim.i18n.enumerations;
  import uim.i18n.errors;
  import uim.i18n.exceptions;
  import uim.i18n.helpers;
  import uim.i18n.interfaces;
  import uim.i18n.mixins;
  import uim.i18n.tests;
}
