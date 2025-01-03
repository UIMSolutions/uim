/****************************************************************************************************************
* Copyright: © 2017-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.html.classes.attributes.attribute;

import uim.html;

@safe:

// Wrapper for <article> - represents a self-contained composition in a document, page, application, or site, 
// which is intended to be independently distributable or reusable (e.g., in syndication)
class DH5Attribute {
    this() {
    }

    this(string name, bool isBoolean = false) {
        this.name(name);
        this.isBoolean(isBoolean);
    }

    this(string name, string value, bool isBoolean = false) {
        this.value(value);
        this.name(name);
        this.isBoolean(isBoolean);
    }

    mixin(TProperty!("string", "name"));
    mixin(TProperty!("bool", "isBoolean"));

    mixin(TProperty!("string", "value"));
    @property void value(bool setValue) {
        value("true");
    }

    @property void value(int setValue) {
        value(to!string(setValue));
    }

    @property void value(double setValue) {
        value(to!string(setValue));
    } // TODO sanitize

    override string toString() {
        return isBoolean && value !is null
            ? name : name ~ `="%s"`.format(value);
    }
}

auto H5Attribute() {
    return new DH5Attribute;
}

auto H5Attribute(string name, bool isBooleanAttribute = false) {
    return new DH5Attribute(name, isBooleanAttribute);
}

auto H5Attribute(string name, string value, bool isBooleanAttribute = false) {
    return new DH5Attribute(name, value, isBooleanAttribute);
}
