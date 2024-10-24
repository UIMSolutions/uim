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
 /*  DCookie withExpiry(DCookie cookie, IDateTime dateTime) {
    return null;
  } */

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

  DCookie withPath(DCookie cookie, string path) {
    auto newCookie = cookie.clone;
    newCookie.path(path);

    return newCookie;
  }

  DCookie withDomain(DCookie cookie, string adomain) {
    auto newCookie = cookie.clone;
    newCookie.domain(domain);

    return newCookie;
  }

  DCookie withSecure(DCookie cookie, bool isSecure) {
    auto newCookie = cookie.clone;
    newCookie.isSecure(isSecure);

    return newCookie;
  }

  DCookie withHttpOnly(DCookie cookie, bool isHttpOnly) {
    auto newCookie = cookie.clone;
    newCookie.httpOnly(isHttpOnly);

    return newCookie;
  }

  /*   DCookie withExpiry(DCookie cookie, IDateTime dateTime) {
    auto newCookie = cookie.clone;

    if (cast(DateTime) dateTime) {
      dateTime = dateTime.clone;
    }

    newCookie.expiresAt = dateTime.setTimezone(new DateTimeZone("GMT"));

    return newCookie;
  } */

  auto withNeverExpire(DCookie cookie) {
    auto newCookie = cookie.clone;
    newCookie.expiresAt = new DateTimeImmutable("2038-01-01");

    return newCookie;
  }

  auto withExpired(DCookie cookie) {
    auto newCookie = cookie.clone;
    newCookie.expiresAt = new DateTimeImmutable("@1");

    return newCookie;
  }
}

auto CookieFactory() {
  return _factory is null
    ? _factory = new DCookieFactory : _factory;
}
