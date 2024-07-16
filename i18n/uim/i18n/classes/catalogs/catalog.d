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
  mixin(TProperty!("string[][string]", "messages"));

  // The name of a fallback catalog to use when a message key does not exist.
  mixin(TProperty!("string", "fallbackName"));

  // The name of the formatter to use when formatting translated messages.
  mixin(TProperty!("string", "formatterName"));

  // Adds new messages for this catalog.
  void addMessages(string[][string] newMessages) {
    messages(messages.set(newMessages));
  }

  // #region Getter Setter single message
  // Gets the message of the given key for this catalog.
  string[] message(string messageKey) {
    return messages.get(messageKey, null);
  }
  ///
  unittest {
    auto catalog = MessageCatalog;
    catalog.message("test");
  }

  // Adds one message for this catalog.
  void message(string messageKey, string[] newContent) {
    auto myMessages = messages;
    myMessages[messageKey] = newContent;
    messages(myMessages);
  }
  // #endregion
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
