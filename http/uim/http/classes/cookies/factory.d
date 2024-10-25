module uim.http.classes.cookies.factory;

import uim.http;

@safe:

class DCookieFactory : DFactory!DCookie {
  static DCookieFactory factory;

  DCookie withName(DCookie cookie, string name) {
    /* validateName(name);
    if (auto newCookie = cast(DCookie) cookie.clone) {
      newCookie.name = name;

      return newCookie;
    } */
    return null;
  }

  // Create a cookie with an updated expiration date
  /*  DCookie withExpiry(DCookie cookie, DateTime dateTime) {
    return null;
  } */

  // Create a cookie with an updated SameSite option.
  DCookie withSameSite(DCookie cookie, /* SameSiteEnum| */ string sameSite) {
    return null;
  }

  DCookie withValue(DCookie cookie, /* string[]|float|bool */ string value) {
    /* if (auto newCookie = cast(DCookie) cookie.clone) {
      newCookie.value(value);
      return newCookie;
    } */
    return null;
  }

  DCookie withPath(DCookie cookie, string path) {
    /* if (auto newCookie = cast(DCookie) cookie.clone) {
      newCookie.path(path);
      return newCookie;
    } */
    return null;
  }

  DCookie withDomain(DCookie cookie, string adomain) {
    /* if (auto newCookie = cast(DCookie) cookie.clone) {
      newCookie.domain(domain);
      return newCookie;
    } */
    return null;
  }

  DCookie withSecure(DCookie cookie, bool isSecure) {
   /*  if (auto newCookie = cast(DCookie) cookie.clone) {
      newCookie.isSecure(isSecure);
      return newCookie;
    } */
    return null;
  }

  DCookie withHttpOnly(DCookie cookie, bool isHttpOnly) {
    /* if (auto newCookie = cast(DCookie) cookie.clone) {
      newCookie.httpOnly(isHttpOnly);
      return newCookie;
    } */
    return null;
  }

  /*   DCookie withExpiry(DCookie cookie, DateTime dateTime) {
    if (auto newCookie = cast(DCookie)cookie.clone)  {

    if (cast(DateTime) dateTime) {
      dateTime = dateTime.clone;
    }

    newCookie.expiresAt = dateTime.setTimezone(new DateTimeZone("GMT"));

    return newCookie; 
    } return null;
  } */

  auto withNeverExpire(DCookie cookie) {
    /* if (auto newCookie = cast(DCookie) cookie.clone) {
      newCookie.expiresAt = new DateTimeImmutable("2038-01-01");
      return newCookie;
    } */
    return null;
  }

  DCookie withExpired(DCookie cookie) {
    /* if (auto newCookie = cast(DCookie) cookie.clone) {
      newCookie.expiresAt = new DateTimeImmutable("@1");
      return newCookie;
    } */
    return null;
  }
}

auto CookieFactory() {
  return DCookieFactory.factory is null
    ? DCookieFactory.factory = new DCookieFactory : DCookieFactory.factory;
}
