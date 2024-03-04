module uim.oop.configurations.file;

import uim.oop;

@safe:

class DFileConfiguration : DConfiguration {
    mixin(ConfigurationThis!("File"));

    override bool initialize(IData[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }
        
        return true;
    }
}

mixin(ConfigurationCalls!("File"));
