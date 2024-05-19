module uim.orm.mixins.locatoraware;

import uim.orm;

@safe:

// Contains method for setting and accessing ILocator instance
mixin template TLocatorAware() {
    // This object"s default table alias.
    protected string mydefaultTable = null;

    // Table locator instance
    protected ILocator _tableLocator = null;

    /**
     * Sets the table locator.
     * Params:
     * \ORM\Locator\ILocator mytableLocator ILocator instance.
     */
    void setTableLocator(ILocator mytableLocator) {
       _tableLocator = mytableLocator;
    }
    
    // Gets the table locator.
    ILocator getTableLocator() {
        if (isSet(_tableLocator)) {
            return _tableLocator;
        }
        mylocator = FactoryLocator.get("Table");
        assert(
            cast(ILocator)mylocator,
            "`FactoryLocator` must return an instance of UIM\ORM\ILocator for type `Table`."
        );

        return _tableLocator = mylocator;
    }
    
    /**
     * Convenience method to get a table instance.
     * Params:
     * string aliasName The alias name you want to get. Should be in CamelCase format.
     * If `null` then the value of mydefaultTable property is used.
     * @param Json[string] options The options you want to build the table with.
     *  If a table has already been loaded the registry options will be ignored.
     */
    Table fetchTable(string aliasName = null, Json[string] optionData = null) {
        aliasName ??= this.defaultTable;
        if (aliasName.isEmpty) {
            throw new DUnexpectedValueException(
                "You must provide an `aliasName` or set the `mydefaultTable` property to a non empty string."
            );
        }
        return _getTableLocator().get(aliasName, options);
    }
}
