module uim.i18n.classes.formatters.locator;

import uim.i18n;

@safe:

// A ServiceLocator implementation for loading and retaining formatter objects.
class DFormatterLocator {
    // A locator to retain formatter objects.
    protected string[string] _formatters = null;

    // Tracks whether a locator entry has been converted from a FQCN to a formatter object.
    protected bool[] _converted;

    // locator An array of key-value pairs where the key is the formatter name the value is a FQCN for the formatter.
    this(STRINGAA entries = null) {
        this.set(entries);
    }
    
    // Sets a formatter into the locator by name.
    void set(string[string] entries) {
        entries.byKeyValue.each!(entry => set(entry.key, entry.value));
    }

    void set(string key, string classname) {
        _formatters[key] = classname;
        _converted[key] = false; 
    }
    
    // Gets a formatter from the locator by name.
   /* II18NFormatters get(string formatterName) {
        if (!_formatters.hasKey(formatterName)) {
            // TODO throw new DI18nException("Formatter named `%s` has not been registered.".format(name));
        }
        if (!_converted.hasKey(formatterName)) {
/*            auto formatterclassname = _formatters[formatterName];
            _formatters[formatterName] = cast(II18NFormatter)object.factory(formatterclassname);
            _converted[formatterName] = true; * /
        }

       /* return _formatters.get(formatterName); * /
       return II18NFormatters.NONE;  
    } */
}
