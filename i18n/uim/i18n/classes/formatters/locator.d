/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.i18n.classes.formatters.locator;

import uim.i18n;
@safe:

version (test_uim_i18n) {
  unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
  }
}

// A ServiceLocator implementation for loading and retaining formatter objects.
class DFormatterLocator {
    // A locator to retain formatter objects.
    protected string[string] _classNames = null;

    // A locator to retain formatter objects.
    protected II18NFormatter[string] _formatters = null;

    // Tracks whether a locator entry has been converted from a FQCN to a formatter object.
    protected bool[string] _converted;

    // locator An array of key-value pairs where the key is the formatter name the value is a FQCN for the formatter.
    this(string[string] entries = null) {
        this.set(entries);
    }
    
    // Sets a formatter into the locator by name.
    void set(string[string] entries) {
        entries.byKeyValue.each!(entry => set(entry.key, entry.value));
    }

    void set(string key, string nameOfClass) {
        _classNames[key] = nameOfClass;
        _formatters[key] = null;
        _converted[key] = false; 
    }
    
    // Gets a formatter from the locator by name.
   II18NFormatter get(string key) {
        if (!_classNames.hasKey(key)) {
            // throw new DI18nException("Formatter named `%s` has not been registered.".format(key));
        }
        
        if (!_converted.hasKey(key)) {
            auto nameOfClass = _classNames[key];

            () @trusted { _formatters[key] = cast(DI18NFormatter)Object.factory(nameOfClass); }();
            _converted[key] = true;
        }

       return _formatters.get(key, null); 
    }
}
