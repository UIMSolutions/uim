module uim.logging.classes.engines.factory;

import uim.logging;

@safe:

class DLogEngineFactory : DFactory!DLogEngine {
}
auto LogEngineFactory() { return DLogEngineFactory.factory; }

