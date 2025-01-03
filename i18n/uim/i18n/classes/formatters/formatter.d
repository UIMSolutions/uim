/****************************************************************************************************************
* Copyright: © 2017-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.i18n.classes.formatters.formatter;

import uim.i18n;

@safe:

// A formatter that will interpolate variables using the MessageFormatter class
class DI18NFormatter : UIMObject, II18NFormatter {
    mixin(I18NFormatterThis!());
    
    // Returns a string with all passed variables interpolated into the original message. 
    string format(string local, string message, string[] tokens) {
        return message;
    }
}

unittest {
    auto formatter = new DI18NFormatter;
    assert(formatter.format("en", "", null) == ""); 
    assert(formatter.format("en", "message", null) == "message"); 

    assert(formatter.format("en", "", ["A", "B"]) == ""); 
    assert(formatter.format("en", "message", ["A", "B"]) == "message"); 
}
