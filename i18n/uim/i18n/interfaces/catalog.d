/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.i18n.interfaces.catalog;

import uim.i18n;

@safe:

// Message Catalog
interface IMessageCatalog {
  // #region messages
  // Sets the messages for this catalog.
  IMessageCatalog messages(string[][string] messages);

  // Gets the messages for this catalog.
  string[][string] messages(string[] keys...);
  string[][string] messages(string[] keys);
  string[][string] messages();

  string[] message(string key);

  // #region setMessages
  IMessageCatalog setMessages(string[][string] messages);
  IMessageCatalog setMessage(string key, string[] message);
  // #endregion setMessages

  // #region updateMessages
  IMessageCatalog updateMessages(string[][string] messages);
  IMessageCatalog updateMessage(string key, string[] message);
  // #endregion updateMessages

  // #region mergeMessages
  IMessageCatalog mergeMessages(string[][string] messages);
  IMessageCatalog mergeMessage(string key, string[] message);
  // #endregion updateMessages
  // #endregion messages

  // #region formatterName
  // Sets the formatter name for this catalog.
  IMessageCatalog formatterName(string name);

  // Gets the formatter name for this catalog.
  string formatterName();
  // #endregion formatterName

  // #region fallbackName
  // Sets the fallback catalog name.
  IMessageCatalog fallbackName(string name);

  // Gets the fallback catalog name.
  string fallbackName();
  // #endregion fallbackName
}
