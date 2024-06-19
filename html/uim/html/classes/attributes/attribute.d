module uim.html.classes.attributes.attribute;

import uim.html;

@safe:

// Wrapper for <article> - represents a self-contained composition in a document, page, application, or site, 
// which is intended to be independently distributable or reusable (e.g., in syndication)
class DH5Attribute {
    this() {
    }

    this(string name, bool isBoolean = false) {
        this().name(name);
        this().isBoolean(isBoolean);
    }

    this(string name, string value, bool isBoolean = false) {
        this().value(value);
        this().name(name);
        this().isBoolean(isBoolean);
    }

    mixin(TProperty!("string", "name"));    
    mixin(TProperty!("bool", "isBoolean"));

    mixin(TProperty!("string", "value"));
    void value(bool setValue) {
        value("true");
    }
    void value(int setValue) {
        value(to!string(setValue));
    }
    mixin(TProperty!("string", "value"));
    // TODO sanitize

    override toString() {
        return isBoolean && value !is null
            ? name
            : name ~ `="%s"`.format(value);
    }
}

auto H5Attribute() {
    return new H5Attribute;
}

auto H5Attribute(string name, bool isBoolean = false) {
    return new DH5Attribute(name, isBoolean);
}

auto H5Attribute(string name, string value, bool isBoolean = false) {
    return new DH5Attribute(name, value, isBoolean);
}
