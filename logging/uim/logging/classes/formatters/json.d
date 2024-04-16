module uim.logging.classes.formatters.json;

import uim.logging;

@safe:
class DJsonLogFormatter : DLogFormatter {
  mixin(LogFormatterThis!("Json"));

  override bool initialize(IData[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    configuration.updateDefaults([
      "dateFormat": IntegerData(DATE_ATOM),
      "flags": IntegerData("JSON_UNESCAPED_UNICODE | Json_UNESCAPED_SLASHES"),
      "appendNewline": BooleanData(true),
    ]);

    return true;
  }

  /*
      string|int|false format(level, string amessage, array context = []) {
        auto log = ["date": date(configuration["dateFormat"]), "level": to!string(level), "message": message];
        auto IData = Json_encode(log, Json_THROW_ON_ERROR | configuration["flags"]);

        return configuration["appendNewline"] ? IData ~ "\n" : IData;
    } */
}

mixin(LogFormatterCalls!("Json"));
