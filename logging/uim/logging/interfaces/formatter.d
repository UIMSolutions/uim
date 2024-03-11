module uim.logging.interfaces.formatter;

import uim.logging;

@safe:

interface ILogFormatter : INamed {
  IData[string] config();
  void config(IData[string] newConfig);

  // TODO
  // IData[string] configSettings = nulluration.data(string key);
  // void configuration.data(string key, Json newData)
}