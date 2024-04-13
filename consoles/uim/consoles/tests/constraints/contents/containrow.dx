module uim.consoles.tests.constraints.contents.containrow;

import uim.consoles;

@safe:

/* * ContentsContainRow
 *
 * @internal
 */
class DContentsContainRow : DContentsRegExp {
    /**
     * Checks if contents contain expected
     * Params:
     * IData other Row
     * /
    bool matches(IData other) {
        string[] row = array_map(function (cell) {
            return preg_quote(cell, "/");
        }, (array) other);
        
        string cells = row.join("\s+\|\s+", );
        somePattern = "/" ~ cells ~ "/";

        return preg_match(somePattern, this.contents) > 0;
    }
    
    // Assertion message
    string toString() {
        return "row was in %s".format(this.output);
    }
    
    // @param IData other Expected content
    string failureDescription(IData other) {
        return "`" ~ this.exporter().shortenedExport( other) ~ "` " ~ this.toString();
    } */
}
