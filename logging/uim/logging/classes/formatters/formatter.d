module uim.logging.classes.formatters.formatter;

import uim.logging;

@safe:
class DLogFormatter : ILogFormatter {
  this(IData[string] initData = null) {
    initialize(initData);
    this.name("LogFormatter");
  }

  this(string name) {
    this();
    this.name(name);
  }

  mixin(TProperty!("string", "name"));
  mixin(TProperty!("IData[string]", "config"));

  bool initialize(IData[string] initData = null) {
    return true;
  }
}
