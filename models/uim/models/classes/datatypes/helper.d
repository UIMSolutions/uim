module uim.models.datatypes.helper;

import uim.models;

@safe:

bool isEmpty(IData[string] data, string key) {
    return (data is null)
        ? true
        : data.hasKey(key); 
}

// #region toData
/*
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

    IData[string] toData(STRINGAA values) {
        IData[string] data;
        values.byKeyValue.each!(kv => data[kv.key] = StringData(kv.value));
        return data;
    }
// #endregion toData
*/
/*
string getString(IData[string] data, string key, string fallback = null) {
    if (auto mydata = data.get(key, null)) { 
        return mydata.toString; 
    }

    return fallback;
}

int getInteger(IData[string] data, string key, int fallback = 0) {
    if (auto mydata = data.get(key, null)) { 
        return mydata.toInteger; 
    }

    return fallback;
}

long getLong(IData[string] data, string key, long fallback = 0) {
    if (auto mydata = data.get(key, null)) { 
        return mydata.toLong; 
    }

    return fallback;
}

string[] getStringArray(IData data) {
    return null; 
    //TODO return data.map!(d => d.toString).array;
}

string[] getStringArray(IData[] data) {
    return data.map!(d => d.toString).array;
}

string[] getStringArray(IData[string] data, string[] keys) {
    string[] results;
    keys
        .filter!(key => key in data)
        .each!(key => results ~= data[key].toString);

    return results;
}

STRINGAA getStringMap(IData[string] data, string[] keys) {
    STRINGAA results;
    keys
        .filter!(key => key in data)
        .each!(key => results[key] = data[key].toString);

    return results;
}*/