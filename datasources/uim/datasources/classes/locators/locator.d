module uim.datasources.classes.locators.locator;

import uim.datasources;

@safe:

class DDatasourceLocator : UIMObject, IDatasourceLocator {
    mixin(DatasourceLocatorThis!());

    // Instances that belong to the registry.
    protected IDatasourceRepository[string] _instances;

    // Contains a list of options that were passed to get() method.
    protected Json[string] _options = null;

}

unittest {
    // TODO Unittest
}
