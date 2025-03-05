/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.errors.classes.nodes.scalar;

import uim.errors;
@safe:

version (test_uim_errors) {
  unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
  }
}

// Dump node for scalar values.
class DScalarErrorNode : DErrorNode {
    mixin(ErrorNodeThis!("Scalar"));
    
    this(string newType, Json newValue) {
        super();
        _type = newType;
        _value = newValue;
    }
    
    // #region type
    // Type of scalar data
    private string _type;
    // Get the type of value
    string type() {
        return _type;
    }
    IErrorNode type(string aType) {
        _type = aType;
        return this;
    }
    // #endregion type
}
unittest {
    Json json = Json.emptyObject;   
    json["a"] = 1;
    
    auto node = new DScalarErrorNode("int", json);
    assert(node.value["a"] == 1);
    assert(node.type == "int");
    assert(node.children.length == 0);
}
