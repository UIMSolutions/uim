module uim.orm.classes.tables.locator;

import uim.orm;

@safe:

// Provides a default registry/factory for Table objects.
class DORMTableLocator : UIMObject { // TODO }: DAbstractLocator : ILocator {
    // Contains a list of locations where table classes should be looked for.
    protected string[] _locations = null;

    // Whether fallback class should be used if a table class DCould not be found.
    protected bool _allowFallbackClass = true;
    /**
     * Set if fallback class should be used.
     *
     * Controls whether a fallback class should be used to create a table
     * instance if a concrete class for alias used in `get()` could not be found.
     */
    void allowFallbackClass(bool enableFallback) {
        _allowFallbackClass = enableFallback;
    }
    bool allowFallbackClass() {
        return _allowFallbackClass;
    }

    // Instances that belong to the registry.
    protected DORMTable[string] _instances = null;

    /**
     * Contains a list of Table objects that were created out of the
     * built-in Table class. The list is indexed by table alias */
    protected DORMTable[] _fallbacked = null;

    // Fallback class to use
    // TODO protected string _fallbackclassname = (new DORMTable).classname;
}
