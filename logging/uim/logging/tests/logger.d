module uim.logging.tests.logger;

import uim.logging;
@safe:

version (test_uim_logging) {
  unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
  }
}

bool testLogFormatter(ILogFormatter formatter) {
  assert(formatter !is null, "testLogFormatter -> formatter is null");

  return true;
}
