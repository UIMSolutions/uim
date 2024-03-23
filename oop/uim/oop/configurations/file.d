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

    // #region defaultData

    override void set(string path, IData newData) {
        
    }

    override void setDefault(string key, IData newData) {
        // TODO
    }

    override void updateDefaults(IData[string] newData) {
        // TODO
    }
    // #endregion defaultData

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

mixin(ConfigurationCalls!("File"));
