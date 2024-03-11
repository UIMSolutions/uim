module uim.logging.classes.loggers.logger;

import uim.logging;

@safe:

// Base log engine class.
abstract class Logger /* : AbstractLogger */ {
    this() { name("Logger"); initialize; }
    this(string name) { this(); name(name); }

    mixin ConfigForClass;

//     mixin InstanceConfigTemplate;

    protected IConfiguration _configuration;
    /* .updateDefaults([
        "levels": [],
        "scopes": [],
        "formatter": DefaultFormatter.classname,
    ]); */

    protected IFormatter formatter;

    this(IData[string] configData = null) {
        configuration.update(configData);

        if (!configuration.data("scopes").isNull) {
           configuration.data("scopes", configuration.data("scopes").toArray);
        }
        configuration.data("levels", configuration.data("levels").toArray);

        if (!configuration.data("types").isEmpty && configuration.data("levels").isEmpty) {
           configuration.data("levels", configuration.data("types").toArray);
        }

        auto formatter = hasconfiguration.data("formatter") ? configuration.data("formatter") : DefaultFormatter.classname;
        if (!isObject(formatter)) {
            if (isArray(formatter)) {
                className = formatter["className"];
                options = formatter;
            } else {
                className = formatter;
                auto options = [];
            }
            formatter = new className(options);
        }
        _formatter = formatter;
    }
    
    // Get the levels this logger is interested in.
    string[] levels() {
        return configuration.data("levels");
    }
    
    // Get the scopes this logger is interested in.
    string[] scopes() {
        return configuration.data("scopes");
    }
    
    /**
     * Replaces placeholders in message string with context values.
     * Params:
     * \string amessage Formatted message.
     * @param array context Context for placeholder values.
     */
    protected string interpolate(string formattedMessage, array context = []) {
        if (!formattedMessage.has("{", "}")) {
            return formattedMessage;
        }
        preg_match_all(
            "/(?<!" ~ preg_quote("\\", "/") ~ ")\{([a-z0-9-_]+)\}/i",
            formattedMessage,
            matches
        );
        if (isEmpty(matches)) {
            return formattedMessage;
        }
        placeholders = array_intersect(matches[1], context.keys);
        replacements = [];
        jsonFlags = JSON_THROW_ON_ERROR | JSON_UNESCAPED_UNICODE;

        foreach (aKey; placeholders) {
            aValue = context[aKey];

            if (isScalar(aValue)) {
                replacements["{" ~ aKey ~ "}"] = (string)aValue;
                continue;
            }
            if (isArray(aValue)) {
                replacements["{" ~ aKey ~ "}"] = json_encode(aValue, jsonFlags);
                continue;
            }
            if (cast(JsonSerializable)aValue) {
                replacements["{" ~ aKey ~ "}"] = json_encode(aValue, jsonFlags);
                continue;
            }
            if (cast(ArrayObject)aValue) {
                replacements["{" ~ aKey ~ "}"] = json_encode(aValue.getArrayCopy(), jsonFlags);
                continue;
            }
            if (cast(Serializable)aValue) {
                replacements["{" ~ aKey ~ "}"] = aValue.serialize();
                continue;
            }
            if (isObject(aValue)) {
                if (method_exists(aValue, "toArray")) {
                    replacements["{" ~ aKey ~ "}"] = json_encode(aValue.toArray(), jsonFlags);
                    continue;
                }
                if (cast(Serializable)aValue) {
                    replacements["{" ~ aKey ~ "}"] = serialize(aValue);
                    continue;
                }
                if (cast(Stringable)aValue) {
                    replacements["{" ~ aKey ~ "}"] = to!string(aValue);
                    continue;
                }
                if (method_exists(aValue, "__debugInfo")) {
                    replacements["{" ~ aKey ~ "}"] = json_encode(aValue.__debugInfo(), jsonFlags);
                    continue;
                }
            }
            replacements["{" ~ aKey ~ "}"] = "[unhandled value of type %s]".format(get_debug_type(aValue));
        }
        /** @psalm-suppress InvalidArgument */
        return formattedMessage.replace(replacements.keys, replacements);
    }
}
