module uim.i18n.interfaces.translator;

import uim.i18n;

@safe:

// Translator to translate the message.
interface ITranslator {
    // Translates the message formatting any placeholders
    // TODO string translate(string messageKey, string[string] tokensValues);
    
    // Returns the translator catalog
    IMessageCatalog catalog();    
    ITranslator catalog(IMessageCatalog newCatalog);
    
    string[] message(string key);
}