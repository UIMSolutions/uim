module uim.oop.mixins.cloneable;

mixin template CloneableTemplate() {
    O create(this O)() {
        O result;
        () @trusted { result = cast(DO) this.classinfo.create; }();
        return result;
    }

    O clone(this O)() {
        return this.create;
    }

    O clone(this O)(Json data) {
        return this.create;
    }
}
