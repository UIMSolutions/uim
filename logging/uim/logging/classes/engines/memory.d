module uim.logging.engines.memory;

import uim.logging;

/**
 * Memory Log engine.
 *
 * Collects log messages in memory. Intended primarily for usage
 * in testing where using mocks would be complicated. But can also
 * be used in scenarios where you need to capture logs in application code.
 */
@safe:
class DMemoryLogEngine : DLogEngine {
  mixin(LogEngineThis!("Memory"));

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    return true;
  }
}

mixin(LogEngineCalls!("Memory"));
