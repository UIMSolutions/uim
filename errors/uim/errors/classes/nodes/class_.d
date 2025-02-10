/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.errors.classes.nodes.class_;

import uim.errors;

@safe:

// Dump node for objects/class instances.
class DClassErrorNode : DErrorNode {
    mixin(ErrorNodeThis!("Class"));

    this(string classname, int anId) {
        super();
        _classname = classname;
        _id = anId;
    }

    // Add a property
    void addProperty(DPropertyErrorNode node) {
        // _properties ~= node;
    }

    private string _classname;
    // Get the class name
    override Json value() {
        return Json(_classname);
    }

    private int _id;
    // Get the reference id
    int id() {
        return _id;
    }
}
