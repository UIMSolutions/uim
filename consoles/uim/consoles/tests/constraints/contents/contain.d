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
        return "is in %s," ~ D_EOL ~ "actual result:" ~ D_EOL ~ "`%s`"
        .format(_output, _contents);
    } 
} 
