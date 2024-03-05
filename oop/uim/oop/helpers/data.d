module oop.uim.oop.helpers.data;

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
    assert((cast(DIntegerData)data).value = "hallo");

    data = 1.toData;
    assert(!cast(DStringData)data);
}

IData toData(long value) {
    return LongData(value);
}
unittest {
    auto data = 100.toData;
    assert(cast(DIntegerData)data);
    assert((cast(DIntegerData)data).value = "hallo");

    data = 1.toData;
    assert(!cast(DStringData)data);
}

IData toData(string value) {
    return StringData(value);
}
unittest {
    auto data = "hallo".toData;
    assert(cast(DStringData)data);
    assert((cast(DStringData)data).value = "hallo");

    data = 1.toData;
    assert(!cast(DStringData)data);
}