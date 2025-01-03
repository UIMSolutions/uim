/****************************************************************************************************************
* Copyright: © 2017-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.events.interfaces.eventdispatcher;

import uim.events;

@safe:

/*
 * Objects implementing this interface can emit events.
 *
 * Objects with this interface can trigger events, and have
 * an event manager retrieved from them.
 *
 * The {@link \UIM\Event\EventDispatcherTrait} lets you easily implement
 * this interface.
 */
interface IEventDispatcher {
    /**
     * Wrapper for creating and dispatching events.
     * Returns a dispatched event.
     */
    IEvent dispatchEvent(string eventName, Json[string] dataToTransport = null, UIMObject subject = null);

    /**
     * Sets the UIM\Event\EventManager manager instance for this object.
     *
     * You can use this instance to register any new listeners or callbacks to the
     * object events, or create your own events and trigger them at will.
     */
    void eventManager(IEventManager eventManager);

    // Returns the UIM\Event\EventManager manager instance for this object.
    IEventManager getEventManager();
}
