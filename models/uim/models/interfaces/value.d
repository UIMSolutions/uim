/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.interfaces.value;

import uim.models;
@safe:

interface IData {
  IAttribute attribute();
  
  bool isBoolean();
  bool isInteger();
  bool isDouble();
  bool isLong();
  bool isTime();
  bool isDate();
  bool isDatetime();
  bool isTimestamp();
  bool isString();

  bool isScalar();
  bool isArray();
  bool isObject();
  bool isEntity();
  bool isUUID();

  bool isNullable();
  bool isNull();
  bool isReadOnly();

  bool hasKeys(string[] )
  Json toJson();
  string toString();
}