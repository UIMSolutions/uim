module uim.i18n.classes.parsers.registration;

import uim.i18n;

@safe:

class DParserRegistry : DObjectRegistry!DParser {
}

auto ParserRegistry() {
    return DParserRegistry.registration;
}