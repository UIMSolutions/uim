module uim.logging.classes.loggers.logger;

import uim.logging;

@safe:

// Base log engine class.
class DLogger : ILogger {   
    mixin TConfigurable;

    this() {
        initialize;
        this.name("Logger");  
    }

    this(string name) { 
        this(); 
        this.name(name); 
    }

    this(Json[string] initData) { 
        this(); 
        this.initialize(initData); 
    }

    bool initialize(Json[string] initData = null) {
        configuration(MemoryConfiguration);
        configuration.data(initData);
        
        configuration.updateDefaults([
            "levels": Json.emptyArray,
            "scopes": Json.emptyArray,
            // TODO "formatter": DefaultFormatter.classname
        ]); 

        // TODO
        /*
        if (!configuration.get("scopes").isNull) {
           configuration.get("scopes", configuration.get("scopes").toArray);
        }
        configuration.get("levels", configuration.get("levels").toArray);

        if (!configuration.get("types").isEmpty && configuration.get("levels").isEmpty) {
           configuration.get("levels", configuration.get("types").toArray);
        }

        auto formatter = hasconfiguration.get("formatter") ? configuration.get("formatter") : DefaultFormatter.classname;
        if (!isObject(formatter)) {
            if (isArray(formatter)) {
                className = formatter["className"];
                options = formatter;
            } else {
                className = formatter;
                auto options = null;
            }
            formatter = new className(options);
        }
        _formatter = formatter; 
        */
        return true;
    }

    mixin(TProperty!("string", "name"));

    protected ILogFormatter _formatter;

    // Get the levels this logger is interested in.
    string[] levels() {
        return null; 
        // return configuration.get("levels").getStringArray;
    }
    
    // Get the scopes this logger is interested in.
    string[] scopes() {
        return null; 
        // return configuration.get("scopes").getStringArray;
    }

/*
    /**
     * Replaces placeholders in message string with context values.
     * Params:
     * \string amessage Formatted message.
     * @param Json[string] context DContext for placeholder values.
     */
    protected string interpolate(string formattedMessage, Json[string] context = []) {
        if (!formattedMessage.has("{", "}")) {
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
        placeholders = array_intersect(matches[1], context.keys);
        replacements = null;
        JsonFlags = Json_THROW_ON_ERROR | Json_UNESCAPED_UNICODE;

        foreach (aKey; placeholders) {
            aValue = context[aKey];

            if (isScalar(aValue)) {
                replacements["{" ~ aKey ~ "}"] = to!string(aValue);
                continue;
            }
            if (isArray(aValue)) {
                replacements["{" ~ aKey ~ "}"] = Json_encode(aValue, JsonFlags);
                continue;
            }
            if (cast(JsonSerializable)aValue) {
                replacements["{" ~ aKey ~ "}"] = Json_encode(aValue, JsonFlags);
                continue;
            }
            if (cast(DArrayObject)aValue) {
                replacements["{" ~ aKey ~ "}"] = Json_encode(aValue.getArrayCopy(), JsonFlags);
                continue;
            }
            if (cast(DSerializable)aValue) {
                replacements["{" ~ aKey ~ "}"] = aValue.serialize();
                continue;
            }
            if (isObject(aValue)) {
                if (method_exists(aValue, "toArray")) {
                    replacements["{" ~ aKey ~ "}"] = Json_encode(aValue.toArray(), JsonFlags);
                    continue;
                }
                if (cast(DSerializable)aValue) {
                    replacements["{" ~ aKey ~ "}"] = serialize(aValue);
                    continue;
                }
                if (cast(DStringable)aValue) {
                    replacements["{" ~ aKey ~ "}"] = to!string(aValue);
                    continue;
                }
                if (method_exists(aValue, "__debugInfo")) {
                    replacements["{" ~ aKey ~ "}"] = Json_encode(aValue.__debugInfo(), JsonFlags);
                    continue;
                }
            }
            replacements["{" ~ aKey ~ "}"] = "[unhandled value of type %s]".format(get_debug_type(aValue));
        }
        /** @psalm-suppress InvalidArgument */
        return formattedMessage.replace(replacements.keys, replacements);
    } */
}
