module uim.errors.classes.nodes.scalar;

import uim.errors;

@safe:

// Dump node for scalar values.
class DScalarNode : IErrorNode {

    // Type of scalar data
    private string _type;

    // Scalar value
    private IData _value;

    this(string newType, IData newValue) {
        _type = newType;
        _value = newValue;
    }
    
    // Get the type of value
    string getType() {
        return _type;
    }
    
    // Get the value
    IData getValue() {
        return _value;
    }
 
     IErrorNode[] getChildren() {
        return null;
    }
}
