module uim.oop.base.serviceprovider;

import uim.oop;

@safe:

/**
 * Container ServiceProvider
 *
 * Service provider bundle related services together helping
 * to organize your application`s dependencies. They also help
 * improve performance of applications with many services by
 * allowing service registration to be deferred until services are needed.
 */
abstract class DServiceProvider { /* : DAbstractServiceProvider, IBootableServiceProvider {
    /**
     * List of ids of services this provider provides.
     * @see ServiceProvider.provides()
     * /
    protected string[] provides = null;

    /**
     * Get the container.
     * /
    IDefinitionContainer getContainer() {
        container = super.getContainer();

        assert(
            cast(IContainer)container,
            "Unexpected container type. Expected `%s` got `%s` instead."
                .format(IContainer.classname, get_debug_type(container)
            )
        );

        return container;
    }
    
    /**
     * Delegate to the bootstrap() method
     *
     * This method wraps the league/container auto so users
     * only need to use the UIM bootstrap() interface.
     * /
    void boot() {
        this.bootstrap(this.getContainer());
    }
    
    /**
     * Bootstrap hook for ServiceProviders
     *
     * This hook should be implemented if your service provider
     * needs to register additional service providers, load configuration
     * files or do any other work when the service provider is added to the
     * container.
     * Params:
     * \UIM\Core\IContainer container The container to add services to.
     * /
    void bootstrap(IContainer container) {
    }
    
    /**
     * Call the abstract services() method.
     *
     * This method primarily exists as a shim between the interface
     * that league/container has and the one we want to offer in UIM.
     * /
    void register() {
        this.services(this.getContainer());
    }
    
    /**
     * The provides method is a way to let the container know that a service
     * is provided by this service provider.
     *
     * Every service that is registered via this service provider must have an
     * alias added to this array or it will be ignored.
     * Params:
     * string aid Identifier.
     * /
   bool provides(string aid) {
        return in_array(anId, this.provides, true);
    }
    
    /**
     * Register the services in a provider.
     *
     * All services registered in this method should also be included in the provides
     * property so that services can be located.
     * Params:
     * \UIM\Core\IContainer container The container to add services to.
     * /
    abstract void services(IContainer container);
    */
}
