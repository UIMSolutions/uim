module uim.oop.mixins.cloneable;

mixin template TCloneable() {
    O create(this O)() {
        O result;
        () @trusted { result = cast(O) this.classinfo.create; }();
        return result;
    }

    O clone(this O)() {
        return this.create;
    }

    O clone(this O)(Json data) {
        return this.create;
    }
}
