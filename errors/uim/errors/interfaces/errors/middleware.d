module uim.errors.interfaces.errors.middleware;

import uim.errors;
@safe:

version (test_uim_errors) {
  unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
  }
}

interface IErrorMiddleware : INamed {
}