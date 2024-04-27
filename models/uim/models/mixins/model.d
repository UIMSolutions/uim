/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel, mailto:ons@sicherheitsschmiede.de                                                      
**********************************************************************************************************/
module uim.models.mixins.model;

import uim.models;
@safe:

string modelThis(string name) {
  return `
    this() { super("`~name~`"); this.className("`~name~`"); }
    this(Json[string] configSettings = nullData) { super("`~name~`", configData); }
    this(IModelManager aManager, Json[string] configData = null) { this(configData).application(aManager); }

    this(string aName, Json[string] configData = null) { this(configData).name(aName); }
    this(STRINGAA someParameters, Json[string] configData = null) { this(configData).parameters(someParameters); }

    this(IModelManager aManager, string aName, Json[string] configData = null) { this(aManager, configData).name(aName); }
    this(IModelManager aManager, STRINGAA someParameters, Json[string] configData = null) { this(aManager, configData).parameters(someParameters); }

    this(string aName, STRINGAA someParameters, Json[string] configData = null) { this(name, configData).parameters(someParameters); }
    this(IModelManager aManager, string aName, STRINGAA someParameters, Json[string] configData = null) { this(aManager, name, configData).parameters(someParameters); }
  `;
}

template ModelThis(string name) {
  const char[] ModelThis = modelThis(name);
}

string modelCalls(string shortName, string className) {
  return `
    auto `~shortName~`() { return new `~className~`; }
    auto `~shortName~`(IModelManager aManager) { return new `~className~`(aManager); }
    auto `~shortName~`(string aName) { return new `~className~`(aName); }
    auto `~shortName~`(STRINGAA someParameters) { return new `~className~`(someParameters); }

    auto `~shortName~`(string aName, STRINGAA someParameters) { return new `~className~`(aName, someParameters); }

    auto `~shortName~`(IModelManager aManager, string aName) { return new `~className~`(aManager, aName); }
    auto `~shortName~`(IModelManager aManager, STRINGAA someParameters) { return new `~className~`(aManager, someParameters); }
  `;
}

template ModelCalls(string shortName, string className) {
  const char[] ModelCalls = modelCalls(shortName, className);
}
