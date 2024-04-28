module uim.logging.classes.formatters.formatter;

import uim.logging;

@safe:
class DLogFormatter : ILogFormatter {
  mixin TConfigurable;

  this() {
    initialize;
  }

  this(Json[string] initData) {
    initialize(initData);
  }

  this(string name) {
    this().name(name);
  }

  // Hook method
  bool initialize(Json[string] initData = null) {
    configuration(MemoryConfiguration);
    configuration.data(initData);

    return true;
  }

  mixin(TProperty!("string", "name"));

  // Formats message.
  string format(Json loggingLevel, string loggingMessage, Json[string] loggingData = null) {
    return null; 
  }
}
