module uim.logging.factories.logger;

import uim.logging;

@safe:

version (test_uim_logging) {
  unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
  }
}

class DLoggerFactory : DFactory!DLogger {
}

auto LoggerFactory() {
  return DLoggerFactory.factory;
}
