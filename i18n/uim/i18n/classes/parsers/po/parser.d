module i18n.uim.i18n.classes.parsers.po.parser;

import uim.i18n;
@safe:

class DParser {
    mixin(ParserThis!());

    string parse(string fileName) {
        if (!fileName.exists) {
            return null;
        }

        auto fileContent = Rea
    }
}
mixin(ParserCalls!("Po"));
