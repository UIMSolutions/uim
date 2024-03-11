module logging.uim.logging.classes.engines.engine;

import uim.logging;

@safe:
// Base log engine class.
class DLogEngine : ILogEngine {
  this() {
  }

  bool initialize(IData[string] initData = null) {
    return true;
  }

  mixin(TProperty!("ILogFormatter", "formatter"));
  mixin(TProperty!("string", "name"));
  mixin(TProperty!("string", "className"));
}
