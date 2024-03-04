module uim.oop.configurations.yaml;

import uim.oop;
@safe:

class DYamlConfiguration : DFileConfiguration {
    mixin(ConfigurationThis!("Yaml"));
}
mixin(ConfigurationCalls!("Yaml"));