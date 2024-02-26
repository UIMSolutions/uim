module uim.logging.interfaces.formatter;

import uim.logging;

@safe:

interface ILogFormatter {
  string name();
  void name(string newName);

  IData[string] config();
  void config(IData[string] newConfig);

  // TODO Json configuration.data(string key);
  // TODO void configuration.data(string key, Json newData);
}
