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
    // #region messages
        // Sets the messages for this catalog.
        ICatalog messages(string[][string] messages); 

        // Gets the messages for this catalog.
        string[][string] messages(); 
    // #endregion messages

    // #region set
        // Set message
        ICatalog set(string[][string] messages); 

        ICatalog set(string key, string messages...); 

        // Adds or update one message for this catalog.
        ICatalog set(string key, string[] messages); 
    // #endregion set

    // #region get
        // Get message
        string[][string] get(string[] keys); 

        string[] get(string key); 
    // #region get
    
    // #region formatterName
        // Sets the formatter name for this catalog.
        ICatalog formatterName(string name); 
        
        // Gets the formatter name for this catalog.
        string formatterName(); 
    // #endregion formatterName
    
    // #region fallbackName
        // Sets the fallback catalog name.
        ICatalog fallbackName(string name);

        // Gets the fallback catalog name.
        string fallbackName();
    // #endregion fallbackName
}
