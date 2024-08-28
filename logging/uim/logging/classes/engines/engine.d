module uim.logging.engines.engine;

import uim.logging;

@safe:
// Base log engine class.
class DLogEngine : UIMObject, ILogEngine {
  mixin(LogEngineThis!(""));

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    return true;
  }

  mixin(TProperty!("ILogFormatter", "formatter"));
  mixin(TProperty!("string", "classname"));
}
