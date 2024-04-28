module uim.errors.classes.nodes.scalar;

import uim.errors;

@safe:

// Dump node for scalar values.
class DScalarNode : IErrorNode {
    this(string newType, Json newValue) {
        _type = newType;
        _value = newValue;
    }
    
    // Type of scalar data
    private string _type;
    // Get the type of value
    string getType() {
        return _type;
    }
    
    // Scalar value
    private Json _value;

    // Get the value
    Json getValue() {
        return _value;
    }
 
     IErrorNode[] getChildren() {
        return null;
    }
}
