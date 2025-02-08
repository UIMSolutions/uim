/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.events.interfaces.event;

import uim.events;

@safe:

/*
 * Represents the transport class of events across the system. It receives a name, subject and an optional
 * payload. The name can be any string that uniquely identifies the event across the application, while the subject
 * represents the object that the event applies to.
 */
interface IEvent : INamed {
  // Stops the event from being used anymore.
  IEvent stopPropagation();

  // Checks if the event is stopped.
  bool isStopped();

  // Assigns a value to the data of this event.
  IEvent data(string[] keys, bool aValue);
  IEvent data(string key, bool aValue);

  IEvent data(string[] keys, long aValue);
  IEvent data(string key, long aValue);

  IEvent data(string[] keys, double aValue);
  IEvent data(string key, double aValue);

  IEvent data(string[] keys, string aValue);
  IEvent data(string key, string aValue);

  IEvent data(string[] keys, Json aValue);
  IEvent data(string key, Json aValue);
  /* 
  // Returns the subject of this event.
  IEventObject subject();

  // The result value of the event listeners.
  Json result();

  // Listeners can attach a result value to the event.
  IEvent result(Json resultValue);

  // Accesses the event data/payload.
  Json allData(string dataKey);
  Json data(string dataKey);


  */
}
