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
        // _json.hasKey()
    }

    override void update(string key, IData[string] newData) {
        // _json.hasKey()
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

mixin(ConfigurationCalls!("Json"));

unittest {
    testConfiguration(MemoryConfiguration);
}
