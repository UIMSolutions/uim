module uim.logging.interfaces.aware;

import uim.logging;
@safe:
// Describes a logger-aware instance.
interface ILoggerAware {
  // Sets a logger instance on the object.
  void logger(ILogger aLogger);
}
