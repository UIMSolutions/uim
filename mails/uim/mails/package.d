/****************************************************************************************************************
* Copyright: © 2018-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.mails;

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
  import uim.mails.classes;
  import uim.mails.enumerations;
  import uim.mails.errors;
  import uim.mails.exceptions;
  import uim.mails.helpers;
  import uim.mails.interfaces;
  import uim.mails.mixins;
  import uim.mails.tests;
}
