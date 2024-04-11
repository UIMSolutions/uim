module uim.consoles.classes.helpers.registry;

import uim.consoles;

@safe:

/**
 * Registry for Helpers. Provides features
 * for lazily loading helpers.
 *
 * @extends \UIM\Core\ObjectRegistry<\UIM\Console\Helper>
 */
class DHelperRegistry { // }: ObjectRegistry {
    mixin TConfigurable!();

    this() {
        initialize;
    }

    this(IData[string] initData) {
        initialize(initData);
    }

    bool initialize(IData[string] initData = null) {
        configuration(MemoryConfiguration);
        configuration.data(initData);

        return true;
    }

    mixin(TProperty!("string", "name"));
    /* 
    // IO instance.
    protected IConsoleIo _io;

    // Sets The IO instance that should be passed to the shell helpers
    void setIo(IConsoleIo aConsoleIo) {
        _io = aConsoleIo;
    }

    /**
     * Resolve a helper classname.
     * Part of the template method for {@link \UIM\Core\ObjectRegistry.load()}.
     * /
    protected string _resolveClassName(string className) {
        return App.className(className, "Command/Helper", "Helper");
    }

    /**
     * Throws an exception when a helper is missing.
     *
     * Part of the template method for UIM\Core\ObjectRegistry.load()
     * and UIM\Core\ObjectRegistry.unload()
     * /
    protected void _throwMissingClassError(string className, string pluginName) {
        throw new MissingHelperException([
            "class": className,
            "plugin": pluginName,
        ]);
    }

    /**
     * Create the helper instance.
     *
     * Part of the template method for UIM\Core\ObjectRegistry.load()
     * Params:
     * \UIM\Console\Helper|class-string<\UIM\Console\Helper> className The classname to create.
     * configData - An array of settings to use for the helper.
     * /
    protected DHelper _create(object obj, string helperAlias, IData[string] configData) {
        return obj;
    }

    protected DHelper _create(string className, string helperAlias, IData[string] configData) {
        return new className(_io, configData);
    } */
}
