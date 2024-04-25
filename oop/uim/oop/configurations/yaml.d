module uim.oop.configurations.yaml;

import uim.oop;
@safe:

class DYamlConfiguration : DFileConfiguration {
    mixin(ConfigurationThis!("Yaml"));

    override bool initialize(IData[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

        return true;
    }
    
    // #region defaultData
        override bool hasDefault(string key) {
            return false; // TODO
        }

        override void updateDefault(string key, IData newData) {
            // TODO
        }

        override void mergeDefault(string key, IData newData) {
            // TODO
        }
    // #endregion defaultData

    override string[] allKeys() {
        return null; //TODO
    }

    override void set(string key, IData newData) {
        
    }

    override void update(string key, IData newData) {
        // TODO 
    }

    override void merge(string key, IData newData) {
        // TODO 
    }

    override IConfiguration remove(string key) {
        // TODO 
        return this;
    }
}
mixin(ConfigurationCalls!("Yaml"));

unittest {
    testConfiguration(MemoryConfiguration);
}
