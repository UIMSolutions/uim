module uim.oop.tests.containerstub;

import uim.oop;

@safe:

/**
 * A set of methods used for defining container services
 * in test cases.
 *
 * This template leverages the `Application.buildContainer` event
 * to inject the mocked services into the container that the
 * application uses.
 */
mixin template TContainerStub() {
    // The customized application class name.
    protected string _appClass = null;

    // The customized application constructor arguments.
    protected Json[string] _appArgs = null;

    // The collection of container services.
    private array containerServices = null;

    // Configure the application class to use in integration tests.
    void configApplication(string classname, Json[string] constructorArgs) {
       _appClass = classname;
       _appArgs = constructorArgs;
    }
    
    /**
     * Create an application instance.
     * Uses the configuration set in `configApplication()`.
     */
    protected IHttpApplication /*|IConsoleApplication */ createApp() {
        appClass = _appClass
            ? _appClass
            : configuration.getString("App.namespace") ~ "\\Application";

        if (!class_exists(appClass)) {
            throw new DLogicException("Cannot load `%s` for use in integration testing.".format(appClass));
        }
        appArgs = _appArgs ? _appArgs : [CONFIG];

        auto app = null; // TODO new appClass(...appArgs);
        if (!this.containerServices.isEmpty && method_exists(app, "getEventManager")) {
            app.getEventManager().on("Application.buildContainer", [this, "modifyContainer"]);
        }
        return app;
    }
    
    /**
     * Add a mocked service to the container.
     *
     * When the container is created the provided classname
     * will be mapped to the factory function. The factory
     * auto will be used to create mocked services.
     */
    void mockService(string classname, Closure closureFactory) {
        this.containerServices[classname] = closureFactory;
    }

    // Remove a mocked service to the container.
    void removeMockService(string classname) {
        removeByKey(this.containerServices[classname]);
    }

    /**
     * Wrap the application`s container with one containing mocks.
     *
     * If any mocked services are defined, the application`s container
     * will be replaced with one containing mocks. The original
     * container will be set as a delegate to the mock container.
     */
    void modifyContainer(IEvent anEvent, IContainer containerToWrap) {
        if (isEmpty(this.containerServices)) {
            return;
        }
        _containerServices.byKeyValue.each!((keyFactory) {
            if (containerToWrap.has(keyFactory.key)) {
                try {
                    containerToWrap.extend(keyFactory.key).setConcrete(keyFactory.value);
                } catch (DNotFoundException exception) {
                    containerToWrap.add(keyFactory.key, keyFactory.value);
                }
            } else {
                containerToWrap.add(keyFactory.key, keyFactory.value);
            }
        });
        anEvent.setResult(containerToWrap);
    }
    
    /**
     * Clears any mocks that were defined and cleans
     * up application class DConfiguration.
     *
     * @after
     */
    void cleanupContainer() {
       _appArgs = null;
       _appClass = null;
        l__containerServices = null;
    }
}

