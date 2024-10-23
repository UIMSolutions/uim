/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.logging.classes.formatters.formatter;

import uim.core;
import uim.oop;
import uim.logging;
@safe:

// Base class for LogFormatters
class DLogFormatter : UIMObject, ILogFormatter {
    mixin(LogFormatterThis!());
/*    mixin TLocatorAware;
    mixin TLog; */

    override bool initialize(Json[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }
    
        configuration
            .setDefault("dateFormat", "Y-m-d H:i:s")
            .setDefault("includeTags", false)
            .setDefault("includeDate", true);
    
        return true;
    }

  // Formats message.
  abstract string format(LogLevel logLevel, string logMessage, Json[string] logData = null);
}
