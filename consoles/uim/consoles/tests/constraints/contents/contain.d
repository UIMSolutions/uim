module uim.consoles.tests.constraints.contents.contain;

import uim.consoles;

@safe:

// ContentsContain
class DContentsContain : DContentsBase {
    /**
     * Checks if contents contain expected
     * Params:
     * Json other Expected
     */
   bool matches(Json other) {
        return mb_indexOf(_contents, other) == true;
    }
    
    // Assertion message
    string toString() {
        return "is in %s," ~ D_EOL ~ "actual result:" ~ D_EOL ~ "`%s`"
        .format(_output, _contents);
    } 
} 
