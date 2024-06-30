module uim.oop.parsers.factory;

import uim.oop;
@safe:

class DParserFactory : DFactory!DParser {}
auto ParserFactory() { return DParserFactory.factory; }