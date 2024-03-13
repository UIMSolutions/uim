module uim.oop.helpers.helper;

import uim.oop;

@safe:

IData toData(bool value) {
    return BooleanData(value);
}
unittest {
    auto data = true.toData;
    assert(cast(DBooleanData)data);
    assert((cast(DBooleanData)data).value);

    data = false.toData;
    assert(cast(DBooleanData)data);
    assert(!(cast(DBooleanData)data).value);
}

IData toData(int value) {
    return IntegerData(value);
}
unittest {
    auto data = 100.toData;
    assert(cast(DIntegerData)data);
    assert((cast(DIntegerData)data).value == 100);

    data = 1.toData;
    assert(!cast(DStringData)data);
}

IData toData(long value) {
    return IntegerData(value);
}
unittest {
    auto data = 100.toData;
    assert(cast(DIntegerData)data);
    assert((cast(DIntegerData)data).value == 100);

    data = 1.toData;
    assert(!cast(DStringData)data);
}

IData toData(string value) {
    return StringData(value);
}
unittest {
    auto data = "hallo".toData;
    assert(cast(DStringData)data);
    assert((cast(DStringData)data).value == "hallo");

    data = 1.toData;
    assert(!cast(DStringData)data);
}

IData toData(Json value) {
    if (value.isString) {
        return toData(value.get!string);
    }
    return null;
    // TODO
}