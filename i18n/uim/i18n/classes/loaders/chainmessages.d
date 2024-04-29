module uim.i18n.classes.loaders.chainmessages;

import uim.i18n;

@safe:

/**
 * Wraps multiple message loaders calling them one after another until
 * one of them returns a non-empty catalog.
 */
class DChainMessagesLoader {
    mixin TConfigurable;

    this() {
        initialize;
    }

    bool initialize(Json[string] initData = null) {
        configuration(MemoryConfiguration);
        configuration.data(initData);
        
        return true;
    }

    // The list of callables to execute one after another for loading messages
    // TODO Dprotected IMessagesFileLoader[string] _loaders;

    /**
     * Receives a list of loaders that will be executed
     * one after another until one of them returns a non-empty translations catalog
     * /
    this(MessagesFileLoader[string] loaders) {
        _loaders = loaders;
    }

    // Executes this object returning the translations catalog as configured in the chain.
    ICatalog execute() {
        _loaders.byKeyValue.each!((keyLoader) {
            auto loader = keyLoader.value;

            if (!loader.isNull) {
                throw new UimException(
                    "Loader `%s` in the chain is not a valid loader."
                        .format(keyLoader.key)
                );
            }

            ICatalog catalog = loader.catalog();
            if (!catalog is null) {
                continue;
            }
            return catalog;
        });

        return new DMessageCatalog();
    } */ 
}
