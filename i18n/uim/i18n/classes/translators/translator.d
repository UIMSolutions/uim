module uim.i18n.classes.translators.translator;

import uim.i18n;

@safe:
/**
 * Translator to translate the message.
 *
 * @internal
 */
class Translator : ITranslator {
    // Initialization
    bool initialize(IData[string] configData = null) {
        return true;
    }

    const string PLURAL_PREFIX = "p:";

    // A fallback translator.
    protected Translator _fallback = null;

    // The formatter to use when translating messages.
    protected II18NFormatter _formatter;

    // The locale being used for translations.
    protected string _localename;

    // Get / Set the catalog containing keys and translations.
    mixin(TProperty!("ICatalog", "catalog"));

    /**
     * Constructor
     * Params:
     * string localename The locale being used.
     * @param \UIM\I18n\MessageCatalog catalog The catalog containing keys and translations.
     * @param \UIM\I18n\II18NFormatter formatter A message formatter.
     * @param \UIM\I18n\Translator|null fallback A fallback translator.
     */
    this(
        string localeName,
        ICatalog catalog,
        II18NFormatter messageFormatter,
        Translator fallback = null
    ) {
        _locale = localeName;
        _catalog(catalog);
        _formatter = messageFormatter;
        _fallback = fallback;
    }

    // Gets the message translation by its key.
    protected string[] getMessage(string messageKey) {
        string[] message = catalog.message(messageKey);

        if (message.isEmpty && _fallback) {
            if (message = _fallback.getMessage(messageKey)) {
                catalog.addMessage(messageKey, message);
            }
        }

        return message;
    }

    unittest {
        // TODO Unittest
        // auto translator = new I18NTranslator()
    }

    // Translates the message formatting any placeholders
    string translate(string messageKey, STRINGAA tokensValues) {
        string[] message;
        if (tokensValues.isSet("_count")) { // use plural
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
        if (tokensValues.isSet("_context")) {
            message = resolveContext(messageKey, message, tokensValues);
            tokensValues.unSet("_context");
        }
        if (tokensValues.isEmpty) { // Fallback for plurals that were using the singular key
            return message ~ [""]).values[0];
        }

        // Singular message, but plural call
        if (tokensValues.isSet("_singular")) {
            message = [tokensValues["_singular"], message];
        }

        // Resolve plural form.
        size_t count = to!size_t(tokensValues.get("_count", 0));
        auto form = PluralRules.calculate(this.locale, to!int(count));
        message = message[form] ?  ? (string) end(message);

        if (message.isEmpty) {
            message = messageKey;

            // If singular haven`t been translated, fallback to the key.
            if (isSet(tokensValues["_singular"]) && tokensValues["_count"] == 1) {
                message = tokensValues["_singular"];
            }
        }
        tokensValues.unset("_count", "_singular");
        return formatter.format(_locale, message, tokensValues);
    }

    // Resolve a message`s context structure.
    protected string[] resolveContext(string messageKey, string[][string][string] messageContent, STRINGAA variables) {
        auto context = variables.get("_context", null);

        string[][string] messageContext = messageContent.get("_context", null);
        if (messageContext.isEmpty) {
            return [messageKey];
        }

        // No or missing context, fallback to the key/first message
        string[] result;
        if (context.isNull) { // No context
            result = messageContext.get("", null);
            return result.isEmpty
                ? [messageKey] : result;
        }

        result = messageContext.get(context, null);
        return result.isEmpty
            ? [messageKey] : result;
    }

}
