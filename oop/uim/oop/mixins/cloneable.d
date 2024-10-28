/****************************************************************************************************************
* Copyright: © 2018-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.oop.mixins.cloneable;

mixin template TCloneable() {
    O create(this O)() {
        O result;
        () @trusted { result = cast(O) this.classinfo.create; }();
        return result;
    }

    O clone(this O)() {
        return null; 
        // TODO return _create;
    }

    O clone(this O)(Json data) {
        return null; 
        // TODO return _create;
    }
}
