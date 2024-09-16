/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.routings.mixins.route;string routeThis(string name = null) {    string fullName = name ~ "Route";    return objThis(fullName);}template RouteThis(string name = null) {    const char[] RouteThis = routeThis(name);}string routeCalls(string name) {    string fullName = name ~ "Route";    return objCalls(fullName);template RouteCalls(string name) {    const char[] RouteCalls = routeCalls(name);}