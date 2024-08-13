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
    protected string interpolate(string formattedMessage, Json[string] context = null) {
        if (!formattedMessage.contains("{", "}")) {
            return formattedMessage;
        }
        /* preg_match_all(
            "/(?<!" ~ preg_quote("\\", "/") ~ ")\{([a-z0-9-_]+)\}/i",
            formattedMessage,
            matches
       ); */
        if (isEmpty(matches)) {
            return formattedMessage;
        }

        auto placeholders = intersect(matches[1], context.keys);
        auto replacements = null;
        auto JsonFlags = Json_THROW_ON_ERROR | Json_UNESCAPED_UNICODE;
        foreach (aKey; placeholders) {
            auto value = context[aKey];

            if (isScalar(aValue)) {
                replacements.set("{" ~ aKey ~ "}", value.toString);
                continue;
            }
            if (isArray(aValue)) {
                replacements.set("{" ~ aKey ~ "}", Json_encode(aValue, JsonFlags));
                continue;
            }
            if (cast(JsonSerializable)aValue) {
                replacements.set("{" ~ aKey ~ "}", Json_encode(aValue, JsonFlags));
                continue;
            }
            if (cast(DJson[string])aValue) {
                replacements.set("{" ~ aKey ~ "}", Json_encode(aValue.dup, JsonFlags));
                continue;
            }
            if (cast(DSerializable)aValue) {
                replacements.set("{" ~ aKey ~ "}", aValue.serialize());
                continue;
            }
            if (isObject(aValue)) {
                if (hasMethod(aValue, "toArray")) {
                    replacements.set("{" ~ aKey ~ "}", Json_encode(aValue.toJString(), JsonFlags));
                    continue;
                }
                if (cast(DSerializable)aValue) {
                    replacements.set("{" ~ aKey ~ "}", serialize(aValue));
                    continue;
                }
                if (cast(DStringable)aValue) {
                    replacements.set("{" ~ aKey ~ "}", to!string(aValue));
                    continue;
                }
                if (hasMethod(aValue, "__debugInfo")) {
                    replacements.set("{" ~ aKey ~ "}", Json_encode(aValue.__debugInfo(), JsonFlags));
                    continue;
                }
            }
            replacements.set("{" ~ aKey ~ "}", "[unhandled value of type %s]".format(get_debug_type(aValue)));
        }
        /** @psalm-suppress InvalidArgument */
        return formattedMessage.replace(replacements.keys, replacements);
    }
}
