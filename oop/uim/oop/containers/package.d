/***********************************************************************************
*	Copyright: © 2015-2024 Ozan Nurettin Süel (sicherheitsschmiede)                   *
*	License  : Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt] *
*	Author   : Ozan Nurettin Süel (Sicherheitsschmiede)										           * 
***********************************************************************************/
module uim.oop.containers;

static this() {
    import std.stdio;
    version (test_uim_oop) {
        writeln(__MODULE__);
    }
}

public { // Packages
  import uim.oop.containers.arrays;
  import uim.oop.containers.lists;
  import uim.oop.containers.maps;
}

public { // Modules
  import uim.oop.containers.container;
  // import uim.oop.containers.named;
}