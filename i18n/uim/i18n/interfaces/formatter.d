/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
module uim.i18n.interfaces.formatter;

import uim.i18n;

@safe:

// Formatter Interface
interface II18NFormatter {
    // Returns a string with all passed variables interpolated into the original message.
    string format(string messageLocale, string messageToTranslate, string[] tokenValues);
}
