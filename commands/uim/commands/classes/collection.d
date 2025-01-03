/****************************************************************************************************************
* Copyright: © 2018-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module commands.uim.commands.classes.collection;

import uim.oop;
@safe:

class DCommandCollection : DCollection!DCommand {   
}

auto CommandCollection() { return new DCommandCollection; } 

unittest {
  assert(CommandCollection);

  auto collection = CommandCollection;
}