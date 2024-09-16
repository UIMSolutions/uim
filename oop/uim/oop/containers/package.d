/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.oop.containers;static this() {    import std.stdio;    version (test_uim_oop) {        writeln(__MODULE__);    }}public { // Packages  import uim.oop.containers.arrays;  import uim.oop.containers.lists;  import uim.oop.containers.maps;}public { // Modules  import uim.oop.containers.container;  // import uim.oop.containers.named;}