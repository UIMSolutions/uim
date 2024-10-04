/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.errors.classes.nodes.scalar;

import uim.errors;

@safe:

// Dump node for scalar values.
class DScalarErrorNode : DErrorNode {
    mixin(ErrorNodeThis!("Scalar"));
    
    this(string newType, Json newValue) {
        super();
        _type = newType;
        _value = newValue;
    }
    
    // Type of scalar data
    private string _type;

    // Get the type of value
    string getType() {
        return _type;
    }
}
