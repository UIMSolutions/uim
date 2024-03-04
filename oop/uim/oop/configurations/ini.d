module uim.oop.configurations.ini;

import uim.oop;

@safe:

class DIniConfiguration : DConfiguration {
    mixin(ConfigurationThis!("Ini"));

    override bool initialize(IData[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

        return true;
    }
}

mixin(ConfigurationCalls!("Ini"));
