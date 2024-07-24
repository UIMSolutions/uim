/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
module uim.i18n.interfaces.catalog;

import uim.i18n;

@safe:

// Message Catalog
interface ICatalog {
    // Sets the messages for this catalog.
    ICatalog messages(string[][string] messages); 

    // Gets the messages for this catalog.
    string[][string] messages(); 

    // Adds new messages for this catalog.
    ICatalog addMessages(string[][string] messages); 

    // Adds or update one message for this catalog.
    ICatalog message(string key, string messages...); 

    // Adds or update one message for this catalog.
    ICatalog message(string key, string[] messages); 
            
    // Gets the message of the given key for this catalog.
    string[] message(string key); 
    
    // #region formatterName
        // Sets the formatter name for this catalog.
        void formatterName(string name); 
        
        // Gets the formatter name for this catalog.
        string formatterName(); 
    // #endregion formatterName
    
    // #region fallbackName
        // Sets the fallback catalog name.
        void fallbackName(string name);

        // Gets the fallback catalog name.
        string fallbackName();
    // #endregion fallbackName
}
