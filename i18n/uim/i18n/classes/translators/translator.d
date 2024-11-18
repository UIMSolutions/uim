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

    // #region constants
    const string PLURAL_PREFIX = "p:";
    // #endregion constants

    // A fallback translator.
    protected ITranslator _fallbackTranslator = null;

    // The formatter to use when translating messages.
    protected II18NFormatter _formatter;

    // The locale being used for translations.
    protected string _localName;

    // Get / Set the catalog containing keys and translations.
    protected IMessageCatalog _catalog;
    @property IMessageCatalog catalog() {
        return _catalog;
    }

    @property ITranslator catalog(IMessageCatalog newCatalog) {
        _catalog = newCatalog;
        return this;
    }

    // Gets the message translation by its key.
    protected string[] message(string key) {
        string[] message = _catalog.message(key);

        if (message.isEmpty && _fallbackTranslator) {
            message = _fallbackTranslator.message(key);
            if (!message.isEmpty)
                catalog.mergeMessage(key, message);
        }

        return message;
    }

    unittest {
        // TODO Unittest
        // auto translator = new DI18NTranslator()
    }

    // Translates the message formatting any placeholders
    string[] translate(string messageKey, string[string] settings) {
        string[] translatedMessage;

        if (settings.hasKey("_count")) { // use plural
            translatedMessage = message(PLURAL_PREFIX ~ messageKey);
            if (translatedMessage.isEmpty) { // Fallback to singular
                translatedMessage = message(messageKey);
            }
        } else { // Use singular
            translatedMessage = message(messageKey);
            if (translatedMessage.isEmpty) { // fallback to plural
                translatedMessage = message(PLURAL_PREFIX ~ messageKey);
            }
        }
        if (translatedMessage.isEmpty) { // Fallback to the message key
            translatedMessage = [messageKey];
        }

        // TODO
        // Check for missing/invalid context
        if (settings.hasKey("_context")) {
            /*             message = resolveContext(messageKey, message, tokensValues);
            tokensValues.removeKey("_context");
 */
        }
        if (settings.isEmpty) { // Fallback for plurals that were using the singular key
            // return translatedMessage ~ [""].values[0];
        }

        // Singular message, but plural call
        if (settings.hasKey("_singular")) {
            // translatedMessage = [tokensValues["_singular"], message];
        }

        // Resolve plural form.
        /*         size_t count = to!size_t(tokensValues.get("_count", 0));
        auto form = PluralRules.calculate(this.locale, to!int(count));
        translatedMessage = translatedMessage.ifNull(form, (string) end(message));

        if (translatedMessage.isEmpty) {
            translatedMessage = messageKey;

            // If singular haven`t been translated, fallback to the key.
            if (tokensValues.hasKey("_singular") && tokensValues.getLong("_count") == 1) {
                translatedMessage = tokensValues["_singular"];
            }
        }
        tokensValues.removeKey("_count", "_singular");
        return formatter.format(_locale, translatedMessage, tokensValues); */

        return translatedMessage;
    }

    // Resolve a message`s context structure.
    protected string[] resolveContext(string messageKey, string[][string][string] messageContent, string[string] settings) {
        string context = settings.get("_context", null);

        string[][string] messageContext = messageContent.get("_context", null);
        if (messageContext.isEmpty) {
            return [messageKey];
        }

        // No or missing context, fallback to the key/first message
        string[] result;
        if (context.isNull) { // No context
            string[] resolved = messageContext.get("", null);
            return resolved.isEmpty
                ? [messageKey] : resolved;
        }

        string[] resolved = messageContext.get(context, null);
        return resolved.isEmpty
            ? [messageKey] : resolved;
    }
}
