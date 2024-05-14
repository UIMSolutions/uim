module uim.oop.configurations.json;

import uim.oop;

@safe:

class DJsonConfiguration : DFileConfigEngineuration {
    mixin(ConfigurationThis!("Json"));

    override bool initialize(Json[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

        return true;
    }

    // #region defaultData
    override bool hasDefault(string key) {
        return false; // TODO
    }

    override void updateDefault(string key, Json newData) {
        // TODO
    }

    override void mergeDefault(string key, Json newData) {
        // TODO
    }
    // #endregion defaultData

    override string[] allKeys() {
        return null; //TODO
    }

    override void set(string key, Json newData) {

    }

    override void update(string key, Json newData) {
        // _json.hasKey()
    }

    override void update(string key, Json[string] newData) {
        // _json.hasKey()
    }

    override void merge(string key, Json newData) {
        // TODO 
    }

    override void merge(string key, Json[string] newData) {
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
