/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.attribute;

import uim.models;

@safe:
class DAttribute : /* DEntity,  */IAttribute {
    mixin TConfigurable!();

    this() {
        initialize;
    }

    bool initialize(IData[string] initData = null) {
        configuration(MemoryConfiguration);
        setConfigurationData(initData);
        
        return true;
    }
    
      mixin(AttributeThis!("Attribute"));

  // Initialization hook method.
  /* override  */bool initialize(IData[string] initData = null) { 
    /* if (!super.initialize(initData)) { return false; } */ 
    
    return true;
}

	// Data type of the attribute. 
  mixin(TProperty!("string[]", "dataFormats")); 
  bool hasDataFormat(string dataFormatName) {
    foreach(df; dataFormats) if (df == dataFormatName) { return true; }
    return false;
  }

  void addDataFormats(string[] newDataFormats) {
    foreach(df; newDataFormats) {
      if (!hasDataFormat(df)) _dataFormats ~= df;
    }
    
  }

  mixin(TProperty!("UUID", "id"));  
  mixin(TProperty!("string", "name"));  
  mixin(TProperty!("string", "display"));  
  mixin(TProperty!("string", "registerPath"));  
  mixin(TProperty!("bool", "isNullable"));
  mixin(TProperty!("STRINGAA", "descriptions"));
  mixin(TProperty!("string", "valueType")); // Select the data type of the property.")); // 
  mixin(TProperty!("string", "keyType")); // Select the data type of the property.")); // 
  mixin(TProperty!("string", "dataType_display")); // ")); // 
  mixin(TProperty!("long", "defaultValueLong")); // Shows the default value of the property for a whole number data type.")); // 
  mixin(TProperty!("string", "defaultValueString")); // Shows the default value of the property for a string data type.")); // 
  //mixin(TProperty!("string", "defaultValueDecimal")); // Shows the default value of the property for a decimal data type.")); // 
  mixin(TProperty!("string", "baseDynamicPropertyId")); // Shows the property in the product family that this property is being inherited from.")); // 
  mixin(TProperty!("string", "overwrittenDynamicPropertyId")); // Shows the related overwritten property.")); // 
  mixin(TProperty!("string", "rootDynamicPropertyId")); // Shows the root property that this property is derived from.")); // 
  /* mixin(TProperty!("string", "minValueDecimal")); // Shows the minimum allowed value of the property for a decimal data type.")); // 
  mixin(TProperty!("string", "maxValueDecimal")); // Shows the maximum allowed value of the property for a decimal data type.")); //  */
  mixin(TProperty!("uint", "precision")); // Shows the allowed precision of the property for a whole number data type.")); // 
  mixin(TProperty!("string", "stateCode")); // Shows the state of the property.")); // 
  mixin(TProperty!("string", "stateCode_display")); // ")); // 
  mixin(TProperty!("string", "statusCode")); // Shows whether the property is active or inactive.")); // 
  mixin(TProperty!("string", "statusCode_display")); // ")); // 
  mixin(TProperty!("string", "regardingObjectId")); // Choose the product that the property is associated with.")); // 
  mixin(TProperty!("double", "defaultValueDouble")); // Shows the default value of the property for a double data type.")); // 
  mixin(TProperty!("double", "minValueDouble")); // Shows the minimum allowed value of the property for a double data type.")); // 
  mixin(TProperty!("double", "maxValueDouble")); // Shows the maximum allowed value of the property for a double data type.")); // 
  mixin(TProperty!("long", "minValueLong")); // Shows the minimum allowed value of the property for a whole number data type.")); // 
  mixin(TProperty!("long", "maxValueLong")); // Shows the maximum allowed value of the property for a whole number data type.")); // 
  mixin(TProperty!("bool", "isArray")); 
  mixin(TProperty!("bool", "isDouble")); 
  mixin(TProperty!("bool", "isString")); 
  mixin(TProperty!("bool", "isJson")); 
  mixin(TProperty!("bool", "isXML")); 
  mixin(TProperty!("bool", "isAssociativeArray")); 
  mixin(TProperty!("bool", "isReadOnly")); // Defines whether the attribute is read-only or if it can be edited.")); // 
  mixin(TProperty!("bool", "isHidden")); // Defines whether the attribute is hidden or shown.")); // 
  mixin(TProperty!("bool", "isRequired")); // Defines whether the attribute is mandatory.")); // 
  mixin(TProperty!("uint", "maxLengthString")); // Shows the maximum allowed length of the property for a string data type.")); // 
  mixin(TProperty!("string", "defaultValueOptionSet")); // Shows the default value of the property.

  mixin(TProperty!("UUID", "attribute")); // Super attribute.

 /*  void attribute(UUID myId, size_t myMajor = 0, size_t myMinor = 0) { 
    _attribute = Attribute.id(myId).versionMajor(myMajor).versionMinor(myMinor);
     }

  void attribute(string myName, size_t myMajor = 0, size_t myMinor = 0) { 
    _attribute = Attribute.name(myName).versionMajor(myMajor).versionMinor(myMinor);
     }

  void attribute(DAttribute myAttclass) { 
    _attribute = myAttclass;     
     } */

  // Create a new attribute based on this attribute - using attribute name 
/*   auto createAttribute() {
    return createAttribute(_name); } */

  IData createValue() {
    return NullData; }

