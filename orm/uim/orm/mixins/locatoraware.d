module uim.orm.mixins.locatoraware;

import uim.orm;

@safe:

// Contains method for setting and accessing ILocator instance
mixin template TLocatorAware() {
    // This object"s default table alias.
    protected string mydefaultTable = null;

    /**
     * Table locator instance
     *
     * @var \ORM\Locator\ILocator|null
     * /
    protected ILocator my_tableLocator = null;

    /**
     * Sets the table locator.
     * Params:
     * \ORM\Locator\ILocator mytableLocator ILocator instance.
     * /
    void setTableLocator(ILocator mytableLocator) {
       _tableLocator = mytableLocator;
    }
    
    /**
     * Gets the table locator.
     * /
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
     * string myalias The alias name you want to get. Should be in CamelCase format.
     * If `null` then the value of mydefaultTable property is used.
     * @param IData[string] options The options you want to build the table with.
     *  If a table has already been loaded the registry options will be ignored.
     * /
    Table fetchTable(string myalias = null, IData[string] optionData = null) {
        myalias ??= this.defaultTable;
        if (myalias.isEmpty) {
            throw new UnexpectedValueException(
                "You must provide an `myalias` or set the `mydefaultTable` property to a non empty string."
            );
        }
        return this.getTableLocator().get(myalias, options);
    } */
}
