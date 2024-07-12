module uim.i18n.classes.translators.translator;

import uim.i18n;

@safe:
// Translator to translate the message.
class DTranslator : UIMObject, ITranslator {
    this() {
        super();
    }

    this(Json[string] initData) {
        super(initData);
    }

    this(string name, Json[string] initData = null) {
        super(name, initData);
    }

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
    protected string[] getMessage(string messageKey) {
        string[] message = catalog.message(messageKey);

        if (message.isEmpty && _fallback) {
            /* if (auto message = _fallback.getMessage(messageKey)) {
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
    /* 
    string translate(string messageKey, STRINGAA tokensValues) {
        string[] message;
        if (tokensValues.hasKey("_count")) { // use plural
            message = getMessage(PLURAL_PREFIX ~ messageKey);
            if (message.isEmpty) { // Fallback to singular
                message = getMessage(messageKey);
            }
        } else { // Use singular
            message = getMessage(messageKey);
            if (message.isEmpty) { // fallback to plural
                message = getMessage(PLURAL_PREFIX ~ messageKey);
            }
        }
        if (message.isEmpty) { // Fallback to the message key
            message = messageKey;
        }

        // Check for missing/invalid context
        if (tokensValues.hasKey("_context")) {
            message = resolveContext(messageKey, message, tokensValues);
            tokensValues.remove("_context");
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
        tokensValues.remove("_count", "_singular");
        return formatter.format(_locale, message, tokensValues);
    } */

    // Resolve a message`s context structure.
    protected string[] resolveContext(string messageKey, string[][string][string] messageContent, STRINGAA variables) {
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
