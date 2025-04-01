/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.logging.classes.loggers.logger;

import uim.logging;
@safe:

version (test_uim_logging) {
  unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
  }
}

class DLogger : UIMObject, ILogger {
  mixin(LoggerThis!());

  override bool initialize(Json[string] options = new Json[string]) {
    if (!super.initialize(options)) {
      return false;
    }

    configuration
      .setEntry("levels", Json.emptyArray)
      .setEntry("scopes", Json.emptyArray)
      .setEntry("formatter.classname", StandardLogFormatter.classname);

    if (options.hasKey("scopes")) {
      configuration.setEntry("scopes", options.getArray("scopes"));
    }
    configuration.setEntry("levels", options.getArray("levels"));
  
    if (options.hasKey("types") && configuration.isEmptyEntry("levels")) {
      configuration.setEntry("levels", options.getArray("types"));
    }

    _formatter = LogFormatterFactory.create(configuration.getString("formatter.classname"));

    return true;
  }

  // #region formatter
  protected ILogFormatter _formatter;
  ILogFormatter formatter() {
    return _formatter;
  };
  ILogger formatter(ILogFormatter newFormatter) {
    _formatter = newFormatter;
    return this;
  };
  // #endregion formatter

    // Get the levels this logger is interested in.
  string[] levels() {
    return configuration.getStringArray("levels");
  }

  // Get the scopes this logger is interested in.
  string[] scopes() {
    return configuration.getStringArray("scopes");
  }

 // Replaces placeholders in message string with logContext values.
  protected string interpolate(string message, Json[string] logContext = null) {
    if (!message.containsAll("{", "}")) { // No placeholders
      return message;
    }

    STRINGAA replacements;
    logContext.byKeyValue.each!(kv => replacements[kv.key] = kv.value.toString);
    /* if (value.isScalar) {
                replacements.set(key, value.toString);
                continue;
            }
            if (value.isArray) {
                replacements.set(key, Json_encode(value, JsonFlags));
                continue;
            }
            if (cast(JsonSerializable)value) {
                replacements.set(key, Json_encode(value, JsonFlags));
                continue;
            }
            if (cast(DJson[string])value) {
                replacements.set(key, Json_encode(value.dup, JsonFlags));
                continue;
            }
            if (cast(DSerializable)value) {
                replacements.set(key, value.serialize());
                continue;
            }
            if (value.isObject) {
                if (value.hasKey("toArray")) {
                    replacements.set(key, Json_encode(value.toJString(), JsonFlags));
                    continue;
                }
                if (cast(DSerializable)value) {
                    replacements.set(key, serialize(value));
                    continue;
                }
                if (cast(DStringable)value) {
                    replacements.set(key, to!string(value));
                    continue;
                }
                if (value.hasKey("debugInfo")) {
                    replacements.set(key, Json_encode(value.debugInfo(), JsonFlags));
                    continue;
                }
            }
            /* replacements.set(key, "[unhandled value of type %s]".format(get_debug_type(value))); * /
        });
        return message.mustache(replacements); */
    return message.mustache(logContext);
  }

  abstract ILogger log(LogLevels logLevel, string logMessage, Json[string] logContext = null);
}