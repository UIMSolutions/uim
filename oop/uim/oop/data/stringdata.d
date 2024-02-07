module uim.oop.data.stringdata;

import uim.oop;

@safe:

class StringData : DData {
    this() {
        initialize;
    }
    this(string newValue) {
        _value = newValue;
    }

    protected string _newValue;
}