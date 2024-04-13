module uim.oop.tests.fixtures.extensions.unitextension;

import uim.oop;

@safe:

// Unit extension to integrate UIM"s data-only fixtures.
class DUnitExtension : Extension {
    /**
     * @param \Unit\TextUI\Configuration\Configuration configDatauration
     * @param \Unit\Runner\Extension\Facade facade
     * @param \Unit\Runner\Extension\ParameterCollection parameters
     */
    void bootstrap(Configuration configDatauration, Facade facade, ParameterCollection parameters) {
        facade.registerSubscriber(
            new DUnitStartedSubscriber()
        );
    }
}
