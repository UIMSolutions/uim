/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.controllers.classes.components.flash;

import uim.controllers;

@safe:

/**
 * The UIM FlashComponent provides a way for you to write a flash variable
 * to the session from your controllers, to be rendered in a view with the
 * FlashHelper.
 *
 * @method void success(string amessage, Json[string] options = null) Set a message using "success" element
 * @method void info(string amessage, Json[string] options = null) Set a message using "info" element
 * @method void warning(string amessage, Json[string] options = null) Set a message using "warning" element
 * @method void error(string amessage, Json[string] options = null) Set a message using "error" element
 */
class DFlashComponent : DComponent {
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    configuration
      .setDefault("key", "flash")
      .setDefault("element", "default")
      .setDefault("params", Json.emptyArray)
      .setDefault("clear", false)
      .setDefault("duplicate", true);

    return true;
  }

  /**
     * Used to set a session variable that can be used to output messages in the view.
     * If you make consecutive calls to this method, the messages will stack (if they are
     * set with the same flash key)
     *
     * In your controller: this.Flash.set("This has been saved");
     *
     * ### Options:
     *
     * - `key` The key to set under the session`s Flash key
     * - `element` The element used to render the flash message. Default to "default".
     * - `params` An array of variables to make available when using an element
     * - `clear` A bool stating if the current stack should be cleared to start a new one
     * - `escape` Set to false to allow templates to print out HTML content
     * Params:
     * \Throwable|string amessage Message to be flashed. If an instance
     * of \Throwable the throwable message will be used and code will be set
     * in params.
     */
  void set( /* Throwable |  */ string amessage, Json[string] options = null) {
    // TODO
    /* if (cast(Throwable) aMessage) {
            flash().setExceptionMessage(message, options);
        } else { */
    // flash().set(message, options);
    /* } */
  }

  // Get flash message utility instance.
  protected  /* DFlashMessage */ string flash() {
    return null; // _getController().getRequest().getFlash();
  }

  // Proxy method to FlashMessage instance.
  void setConfig(string key, Json valueToSet = null, bool mergeExisting = true) {
  }

  void setConfig(string[] aKey, Json valueToSet = null, bool merge = true) {
    // flash().configuration.set(aKey, valueToSet, merge);
  }

  // Proxy method to FlashMessage instance.
  Json getConfig(string aKey = null, Json defaultValue = Json(null)) {
    // return _flash().configuration.get(aKey, defaultValue);
    return Json(null);
  }

  // Proxy method to FlashMessage instance.
  Json getConfigOrFail(string aKey) {
    // return _flash().getConfigOrFail(aKey);
    return Json(null);
  }

  //  Proxy method to FlashMessage instance.
  void configShallow(string aKey, Json valueToSet = null) {
    // flash().configShallow(aKey, valueToSet);
  }

  void configShallow(string[] keys, Json valueToSet = null) {
    // flash().configShallow(keys, valueToSet);
  }

  /**
     * Magic method for verbose flash methods based on element names.
     *
     * For example: this.Flash.success("My message") would use the
     * `success.d` element under `templates/element/flash/` for rendering the
     * flash message.
     *
     * If you make consecutive calls to this method, the messages will stack (if they are
     * set with the same flash key)
     *
     * Note that the parameter `element` will be always overridden. In order to call a
     * specific element from a plugin, you should set the `plugin` option in someArguments.
     *
     * For example: `this.Flash.warning("My message", ["plugin": 'PluginName"])` would
     * use the `warning.d` element under `plugins/PluginName/templates/element/flash/` for
     * rendering the flash message.
     */
  void __call(string elementName, Json[string] someArguments) {
    string anElement = elementName.underscore;
    if (someArguments.isEmpty) {
      throw new DInternalErrorException("Flash message missing.");
    }

    /*     auto options = ["element": anElement];
        if (!someArguments[1].isEmpty) {
            if (!someArguments[1].isEmpty("plugin")) {
                options = createMap!(string, Json)
                    .set("element", someArguments[1].getString("plugin") ~ "." ~ anElement);
                someArguments[1].removeKey("plugin");
            }
            // options.update/* (array) * / someArguments[1];
        }
        set(someArguments[0], options);*/
  }
}

unittest {
  // assert(DCheckHttpCacheComponent);
}
