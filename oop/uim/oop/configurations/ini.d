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

    override string[] allKeys() {
        return null; //TODO
    }

    override void set(string key, IData newData) {

    }

    override void update(string key, IData newData) {
        // TODO 
    }

    override void update(string key, IData[string] newData) {
        // TODO 
    }

    override void merge(string key, IData newData) {
        // TODO 
    }

    override void merge(string key, IData[string] newData) {
        // TODO 
    }

    override IConfiguration remove(string key) {
        // TODO 
        return this;
    }
}

mixin(ConfigurationCalls!("Ini"));

unittest {
    testConfiguration(MemoryConfiguration);
}
