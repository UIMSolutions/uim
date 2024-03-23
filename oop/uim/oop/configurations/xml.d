module uim.oop.configurations.xml;

import uim.oop;
@safe:

class DXmlConfiguration : DFileConfiguration {
    mixin(ConfigurationThis!("Xml"));

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
mixin(ConfigurationCalls!("Xml"));