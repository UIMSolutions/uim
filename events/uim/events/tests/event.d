/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.events.tests.event;import uim.events;@safe:bool testEvent(IEvent eventToTest) {    assert(eventToTest !is null, "In testEvent: eventToTest is null");    return true;}