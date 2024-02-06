module uim.oop.mixins.configurable;

import uim.oop;

@safe:

mixin template TConfigurable() {
    protected IConfiguration _configuration;
    @property IConfiguration configuration() {
        return _configuration;
    }
    @property void configuration(IConfiguration newConfiguration) {
        _configuration = newConfiguration;
    }
}