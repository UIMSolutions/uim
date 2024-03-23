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
        override void setDefault(string key, IData newData) {
            // TODO
        }

        override void updateDefaults(IData[string] newData) {
            // TODO
        }
    // #endregion defaultData
}

mixin(ConfigurationCalls!("Json"));
