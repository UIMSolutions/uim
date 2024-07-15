module uim.logging.classes.loggers.logger;

import uim.logging;

@safe:

// Base log engine class.
class DLogger : ILogger {   
    // Replaces placeholders in message string with context values.
    protected string interpolate(string formattedMessage, Json[string] context= null) {
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

        auto placeholders = array_intersect(matches[1], context.keys);
        auto replacements = null;
        auto JsonFlags = Json_THROW_ON_ERROR | Json_UNESCAPED_UNICODE;
        foreach (aKey; placeholders) {
            aValue = context[aKey];

            if (isScalar(aValue)) {
                replacements.set("{" ~ aKey ~ "}", to!string(aValue));
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
                replacements.set("{" ~ aKey ~ "}", Json_encode(aValue.getArrayCopy(), JsonFlags));
                continue;
            }
            if (cast(DSerializable)aValue) {
                replacements.set("{" ~ aKey ~ "}", aValue.serialize());
                continue;
            }
            if (isObject(aValue)) {
                if (method_exists(aValue, "toArray")) {
                    replacements["{" ~ aKey ~ "}"] = Json_encode(aValue.toJString(), JsonFlags);
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
    }
}
