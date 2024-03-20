module source.uim.cake.tests.fixtures.extensions.unitextension;

import uim.cake;

@safe:

// PHPUnit extension to integrate UIM"s data-only fixtures.
class PHPUnitExtension : Extension {
    /**
     * @param \PHPUnit\TextUI\Configuration\Configuration configDatauration
     * @param \PHPUnit\Runner\Extension\Facade facade
     * @param \PHPUnit\Runner\Extension\ParameterCollection parameters
     */
    void bootstrap(Configuration configDatauration, Facade facade, ParameterCollection parameters) {
        facade.registerSubscriber(
            new PHPUnitStartedSubscriber()
        );
    }
}
