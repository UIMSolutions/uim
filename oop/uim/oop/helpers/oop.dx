module uim.oop.helpers.oop;

import uim.oop;

@safe:
bool isSubclassOf(C, B)(C aClass, B aBaseClass) {
    return (cast(B)aClass ? true : false);
}

bool isNull(Object instance) {
    return (instance.isNull);
}

/* Found in web:
bool isNull(T)(T value) if (is(T == class) || isPointer!T) {
	return value is null;
}
*/