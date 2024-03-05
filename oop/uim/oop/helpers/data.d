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

IData toData(string value) {
    return StringData(value);
}
unittest {
    auto data = "hallo".toData;
    assert(cast(StringData)data);
    assert((cast(StringData)data).value = "hallo");

    data = 1.toData;
    assert(!cast(StringData)data);
}