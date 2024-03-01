module logging.uim.logging.classes.engines.engine;

import uim.logging;

@safe:
// Base log engine class.
class DLogEngine : ILogEngine {
  this() {
  }

  bool initialize(IData[string] configSettings = null) {
    return true;
  }

  mixin(TProperty!("IFormatter", "formatter"));
  mixin(TProperty!("string", "name"));
  mixin(TProperty!("string", "className"));
}
