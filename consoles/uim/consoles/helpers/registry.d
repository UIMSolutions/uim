module uim.consoles.helpers.registry;

import uim.consoles;

@safe:

/**
 * Registry for Helpers. Provides features
 * for lazily loading helpers.
 *
 * @extends \UIM\Core\ObjectRegistry<\UIM\Console\Helper>
 */
class DHelperRegistry : UIMObject { // }: ObjectRegistry {
    this() {
        initialize;
    }

    this(Json[string] initData) {
        initialize(initData);
    }

    override bool initialize(Json[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

        return true;
    }

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
     */
    protected string _resolveclassname(string classname) {
        /* return App.classname(classname, "Command/Helper", "Helper"); */
        return null;
    }

    /**
     * Throws an exception when a helper is missing.
     *
     * Part of the template method for UIM\Core\ObjectRegistry.load()
     * and UIM\Core\ObjectRegistry.unload()
     */
    protected void _throwMissingClassError(string classname, string pluginName) {
        /* throw new DMissingHelperException(createMap!(string, Json)
            .set("class", classname)
            .set("plugin", pluginName)
        ); */
    }

    /**
     * Create the helper instance.
     * Part of the template method for UIM\Core\ObjectRegistry.load()
     */
    // TODO protected DHelper _create(object obj, string helperAlias, Json[string] initData) {

/*     protected DHelper _create(string classnameToCreate, string helperAlias, Json[string] initData) {
        return new classname(_io, initData);
    }  */
}
