module uim.oop.logging.loggers.logger;

import uim.oop;

@safe:

class DLogger : UIMObject, ILogger {
    mixin(LoggerThis!(""));

    override bool initialize(Json[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

        configuration
            .setDefault("levels", Json.emptyArray)
            .setDefault("scopes", Json.emptyArray)
            .setDefault("formatter", StandardLogFormatter.classname);

        if (configuration.hasKey("scopes")) {
           configuration.set("scopes", configuration.getArray("scopes"));
        }
        configuration.set("levels", configuration.getArray("levels"));

        if (configuration.hasKey("types") && configuration.get("levels").isEmpty) {
           configuration.set("levels", configuration.get("types").toArray);
        }

        auto formatterClassName = configuration.getString("formatter", StandardLogFormatter.classname);
        _formatter = LogFormatterRegistry.create(formatterClassName);

        return true;
    }

    protected ILogFormatter _formatter;

    // Get the levels this logger is interested in.
    string[] levels() {
        return configuration.getStringArray("levels");
    }

    // Get the scopes this logger is interested in.
    string[] scopes() {
        return configuration.getStringArray("scopes");
    }

    // Replaces placeholders in message string with context values.
    protected string interpolate(string message, Json[string] context = null) {
        if (!message.contains("{", "}")) { // No placeholders
            return message;
        }

        STRINGAA replacements = null;
        context.keys.each!((key) {
            auto value = context[key];

            if (aValue.isScalar) {
                replacements.set(key, value.toString);
                continue;
            }
            if (isArray(aValue)) {
                replacements.set(key, Json_encode(aValue, JsonFlags));
                continue;
            }
            if (cast(JsonSerializable)aValue) {
                replacements.set(key, Json_encode(aValue, JsonFlags));
                continue;
            }
            if (cast(DJson[string])aValue) {
                replacements.set(key, Json_encode(aValue.dup, JsonFlags));
                continue;
            }
            if (cast(DSerializable)aValue) {
                replacements.set(key, aValue.serialize());
                continue;
            }
            if (aValue.isObject) {
                if (aValue.hasKey("toArray")) {
                    replacements.set(key, Json_encode(aValue.toJString(), JsonFlags));
                    continue;
                }
                if (cast(DSerializable)aValue) {
                    replacements.set(key, serialize(aValue));
                    continue;
                }
                if (cast(DStringable)aValue) {
                    replacements.set(key, to!string(aValue));
                    continue;
                }
                if (aValue.hasKey("__debugInfo")) {
                    replacements.set(key, Json_encode(aValue.__debugInfo(), JsonFlags));
                    continue;
                }
            }
            replacements.set(key, "[unhandled value of type %s]".format(get_debug_type(aValue)));
        });
        return message.mustache(replacements);
    }

    abstract ILogger log(LogLevels logLevel, string logMessage, Json[string] logContext = null); 
}
