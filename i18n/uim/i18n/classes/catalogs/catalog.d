module uim.i18n.classes.catalogs.catalog;

import uim.i18n;

@safe:

// Message Catalog
class DMessageCatalog : ICatalog {
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
    messages(messages);
    formatterName(formatterName);
    fallbackName(fallbackName);
  }

  // Initialization
  bool initialize(IData[string] configData = null) {
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
    messages(messages.update(newMessages));
  }

  // #region Getter Setter singl emessage
  /// Gets the message of the given key for this catalog.
  /// Params:
  ///     messageKey = key of single message (string[])
  /// Returns: 
  ///     single message (string[])
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
