module uim.oop.helpers;

bool isSubclassOf(C, B)(C aClass, B aBaseClass) {
    return (cast(B)aClass ? true : false);
}