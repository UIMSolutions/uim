/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.i18n.interfaces.translator;

import uim.i18n;

@safe:

// Translator to translate the message.
interface ITranslator {
    // Translates the message formatting any placeholders
    string translate(string messageKey, STRINGAA tokensValues);
    
    // Returns the translator catalog
    void catalog(ICatalog newCatalog);
    ICatalog catalog();
}