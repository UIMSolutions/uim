module uim.i18n.registries.parser;

import uim.i18n;

@safe:

class DParserRegistry : DObjectRegistry!DParser {
}

auto ParserRegistry() {
    return DParserRegistry.registration;
}