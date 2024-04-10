module consoles.uim.consoles.tests.constraints.contents.regexp;

import uim.consoles;

@safe:

/* * ContentsRegExp
 *
 * @internal
 */
class DContentsRegExp : DContentsBase {
    /**
     * Checks if contents contain expected
     * Params:
     * IData other Expected
     */
   bool matches(IData other) {
        return preg_match( other, this.contents) > 0;
    }
    
    // Assertion message
    string toString() {
        return "PCRE pattern found in %s".format(this.output);
    }
    
    // @param IData other Expected
    string failureDescription(IData other) {
        return "`" ~ other ~ "` " ~ this.toString();
    }
}

