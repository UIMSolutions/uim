/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.models.interfaces.element;

import uim.models;
@safe:

interface IElement {
  // Read data from STRINGAA
  void readFromStringAA(string[string] reqParameters, bool usePrefix = false);

  // Read data from request
  void readFromRequest(string[string] requestValues, bool usePrefix = true);
}