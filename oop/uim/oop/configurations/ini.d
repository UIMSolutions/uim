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

    override string[] allPaths() {
        return null; //TODO
    }

override void set(string path, IData newData) {
        
    }

        override void update(string path, IData newData) {
        // TODO 
    }

    override void merge(string path, IData newData) {
        // TODO 
    }

    override void remove(string path) {
        // TODO 
    }
}

mixin(ConfigurationCalls!("Ini"));
