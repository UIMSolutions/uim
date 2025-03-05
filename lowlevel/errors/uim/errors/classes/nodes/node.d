/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.errors.classes.nodes.node;

import uim.errors;
@safe:

version (test_uim_errors) {
  unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
  }
}

class DErrorNode : UIMObject, IErrorNode {
    mixin(ErrorNodeThis!());

    protected Json _value;
    Json value() {
        return _value;
    }
    IErrorNode value(Json json) {
        _value = json;
        return this;
    }
    
    // Get Item nodes
    protected IErrorNode[] _children;
    IErrorNode[] children() {
        return _children;
    }
}
unittest {
    Json json = Json.emptyObject;
    json["a"] = 1;

    auto node = new DErrorNode;
    node.value(json);
    assert(node.value["a"] == 1);
    assert(node.children.length == 0);
}