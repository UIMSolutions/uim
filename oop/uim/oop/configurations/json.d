module uim.oop.configurations.json;

import uim.oop;

@safe:

class DJsonConfiguration : DConfiguration {
    mixin(ConfigurationThis!("Json"));

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

        override void updateDefaults(IData[string] newData) {
            // TODO
        }

        override void mergeDefaults(IData[string] newData) {
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

mixin(ConfigurationCalls!("Json"));
