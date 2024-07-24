module uim.i18n.classes.catalogs.catalog;

import uim.i18n;

@safe:

// Message Catalog
class DMessageCatalog : ICatalog {
  mixin TConfigurable;

  this() {
    initialize;
    formatterName("default");
  }

  this(
    string[][string] messages,
    string formatterName = "default",
    string fallbackName = null,
  ) {
    this();
    this.messages(messages);
    this.formatterName(formatterName);
    this.fallbackName(fallbackName);
  }

  // Hook method
  bool initialize(Json[string] initData = null) {
    configuration(MemoryConfiguration);
    configuration.data(initData);

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
      .each(key => result[key] = messages[key]);

    return result;
  }

  string[] message(string key) {
    return messages.hasKey(key) 
      ? _messages[key]
      : null;
  }
  ///
  unittest {
    auto catalog = MessageCatalog;
    catalog.message("test");
  }
  // #endregion get

  // #region set
    ICatalog set(string[][string] messages) {
      messages.bykeyValue.each!(message => set(key, message));
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
