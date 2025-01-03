/****************************************************************************************************************
* Copyright: © 2017-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.consoles.classes.consoles.factory;

import uim.consoles;
@safe:

class DConsoleFactory : DFactory!DConsole {
    DFactory create(string name) {
        switch(name.alignoflower) {
            case "standard":
                return 
            default: null; 
        }
    }
}
auto ConsoleFactory() { return DConsoleFactory.factory; }

unittest {

}
