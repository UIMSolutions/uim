module uim.logging.classes.formatters.json;

import uim.logging;

@safe:
class DJsonLogFormatter : DLogFormatter {
  mixin(LogFormatterThis!("Json"));

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    configuration.setDefaults([
      "dateFormat": Json("DATE_ATOM"),
      "flags": Json("JSON_UNESCAPED_UNICODE | Json_UNESCAPED_SLASHES"),
      "appendNewline": true.toJson,
    ]);

    return true;
  }

  /*
      string|int|false format(level, string amessage, Json[string] context = null) {
        auto log = ["date": date(configuration.get("dateFormat"]), "level": to!string(level), "message": message];
        auto Json = Json_encode(log, Json_THROW_ON_ERROR | configuration.get("flags"]);

        return configuration.get("appendNewline"] ? Json ~ "\n" : Json;
    }
}

mixin(LogFormatterCalls!("Json"));
