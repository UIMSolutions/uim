module uim.errors.tests.formatter;

import uim.errors;

@safe:

version (test_uim_errors) {
  unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
  }
}

bool testErrorFormatter(IErrorFormatter formatter) {
  assert(formatter !is null, "Formatter is null");
  return true;
}
