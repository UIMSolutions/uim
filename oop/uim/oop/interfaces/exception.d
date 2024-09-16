/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.oop.interfaces.exception;import uim.oop;@safe:interface IException {  // Exception message  string message();  // Template string that has attributes formateded into it.  string messageTemplate(string templateName = "default");  void messageTemplate(string templateName, string templateText);  STRINGAA messageTemplates();  void messageTemplates(string[string] templates);}