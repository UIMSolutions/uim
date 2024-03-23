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
        override void setDefault(string key, IData newData) {
            // TODO
        }

        override void updateDefaults(IData[string] newData) {
            // TODO
        }
    // #endregion defaultData
}

mixin(ConfigurationCalls!("Ini"));
