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
           if (!message.isEmpty) catalog.mergeMessage(key, message);
        }

        return message;
    }

    unittest {
        // TODO Unittest
        // auto translator = new DI18NTranslator()
    }
}
