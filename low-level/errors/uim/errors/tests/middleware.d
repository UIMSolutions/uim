module uim.errors.tests.middleware;

import uim.errors;

@safe:

version (test_uim_errors) {
  unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
  }
}

bool testErrorMiddleware(IErrorMiddleware middleware) {
  assert(middleware !is null, "Middleware is null");
  return true;
}
