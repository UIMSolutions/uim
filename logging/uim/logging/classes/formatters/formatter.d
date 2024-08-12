module uim.logging.classes.formatters.formatter;

import uim.logging;

@safe:
class DLogFormatter : UIMObject {
  this() {
    super();
  }

  this(Json[string] initData) {
    super(initData);
  }

  this(string name) {
    super(name);
  }

  // Hook method
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    return true;
  }

  // Formats message.
  string format(Json loggingLevel, string loggingMessage, Json[string] loggingData = null) {
    return null; 
  }
}
