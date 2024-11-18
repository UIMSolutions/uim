module uim.i18n.interfaces.translator;

import uim.i18n;

@safe:

// Message Catalog
interface ITranslator {
    ITranslator catalog(IMessageCatalog newCatalog);
    IMessageCatalog catalog();
    string[] message(string key);
}