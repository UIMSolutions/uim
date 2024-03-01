module logging.uim.logging.classes.formatters.formatter;

import uim.logging;

@safe:
class DLogFormatter : ILogFormatter {
  this() {
    initialize();
    this.name("LogFormatter");
  }

  this(string name) {
    this();
    this.name(name);
  }

  mixin(TProperty!("string", "name"));
  mixin(TProperty!("IData[string]", "config"));

  bool initialize(IData[string] configSettings = null) {
    return true;
  }
}
