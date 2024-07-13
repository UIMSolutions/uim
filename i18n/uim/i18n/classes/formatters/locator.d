module uim.i18n.classes.formatters.locator;

import uim.i18n;

@safe:

// A ServiceLocator implementation for loading and retaining formatter objects.
class DFormatterLocator {
    // A registry to retain formatter objects.
    protected II18NFormatter[string] _registry = null;

    /**
     * Tracks whether a registry entry has been converted from a
     * FQCN to a formatter object.
     */
    protected bool[] _converted;

    // registry An array of key-value pairs where the key is the formatter name the value is a FQCN for the formatter.
    this(STRINGAA registry = null) {
        //TODO registry.byKeyValue
        //TODO     .each!(nameSpec => set(nameSpec.key, nameSpec.value));
    }
    
    // Sets a formatter into the registry by name.
    void set(string formatterName, string formatterClassname) {
        _registry[formatterName] = formatterClassname;
        _converted[formatterName] = false;
    }
    
    // Gets a formatter from the registry by name.
   /*  II18NFormatters get(string formatterName) {
        if (!_registry.hasKey(formatterName)) {
            // TODO throw new DI18nException("Formatter named `%s` has not been registered.".format(name));
        }
        if (!_converted.hasKey(formatterName)) {
/*             auto formatterclassname = _registry[formatterName];
            _registry[formatterName] = cast(II18NFormatter)object.factory(formatterclassname);
            _converted[formatterName] = true; * /
        }

       /*  return _registry.get(formatterName); * /
       return II18NFormatters.NONE;  
    } */
}
