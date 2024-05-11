module uim.i18n.classes.formatters.locator;

import uim.i18n;

@safe:

/*
 * A ServiceLocator implementation for loading and retaining formatter objects.
 *
 * @internal
 */
class DFormatterLocator {
    // A registry to retain formatter objects.
    protected II18NFormatter[string] registry = null;

    /**
     * Tracks whether a registry entry has been converted from a
     * FQCN to a formatter object.
     */
    protected bool[] converted;

    // registry An array of key-value pairs where the key is the formatter name the value is a FQCN for the formatter.
    this(STRINGAA registry = null) {
        //TODO registry.byKeyValue
        //TODO     .each!(nameSpec => set(nameSpec.key, nameSpec.value));
    }
    
    /**
     * Sets a formatter into the registry by name.
     * Params:
     * string aName The formatter name.
     * @param class-string<\UIM\I18n\II18NFormatter>  className A FQCN for a formatter.
     */
    void set(string formatterName, string className) {
        this.registry[formatterName] = className;
        this.converted[formatterName] = false;
    }
    
    // Gets a formatter from the registry by name.
    II18NFormatter get(string formatterName) {
        if (!this.registry.isSet(formatterName)) {
            // TODO throw new DI18nException("Formatter named `%s` has not been registered.".format(name));
        }
        if (!this.converted[formatterName]) {
            auto formatterClassName = this.registry[formatterName];
            this.registry[formatterName] = cast(II18NFormatter)object.factory(formatterClassName);
            this.converted[formatterName] = true;
        }

        return _registry[formatterName];
    } */
}
