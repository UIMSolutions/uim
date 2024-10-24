module uim.http.classes.cookies.factory;

import uim.http;

@safe:

class DCookieFactory : DFactory!DCookie {
  static DCookieFactory _factory;

  DCookie withName(DCookie cookie, string name) {
    validateName(name);
    auto newCookie = cookie.clone;
    newCookie.name = name;

    return newCookie;
  }

  // Create a cookie with an updated expiration date
  DCookie withExpiry(DCookie cookie, IDateTime dateTime) {
    return null;
  }

  // Create a new cookie that will virtually never expire.
  DCookie withNeverExpire(DCookie cookie) {
    return null;
  }

  // Create a new cookie that will expire/delete the cookie from the browser.
  DCookie withExpired(DCookie cookie) {
    return null;
  }

  // Create a cookie with HTTP Only updated
  DCookie withHttpOnly(DCookie cookie, bool httpOnly) {
    return null;
  }

  // Create a cookie with Secure updated
  DCookie withSecure(DCookie cookie, bool secure) {
    return null;
  }

  // Create a cookie with an updated SameSite option.
  DCookie withSameSite(DCookie cookie, /* SameSiteEnum| */ string sameSite) {
    return null;
  }

  DCookie withValue(DCookie cookie, /* string[]|float|bool */ string value) {
    auto newCookie = cookie.clone;
    newCookie.value(value);

    return newCookie;
  }
}

auto CookieFactory() {
  return _factory is null
    ? _factory = new DCookieFactory : _factory;
}
