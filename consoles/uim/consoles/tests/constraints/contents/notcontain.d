/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.consoles.tests.constraints.contents.notcontain;

import uim.consoles;

@safe:

// ContentsNotContain
class DContentsNotContain : DContentsBase {
    this(string[] contents, string outputType) {
        super(contents, outputType);
    }
        /**
     * Checks if contents contain expected
     * Params:
     * Json other Expected
      */
/*     bool matches(Json other) {
        return mb_indexOf(_contents, other) == false;
    } */
    
    // Assertion message
    override string toString() {
        return "is not in %s".format(_output);
    } 
} 
