module uim.http.classes.cookies.factory;

import uim.http;

@safe:

class DCookieFactory : DFactory!DCookie {
  static DCookieFactory _factory;

  DCookie withName(ICookie cookie, string name) {
    validateName(name);
    if (auto newCookie = cast(DCookie) cookie.clone) {
      newCookie.name = name;

      return newCookie;
    }
    return null;
  }

  // Create a cookie with an updated expiration date
  /*  DCookie withExpiry(ICookie cookie, DateTime dateTime) {
    return null;
  } */

  // Create a new cookie that will virtually never expire.
  DCookie withNeverExpire(ICookie cookie) {
    return null;
  }

  // Create a new cookie that will expire/delete the cookie from the browser.
  DCookie withExpired(ICookie cookie) {
    return null;
  }

  // Create a cookie with HTTP Only updated
  DCookie withHttpOnly(ICookie cookie, bool httpOnly) {
    return null;
  }

  // Create a cookie with an updated SameSite option.
  DCookie withSameSite(ICookie cookie, /* SameSiteEnum| */ string sameSite) {
    return null;
  }

  DCookie withValue(ICookie cookie, /* string[]|float|bool */ string value) {
    if (auto newCookie = cast(DCookie) cookie.clone) {
      newCookie.value(value);
      return newCookie;
    }
    return null;
  }

  DCookie withPath(ICookie cookie, string path) {
    if (auto newCookie = cast(DCookie) cookie.clone) {
      newCookie.path(path);
      return newCookie;
    }
    return null;
  }

  DCookie withDomain(ICookie cookie, string adomain) {
    if (auto newCookie = cast(DCookie) cookie.clone) {
      newCookie.domain(domain);
      return newCookie;
    }
    return null;
  }

  DCookie withSecure(ICookie cookie, bool isSecure) {
    if (auto newCookie = cast(DCookie) cookie.clone) {
      newCookie.isSecure(isSecure);
      return newCookie;
    }
    return null;
  }

  DCookie withHttpOnly(ICookie cookie, bool isHttpOnly) {
    if (auto newCookie = cast(DCookie) cookie.clone) {
      newCookie.httpOnly(isHttpOnly);
      return newCookie;
    }
    return null;
  }

  /*   DCookie withExpiry(ICookie cookie, DateTime dateTime) {
    if (auto newCookie = cast(DCookie)cookie.clone)  {

    if (cast(DateTime) dateTime) {
      dateTime = dateTime.clone;
    }

    newCookie.expiresAt = dateTime.setTimezone(new DateTimeZone("GMT"));

    return newCookie; 
    } return null;
  } */

  auto withNeverExpire(ICookie cookie) {
    if (auto newCookie = cast(DCookie) cookie.clone) {
      newCookie.expiresAt = new DateTimeImmutable("2038-01-01");
      return newCookie;
    }
    return null;
  }

  auto withExpired(ICookie cookie) {
    if (auto newCookie = cast(DCookie) cookie.clone) {
      newCookie.expiresAt = new DateTimeImmutable("@1");
      return newCookie;
    }
    return null;
  }
}

auto CookieFactory() {
  return _factory is null
    ? _factory = new DCookieFactory : _factory;
}
