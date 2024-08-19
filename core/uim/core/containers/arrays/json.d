module uim.core.containers.arrays.json;

@safe:
import uim.core;

string[] getStringArray(Json[] values) {
    return values
        .filter!(value => value.isString)
        .map!(value => value.get!string).array;
}

string[] toStringArray(Json[] values) {
    return values.map!(value => value.to!string).array;
}