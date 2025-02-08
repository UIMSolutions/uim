/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.consoles.tests.constraints.contents.contain;

import uim.consoles;

@safe:

// ContentsContain
class DContentsContain : UIMObject /* DContentsBase */ {
    // Checks if contents contain expected
    /*  matches(Json other) {
        return mb_indexOf(_contents, other) == true;
    } */
    
    // Assertion message
    override string toString() {
        /* return "is in %s," ~ D_EOL ~ "actual result:" ~ D_EOL ~ "`%s`"
        .format(_output, _contents); */
        return null;
    } 
} 
