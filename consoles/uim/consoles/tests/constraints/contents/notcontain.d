module consoles.uim.consoles.tests.constraints.contents.notcontain;

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
     * IData other Expected
      * /
    bool matches(IData other) {
        return mb_strpos(this.contents, other) == false;
    }
    
    // Assertion message
    string toString() {
        return "is not in %s".format(this.output);
    } */
}
