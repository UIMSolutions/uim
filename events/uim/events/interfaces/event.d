module uim.events.interfaces.event;

import uim.events;

@safe:

/*
 * Represents the transport class of events across the system. It receives a name, subject and an optional
 * payload. The name can be any string that uniquely identifies the event across the application, while the subject
 * represents the object that the event applies to.
 */
interface IEvent {
  // Returns the name of this event. This is usually used as the event identifier.
  string name();

  // Returns the subject of this event.
  IEventObject subject();

  // Stops the event from being used anymore.
  IEvent stopPropagation();

  // Checks if the event is stopped.
  bool isStopped();

  // The result value of the event listeners.
  Json result();

  // Listeners can attach a result value to the event.
  IEvent result(Json resultValue);

  // Accesses the event data/payload.
  Json allData(string dataKey);
  Json data(string dataKey);

  // Assigns a value to the data/payload of this event.
  IEvent data(string[] dataKeys, Json aValue);
}
