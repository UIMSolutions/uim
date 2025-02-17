/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.events.tests.event;

import uim.events;
@safe:

version (test_uim_events) {
  unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
  }
}

bool testEvent(IEvent event) {
    assert(event !is null, "Event is null");

    return true;
}
