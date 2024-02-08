module uim.oop.data.string_;

import uim.oop;

@safe:

class StringData : DData {
    this() {
        // initialize;
    }

    this(string newValue) {
        _value = newValue;
    }

    this(T)(T newValue) {
        super();
        _value = to!string(newValue);
    }

    mixin(TProperty!("string", "value"));

    override Json toJson(string[] selectedKeys = null) {
        return Json(_value);
    }

    override string toString() {
        return _value;
    }
}