  /* // Create a new attribute based on this attribute an a giving name 
  auto createAttribute(string aName) {
    DAttribute result;
    switch(this.valueType) {
      case "bool": break; 
      case "byte": break; 
      case "ubyte": break; 
      case "short": break; 
      case "ushort": break; 
      case "int": break; 
      case "uint": break; 
      case "long": break; 
      case "ulong": break; 
      case "float": break; 
      case "double": break; 
      case "real": break; 
      case "ifloat": break; 
      case "idouble": break; 
      case "ireal": break; 
      case "cfloat": break; 
      case "cdouble": break; 
      case "creal": break; 
      case "char": break; 
      case "wchar": break; 
      case "dchar": break; 
      case "string": break; 
      case "uuid": break; 
      case "datetime": break; 
      default: break;
    }
    // result = new DAttribute(aName);
/ *     result.attribute(this);
    result.name(aName); * /
    return result;
  }
  version(test_uim_models) { unittest {    /// TODO
    }
  } */

  /* override  */void fromJson(Json aJson) {
    if (aJson.isEmpty) {return; }
    /* super.fromJson(aJson); */

    foreach (keyvalue; aJson.byKeyValue) {
      auto k = keyvalue.key;
      auto v = keyvalue.value;
      switch(k) {
        case "attribute": this.attribute(UUID(v.get!string)); break;
        case "isNullable": this.isNullable(v.get!bool); break;
        case "valueType": this.valueType(v.get!string); break;
        case "keyType": this.keyType(v.get!string); break;
        case "dataType_display": this.dataType_display(v.get!string); break;
        case "defaultValueLong": this.defaultValueLong(v.get!long); break;
        case "defaultValueString": this.defaultValueString(v.get!string); break;
        case "baseDynamicPropertyId": this.baseDynamicPropertyId(v.get!string); break;
        case "overwrittenDynamicPropertyId": this.overwrittenDynamicPropertyId(v.get!string); break;
        case "rootDynamicPropertyId": this.rootDynamicPropertyId(v.get!string); break;
        case "precision": this.precision(v.get!int); break;
        case "stateCode": this.stateCode(v.get!string); break;
        case "stateCode_display": this.stateCode_display(v.get!string); break;
        case "statusCode": this.statusCode(v.get!string); break;
        case "statusCode_display": this.statusCode_display(v.get!string); break;
        case "regardingObjectId": this.regardingObjectId(v.get!string); break;
        case "defaultValueDouble": this.defaultValueDouble(v.get!double); break;
        case "minValueDouble": this.minValueDouble(v.get!double); break;
        case "maxValueDouble": this.maxValueDouble(v.get!double); break;
        case "minValueLong": this.minValueLong(v.get!long); break;
        case "maxValueLong": this.maxValueLong(v.get!long); break;
        case "isReadOnly": this.isReadOnly(v.get!bool); break;
        case "isHidden": this.isHidden(v.get!bool); break;
        case "isRequired": this.isRequired(v.get!bool); break;
        case "isArray": this.isArray(v.get!bool); break;
        case "isAssociativeArray": this.isAssociativeArray(v.get!bool); break;
        case "maxLengthString": this.maxLengthString(v.get!int); break;
        case "defaultValueOptionSet": this.defaultValueOptionSet(v.get!string); break;
        default: break;
      }      
    }
  }

  // Convert data to json (using vibe's funcs)
  /* override  */Json toJson(string[] showFields = null, string[] hideFields = null) {
    auto result = Json.emptyObject;

    // Fields
    result["isNullable"] = this.isNullable;
    result["valueType"] = this.valueType;
    result["keyType"] = this.keyType;
    result["dataType_display"] = this.dataType_display; 
    result["defaultValueLong"] = this.defaultValueLong; 
    result["defaultValueString"] = this.defaultValueString; 
    result["baseDynamicPropertyId"] = this.baseDynamicPropertyId; 
    result["overwrittenDynamicPropertyId"] = this.overwrittenDynamicPropertyId; 
    result["rootDynamicPropertyId"] = this.rootDynamicPropertyId; 
    result["precision"] = this.precision; 
    result["stateCode"] = this.stateCode; 
    result["stateCode_display"] = this.stateCode_display; 
    result["statusCode"] = this.statusCode; 
    result["statusCode_display"] = this.statusCode_display; 
    result["regardingObjectId"] = this.regardingObjectId; 
    result["defaultValueDouble"] = this.defaultValueDouble; 
    result["minValueDouble"] = this.minValueDouble;
    result["maxValueDouble"] = this.maxValueDouble;
    result["minValueLong"] = this.minValueLong;
    result["maxValueLong"] = this.maxValueLong;
    result["isReadOnly"] = this.isReadOnly;
    result["isHidden"] = this.isHidden;
    result["isRequired"] = this.isRequired;
    result["isArray"] = this.isArray;
    result["isAssociativeArray"] = this.isAssociativeArray;
    result["maxLengthString"] = this.maxLengthString;
    result["defaultValueOptionSet"] = this.defaultValueOptionSet;

    result["attribute"] = this.attribute.toString;

    return result;
  }
  version(test_uim_models) { unittest {    /// TODO
    }
  }

/*   alias opIndexAssign = DElement.opIndexAssign;
  alias opIndexAssign = DEntity.opIndexAssign; */
}
auto Attribute() { return new DAttribute; }
auto Attribute(UUID id) { return new DAttribute(id); }
auto Attribute(string name) { return new DAttribute(name); }
auto Attribute(UUID id, string name) { return new DAttribute(id, name); }
auto Attribute(Json json) { return new DAttribute(json); }
// auto Attribute(DEntityCollection aCollection, Json json) { return (new DAttribute(json)).collection(aCollection); }