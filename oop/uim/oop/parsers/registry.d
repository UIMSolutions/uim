module uim.oop.parsers.registry;

import uim.oop;
@safe:

class DParserRegistry : DObjectRegistry!DParser {
}
auto ParserRegistry() { return DParserRegistry.registry; }