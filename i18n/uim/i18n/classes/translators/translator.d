module uim.i18n.classes.translators.translator;

import uim.i18n;

@safe:
// Translator to translate the message.
class DTranslator : UIMObject, ITranslator {
    mixin(TranslatorThis!());

    override bool initialize(Json[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }
        
        return true;
    }

    const string PLURAL_PREFIX = "p:";

    // A fallback translator.
    protected ITranslator _fallback = null;

    // The formatter to use when translating messages.
    protected II18NFormatter _formatter;

    // The locale being used for translations.
    protected string _localename;

    // Get / Set the catalog containing keys and translations.
    mixin(TProperty!("ICatalog", "catalog"));

    this(
        string localeName,
        ICatalog messageCatalog,
        II18NFormatter messageFormatter,
        ITranslator fallbackTranslator = null
   ) {
        /* _locale = localeName;
        _catalog(messageCatalog);
        _formatter = messageFormatter;
        _fallback = fallbackTranslator; */
    }

    // Gets the message translation by its key.
    protected string[] message(string key) {
        string[] message = _catalog.get(key);

        if (message.isEmpty && _fallback) {
            /* if (auto message = _fallback.message(messageKey)) {
                catalog.addMessage(messageKey, message);
            } */
        }

        return message;
    }

    unittest {
        // TODO Unittest
        // auto translator = new DI18NTranslator()
    }

    // Translates the message formatting any placeholders
    string translate(string key, string[string] tokensValues) {
        string[] message;
    /* 
        if (tokensValues.hasKey("_count")) { // use plural
            message = message(PLURAL_PREFIX ~ messageKey);
            if (message.isEmpty) { // Fallback to singular
                message = message(messageKey);
            }
        } else { // Use singular
            message = message(messageKey);
            if (message.isEmpty) { // fallback to plural
                message = message(PLURAL_PREFIX ~ messageKey);
            }
        } */ 
        if (message.isEmpty) { // Fallback to the message key
            message = [key];
        }

        // Check for missing/invalid context
        /* if (tokensValues.hasKey("_context")) {
            message = resolveContext(messageKey, message, tokensValues);
            tokensValues.removeKey("_context");
        }
        if (tokensValues.isEmpty) { // Fallback for plurals that were using the singular key
            return message ~ [""].values[0];
        }

        // Singular message, but plural call
        if (tokensValues.hasKey("_singular")) {
            message = [tokensValues["_singular"], message];
        }

        // Resolve plural form.
        size_t count = to!size_t(tokensValues.get("_count", 0));
        auto form = PluralRules.calculate(this.locale, to!int(count));
        message = message.ifNull(form, (string) end(message));

        if (message.isEmpty) {
            message = messageKey;

            // If singular haven`t been translated, fallback to the key.
            if (tokensValues.hasKey("_singular") && tokensValues.getLong("_count") == 1) {
                message = tokensValues["_singular"];
            }
        }
        tokensValues.removeKey("_count", "_singular");
        return formatter.format(_locale, message, tokensValues); */
        return null; 
    } 

    // Resolve a message`s context structure.
    protected string[] resolveContext(string messageKey, string[][string][string] messageContent, string[string] variables) {
        auto context = variables.get("_context", null);

        string[][string] messageContext = messageContent.get("_context", null);
        if (messageContext.isEmpty) {
            return [messageKey];
        }

        // No or missing context, fallback to the key/first message
        string[] result;
        /* if (context.isNull) { // No context
            result = messageContext.get("", null);
            return result.isEmpty
                ? [messageKey] : result;
        } */

        result = messageContext.get(context, null);
        return result.isEmpty
            ? [messageKey] : result;
    }

}
