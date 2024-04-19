module uim.errors.classes.nodes.class_;

import uim.errors;

@safe:

// Dump node for objects/class instances.
class DClassNode : IErrorNode {
    this(string className, int anId) {
        _className = className;
        _id = anId;
    }

    private DPropertyNode[] properties = null;
    /**
     * Add a property
     * Params:
     * \UIM\Error\Debug\PropertyNode node The property to add.
     */
    void addProperty(DPropertyNode node) {
        this.properties ~= node;
    }

    // Get property nodes
    DPropertyNode[] getChildren() {
        return _properties;
    }

    private string _className;
    // Get the class name
    string getValue() {
        return _className;
    }

    private int _id;
    // Get the reference id
    int getId() {
        return _id;
    }
}
