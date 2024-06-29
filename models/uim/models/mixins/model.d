/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel, mailto:ons@sicherheitsschmiede.de                                                      
**********************************************************************************************************/
module uim.models.mixins.model;

import uim.models;
@safe:

string modelThis(string name) {
    string fullName = name ~ "Model";
    return `
    this() {
        super(); this.name("`
        ~ fullName ~ `");
    }
    this(Json[string] initData) {
        super(initData); this.name("`~ fullName ~ `");
    }
    this(string name, Json[string] initData = null) {
        super(name, initData);
    }
    `;
    
      /* return `
    this() { super("`~name~`"); this.classname("`~name~`"); }
    this(Json[string] configSettings = nullData) { super("`~name~`", configData); }
    this(IModelManager aManager, Json[string] configData = null) { this(configData).application(aManager); }

    this(string aName, Json[string] configData = null) { this(configData).name(aName); }
    this(STRINGAA someParameters, Json[string] configData = null) { this(configData).parameters(someParameters); }

    this(IModelManager aManager, string aName, Json[string] configData = null) { this(aManager, configData).name(aName); }
    this(IModelManager aManager, STRINGAA someParameters, Json[string] configData = null) { this(aManager, configData).parameters(someParameters); }

    this(string aName, STRINGAA someParameters, Json[string] configData = null) { this(name, configData).parameters(someParameters); }
    this(IModelManager aManager, string aName, STRINGAA someParameters, Json[string] configData = null) { this(aManager, name, configData).parameters(someParameters); }
  `; */
}

template ModelThis(string name) {
  const char[] ModelThis = modelThis(name);
}

string modelCalls(string name) {
  string fullName = name ~ "Model";
  return `
    auto `~ fullName ~ `() { return new D` ~ fullName ~ `();}
    auto `~ fullName ~ `(Json[string] initData) { return new D` ~ fullName ~ `(initData);}
    auto `~ fullName ~ `(string name, Json[string] initData = null) { return new D` ~ fullName ~ `(name, initData); }
  `;  
  /* return `
    auto `~shortName~`() { return new `~classname~`; }
    auto `~shortName~`(IModelManager aManager) { return new `~classname~`(aManager); }
    auto `~shortName~`(string aName) { return new `~classname~`(aName); }
    auto `~shortName~`(STRINGAA someParameters) { return new `~classname~`(someParameters); }

    auto `~shortName~`(string aName, STRINGAA someParameters) { return new `~classname~`(aName, someParameters); }

    auto `~shortName~`(IModelManager aManager, string aName) { return new `~classname~`(aManager, aName); }
    auto `~shortName~`(IModelManager aManager, STRINGAA someParameters) { return new `~classname~`(aManager, someParameters); }
  `; */
}

template ModelCalls(string name) {
  const char[] ModelCalls = modelCalls(name);
}
