/*********************************************************************************************************
	Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel, mailto:ons@sicherheitsschmiede.de                                                      
**********************************************************************************************************/
module uim.models.mixins.model;

import uim.models;
@safe:

string modelThis(string name) {
  return `
    this() { super("`~name~`"); this.className("`~name~`"); }
    this(Json configSettings) { super("`~name~`", configSettings); }
    this(IModelManager aManager, IData[string] configSettings = null) { this(configSettings).application(aManager); }

    this(string aName, IData[string] configSettings = null) { this(configSettings).name(aName); }
    this(STRINGAA someParameters, IData[string] configSettings = null) { this(configSettings).parameters(someParameters); }

    this(IModelManager aManager, string aName, IData[string] configSettings = null) { this(aManager, configSettings).name(aName); }
    this(IModelManager aManager, STRINGAA someParameters, IData[string] configSettings = null) { this(aManager, configSettings).parameters(someParameters); }

    this(string aName, STRINGAA someParameters, IData[string] configSettings = null) { this(name, configSettings).parameters(someParameters); }
    this(IModelManager aManager, string aName, STRINGAA someParameters, IData[string] configSettings = null) { this(aManager, name, configSettings).parameters(someParameters); }
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
