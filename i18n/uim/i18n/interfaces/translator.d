/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.i18n.interfaces.translator;import uim.i18n;@safe:// Translator to translate the message.interface ITranslator {    // Translates the message formatting any placeholders    // TODO string translate(string messageKey, string[string] tokensValues);        // Returns the translator catalog    void catalog(ICatalog newCatalog);    ICatalog catalog();}