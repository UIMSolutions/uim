module uim.i18n.classes.parsers.registry;

import uim.i18n;

@safe:

class DParserRegistry : DObjectRegistry!DParser {
    static DParserRegistry registry;
}

auto ParserRegistry() {
    return DParserRegistry.registry is null
        ? DParserRegistry.registry = new DParserRegistry
        : DParserRegistry.registry;
}