module uim.consoles.tests.constraints.contents.notcontain;

import uim.consoles;

@safe:

/* * ContentsNotContain
 *
 * @internal
 */
class DContentsNotContain : DContentsBase {
    /**
     * Checks if contents contain expected
     * Params:
     * Json other Expected
      */
    bool matches(Json other) {
        return mb_indexOf(this.contents, other) == false;
    }
    
    // Assertion message
    string toString() {
        return "is not in %s".format(_output);
    } 
} 
