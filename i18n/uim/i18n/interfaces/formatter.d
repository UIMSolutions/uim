/****************************************************************************************************************
* Copyright: © 2017-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.i18n.interfaces.formatter;

import uim.i18n;

@safe:

// Formatter Interface
interface II18NFormatter {
    // Returns a string with all passed variables interpolated into the original message.
    string format(string locale, string message, string[] tokens);
}
