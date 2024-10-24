/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.i18n.classes.catalogs.catalog;

import uim.i18n;

@safe:

// Message Catalog
class DMessageCatalog : UIMObject, ICatalog {
  this() {
    super();
  }

  this(
    string[][string] messages,
    string formatterName = "default",
    string fallbackName = null,
  ) {
    super();
    this.messages(messages);
    this.formatterName(formatterName);
    this.fallbackName(fallbackName);
  }

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    formatterName("default");

    return true;
  }

  // Message keys and translations in this catalog.
  protected string[][string] _messages;
  string[][string] messages() {
    return _messages;
  }

  ICatalog messages(string[][string] newMessages) {
    _messages = newMessages;
    return this;
  }

  // The name of a fallback catalog to use when a message key does not exist.
  protected string _fallbackName;
  string fallbackName() {
    return _fallbackName;
  }
  ICatalog fallbackName(string name) {
    _fallbackName = name;
    return this;
  }

  // The name of the formatter to use when formatting translated messages.
  protected string _formatterName;
  string formatterName() {
    return _formatterName;
  }
  ICatalog formatterName(string name) {
    _formatterName = name;
    return this;
  }

  // #region get
  string[][string] message(string[] keys) {
    string[][string] result;

    keys
      .filter!(key => messages.hasKey(key))
      .each!(key => result[key] = messages[key]);

    return result;
  }

  ///
  unittest {
    auto catalog = MessageCatalog;
    // catalog.message("test");
  }

  // #region get
    string[][string] get(string[] keys) {
       string[][string] results;
       keys
        .filter!(key => messages.hasKey(key))
        .each!(key => results[key] = get(key));

      return results;
    }

    string[] get(string key) {
      return messages.hasKey(key) 
        ? _messages[key]
        : null;
    }
  // #endregion get

  // #region set
    ICatalog set(string[][string] messages) {
      messages.byKeyValue.each!(message => set(message.key, message.value));
      return this;
    }

    ICatalog set(string key, string[] message...) {
      set(key, message.dup);
      return this;
    }

    ICatalog set(string key, string[] message) {
      _messages[key] = message;
      return this;
    }
  // #endregion set
}

auto MessageCatalog() {
  return new DMessageCatalog;
}

auto MessageCatalog(
  string[][string] messages,
  string formatterName = "default",
  string fallbackName = null) {
  return new DMessageCatalog(messages, formatterName, fallbackName);
}
