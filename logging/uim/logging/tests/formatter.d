module uim.logging.tests.formatter;

import uim.logging;
@safe:

version (test_uim_logging) {
  unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
  }
}

bool testLogger(ILogger logger) {
  assert(logger !is null, "testLogger -> logger is null");

  return true;
}
