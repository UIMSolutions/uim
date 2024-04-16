module uim.logging.classes.formatters.formatter;

import uim.logging;

@safe:
class DLogFormatter : ILogFormatter {
  mixin TConfigurable;

  this() {
    initialize;
  }

  this(IData[string] initData) {
    initialize(initData);
  }

  this(string name) {
    this().name(name);
  }

  // Hook method
  bool initialize(IData[string] initData = null) {
    configuration(MemoryConfiguration);
    configuration.data(initData);

    return true;
  }

  mixin(TProperty!("string", "name"));

  // Formats message.
  string format(IData loggingLevel, string loggingMessage, IData[string] loggingData = null) {
    return null; 
  }
}
