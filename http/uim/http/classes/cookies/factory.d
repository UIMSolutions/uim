module uim.http.classes.cookies.factory;

import uim.http;

@safe:

class DCookieFactory : DFactory!DCookie {
  static DCookieFactory _factory;
}

auto CookieFactory() {
  return _factory is null
    ? _factory = new DCookieFactory : _factory;
}
