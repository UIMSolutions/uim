module uim.i18n.classes.parsers.po.parser;

import uim.i18n;
@safe:

class DPoI18NParser : DI18NParser {
    mixin(I18NParserThis!("Po"));

    string parseFile(string fileName) {
        if (!fileName.exists) {
            return null;
        }

        /* string[] lines = File(fileName).byLine();
        return lines.join; */
        return null; 
    }
}
mixin(I18NParserCalls!("Po"));

unittest {
    auto parser = PoI18NParser;
    writeln(parser.parseFile("tests\\sample.po"));
}