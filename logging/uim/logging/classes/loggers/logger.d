module uim.logging.classes.loggers.logger;

import uim.core;
import uim.oop;
import uim.logging;
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
            if (isArray(value)) {
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
