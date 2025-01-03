/****************************************************************************************************************
* Copyright: © 2017-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.events.interfaces.eventlistener;

import uim.events;

@safe:

/*
 * Objects implementing this interface should declare the `implementedEvents()` method
 * to notify the event manager what methods should be called when an event is triggered.
 */
interface IEventListener {
    /**
     * Returns a list of events this object is implementing. When the class is registered
     * in an event manager, each individual method will be associated with the respective event.
     *
     * ### Example:
     *
     * ```
     * auto implementedEvents()
     * {
     *    return [
     *        'Order.complete": `sendEmail",
     *        'Article.afterBuy": 'decrementInventory",
     *        'User.onRegister": ["callable": 'logRegistration", "priority": 20, "passParams": true.toJson]
     *    ];
     * }
     * ```
     */
    IEvent[] implementedEvents();
}
