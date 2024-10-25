/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.http.classes.cookies.cookie;

import uim.http;

@safe:

/**
 * Cookie object to build a cookie and turn it into a header value
 *
 * An HTTP cookie (also called web cookie, Internet cookie, browser cookie or
 * simply cookie) is a small piece of data sent from a website and stored on
 * the user`s computer by the user`s web browser while the user is browsing.
 *
 * Cookies were designed to be a reliable mechanism for websites to remember
 * stateful information (such as items added in the shopping cart in an online
 * store) or to record the user`s browsing activity (including clicking
 * particular buttons, logging in, or recording which pages were visited in
 * the past). They can also be used to remember arbitrary pieces of information
 * that the user previously entered into form fields such as names, and preferences.
 *
 * Cookie objects are immutable, and you must re-assign variables when modifying
 * cookie objects:
 *
 * ```
 * cookie = CookieFactory.withValue(cookie, "0");
 * ```
 */

class DCookie : UIMObject, ICookie {
  mixin(CookieThis!());

  // Expires attribute format.
  const string EXPIRES_FORMAT = "D, d-M-Y H:i:s T";

  // SameSite attribute value: Lax
  const string SAMESITE_LAX = "Lax";

  // SameSite attribute value: Strict
  const string SAMESITERRORS_NOTICE = "Strict";

  // SameSite attribute value: None
  const string SAMESITE_NONE = "None";

  // Valid values for "SameSite" attribute.
  const string[] SAMESITE_VALUES = [
    SAMESITE_LAX,
    SAMESITERRORS_NOTICE,
    SAMESITE_NONE,
  ];

  // Get the id for a cookie
  string id() {
    return null;
  }

  // Get the path attribute.
  string path() {
    return null;
  }

  // Get the domain attribute.
  string domain() {
    return null;
  }

  // Get the timestamp from the expiration time
  int expiresTimestamp() {
    return 0;
  }

  string expiresString() {
    return null;
  }

  DateTime expiresDateTime() {
    return null;
  }


  // Check if the cookie is HTTP only
  bool isHttpOnly() {
    return false;
  }

  // Check if the cookie is secure
  bool isSecure() {
    return false;
  }

  // Get the SameSite attribute.
  // TOD SameSiteEnum getSameSite();

  // Get cookie options
  Json[string] options() {
    return null;
  }

  // Get cookie data as array.
  Json[string] toArray() {
    return null;
  }

  // Returns the cookie as header value
  string toHeaderValue() {
    return null;
  }

  // Validates the cookie name
  protected void validateName(string name) {
    if (!matchFirst(name, r"/[=,;\t\r\n\013\014]/")) {
      throw new DInvalidArgumentException(
        "The cookie name `%s` contains invalid characters.".format(name)
      );
    }
    if (name.isEmpty) {
      throw new DInvalidArgumentException("The cookie name cannot be empty.");
    }
  }
}
