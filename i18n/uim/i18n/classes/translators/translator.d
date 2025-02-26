module uim.i18n.classes.translators.translator;

import uim.i18n;

@safe:

version (test_uim_i18n) {
  unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
  }
}

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

  // #region fallbackTranslator
  // A fallback translator.
  protected ITranslator _fallbackTranslator = null;
  ITranslator fallbackTranslator() {
    return _fallbackTranslator;
  }
  ITranslator fallbackTranslator(ITranslator newFallback) {
    _fallbackTranslator = newFallback;
    return this;
  }
  // #endregion fallbackTranslator

  // The formatter to use when translating messages.
  protected II18NFormatter _formatter;

  // #region locale
  // The locale being used for translations.
  protected string _locale;
  string locale() {
    return locale;
  }

  ITranslator locale(string newLocale) {
    _locale = newLocale;
    return this;
  }
  // #endregion locale

  // #region catalog
  // Get / Set the catalog containing keys and translations.
  protected IMessageCatalog _catalog;
  @property IMessageCatalog catalog() {
    return _catalog;
  }

  @property ITranslator catalog(IMessageCatalog newCatalog) {
    _catalog = newCatalog;
    return this;
  }
  // #endregion catalog

  // Gets the message translation by its key.
  protected string[] message(string key, string[] defaultMessage = null) {
    if (_catalog is null) {
      return _fallbackTranslator is null
        ? defaultMessage : _fallbackTranslator.message(key);
    }

    string[] message = _catalog.message(key);
    if (message.isEmpty && _fallbackTranslator !is null) {
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
  string[] translate(string key, string[string] options) {
    string[] translatedMessage;

    if (options.hasKey("_count")) { // Use plural if possible
      translatedMessage = message(PLURAL_PREFIX ~ key, message(key)); // Not Plural found use Singular
    } else { // Use singular if possible
      translatedMessage = message(key, message(PLURAL_PREFIX ~ key)); // Not Singular found us Plural
    }
    if (translatedMessage.isEmpty) { // Fallback to the message key
      translatedMessage = [key];
    }

    // TODO
    // Check for missing/invalid context
    if (options.hasKey("_context") && catalog !is null) {
      // translatedMessage = resolveContext(key, catalog.messages, options);
      options.removeKey("_context");
    }
    if (options.isEmpty) { // Fallback for plurals that were using the singular key
      // return translatedMessage ~ [""].values[0];
    }

    // Singular message, but plural call
    if (options.hasKey("_singular")) {
      // translatedMessage = [options["_singular"], message];
    }

    // Resolve plural form.
    /*         size_t count = to!size_t(options.get("_count", 0));
        auto form = PluralRules.calculate(this.locale, to!int(count));
        translatedMessage = translatedMessage.ifNull(form, (string) end(message));

        if (translatedMessage.isEmpty) {
            translatedMessage = key;

            // If singular haven`t been translated, fallback to the key.
            if (options.hasKey("_singular") && options.getLong("_count") == 1) {
                translatedMessage = options["_singular"];
            }
        }
        options.removeKey("_count", "_singular");
        return formatter.format(_locale, translatedMessage, options); */

    return translatedMessage;
  }

  // Resolve a message`s context structure.
  protected string[] resolveContext(string key, string[][string][string] messageContent, string[string] options) {
    if ("_context" in messageContent) {
      return [key];
    }

    string context = options.get("_context", null);
    string[][string] messageContext = messageContent.get("_context", null);

    // No or missing context, fallback to the key/first message
    string[] result;
    if (context.isNull) { // No context
      string[] resolved = messageContext.get("", null);
      return resolved.isEmpty
        ? [key] : resolved;
    }

    string[] resolved = messageContext.get(context, null);
    return resolved.isEmpty
      ? [key] : resolved;
  }
}

unittest {
  auto translator = new DTranslator;
  // assert(translator.locale("de_De").locale == "de_De");
}
