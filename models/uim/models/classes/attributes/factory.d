module uim.models.classes.attributes.factory;

import uim.models;

@safe:
class DAttributeFactory {
    mixin TConfigurable;
    this() {
        this.initialize;
    }

    this(Json[string] initData) {
        this.initialize(initData);
    }

    bool initialize(Json[string] initData = null) {
        configuration(MemoryConfiguration);
        configuration.data(initData);

        return true;
    }

    // Create a new attribute based on this attribute an a giving name 
    DAttribute create(string aName, Json[string] option = null) {
        DAttribute result;

        switch (aName) {
        case "bool": return new DBooleanAttribute;
        case "byte": 
            break;
        case "ubyte": 
            break;
        case "short": 
            break;
        case "ushort": 
            break;
        case "int": 
            break;
        case "uint": 
            break;
        case "long": 
            break;
        case "ulong": 
            break;
        case "float": 
            break;
        case "double": 
            break;
        case "real": 
            break;
        case "ifloat": 
            break;
        case "idouble": 
            break;
        case "ireal": 
            break;
        case "cfloat": 
            break;
        case "cdouble": 
            break;
        case "creal": 
            break;
        case "char": 
            break;
        case "wchar": 
            break;
        case "dchar": 
            break;
        case "string": 
            break;
        case "uuid": 
            break;
        case "datetime": 
            break;
        default:
            return new DAttribute;
            break;
        }
        /*
        // result = new DAttribute(aName);
        /  * result.attribute(this);
        result.name(aName);
         */
        return result;
    }

    unittest { /// TODO
    }
}
