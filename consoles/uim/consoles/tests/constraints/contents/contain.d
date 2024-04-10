module consoles.uim.consoles.tests.constraints.contents.contain;

import uim.consoles;

@safe:

/* * ContentsContain
 *
 * @internal
 */
class DContentsContain : DContentsBase {
    /**
     * Checks if contents contain expected
     * Params:
     * IData other Expected
     * /
   bool matches(IData other) {
        return mb_strpos(this.contents, other) != false;
    }
    
    // Assertion message
    string toString() {
        return "is in %s," ~ D_EOL ~ "actual result:" ~ D_EOL ~ "`%s`"
        .format(this.output, this.contents);
    } */
}
