module uim.logging.classes.loggers.logger;

import uim.logging;

@safe:

// Base log engine class.
abstract class Logger /* : AbstractLogger */ {
    mixin TConfigurable!();

    this() {
        initialize;
        this.name("Logger");  
    }

    this(string name) { 
        this(); 
        this.name(name); 
    }

    bool initialize(IData[string] initData = null) {
        configuration(MemoryConfiguration);
        setConfigurationData(initData);
        
        return true;
    }

    mixin(TProperty!("string", "name"));

    /* .updateDefaults([
        "levels": [],
        "scopes": [],
        "formatter": DefaultFormatter.classname,
    ]); * /

    protected ILogFormatter formatter;

    this(IData[string] configData = null) {
        configuration.update(configData);

        if (!configuration["scopes").isNull) {
           configuration["scopes", configuration["scopes").toArray);
        }
        configuration["levels", configuration["levels").toArray);

        if (!configuration["types").isEmpty && configuration["levels").isEmpty) {
           configuration["levels", configuration["types").toArray);
        }

        auto formatter = hasconfiguration["formatter") ? configuration["formatter") : DefaultFormatter.classname;
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
    } */
    
    // Get the levels this logger is interested in.
    string[] levels() {
        // TODO
        return null; //return configuration["levels");
    }
    
    // Get the scopes this logger is interested in.
    string[] scopes() {
        // TODO
        return null; //return configuration["scopes");
    }
    
    /**
     * Replaces placeholders in message string with context values.
     * Params:
     * \string amessage Formatted message.
     * @param array context Context for placeholder values.
     * /
    protected string interpolate(string formattedMessage, array context = []) {
        if (!formattedMessage.has("{", "}")) {
            return formattedMessage;
        }
        /* preg_match_all(
            "/(?<!" ~ preg_quote("\\", "/") ~ ")\{([a-z0-9-_]+)\}/i",
            formattedMessage,
            matches
        ); * /
        if (isEmpty(matches)) {
            return formattedMessage;
        }
        placeholders = array_intersect(matches[1], context.keys);
        replacements = [];
        jsonFlags = JSON_THROW_ON_ERROR | JSON_UNESCAPED_UNICODE;

        foreach (aKey; placeholders) {
            aValue = context[aKey];

            if (isScalar(aValue)) {
                replacements["{" ~ aKey ~ "}"] = to!string(aValue);
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
        /** @psalm-suppress InvalidArgument * /
        return formattedMessage.replace(replacements.keys, replacements);
    } */
    
}
