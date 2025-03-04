module uim.errors.tests.logger;

import uim.errors;

@safe:

version (test_uim_errors) {
  unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
  }
}

bool testErrorLogger(IErrorLogger logger) {
  assert(logger !is null, "Logger is null");
  return true;
}
