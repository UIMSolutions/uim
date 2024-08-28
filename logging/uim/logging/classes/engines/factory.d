module uim.logging.engines.factory;

import uim.oop;

@safe:

class DLogEngineFactory : DFactory!DLogEngine {
}
auto LogEngineFactory() { return DLogEngineFactory.factory; }

