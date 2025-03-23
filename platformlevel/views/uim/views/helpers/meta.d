module uim.views.helpers.meta;

import uim.views;
@safe:

version (test_uim_views) {
  unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
  }
}

// BreadcrumbsHelper to register and display a breadcrumb trail for your views
class MetaHelper : DHelper {
  static T rss(T)(string type, string content) {
    T meta;
    static if (is(T == Json)) {
      meta = Json.emptyObject
        .set("type", "application/rss+xml")
        .set("rel", "alternate")
        .set("title", type)
        .set("link", content);
    }

    return meta;
  }

  static T atom(T)(string type, string content) {
    T meta;
    static if (is(T == Json)) {
      meta = Json.emptyObject
      .set("type", "application/atom+xml")
      .set("title", type)
      .set("link", content); }

    return meta;
  }

  static T icon(T)(string content) {
    T meta;
    static if (is(T == Json)) {
      meta = Json.emptyObject
      .set("type", "image/x-icon")
      .set("rel", "icon")
      .set("link", content); }

    return meta;
  }

  static T keywords(T)(string content) {
    T meta;
    static if (is(T == Json)) {
      meta = Json.emptyObject
      .set("name", " keywords")
      .set("content", content); }

    return meta;
  }

  static T description(T)(string content) {
    T meta;
    static if (is(T == Json)) {
      meta = Json.emptyObject
      .set("name", "description")
      .set("content", content); }

    return meta;
  }

  static T robots(T)(string content) {
    T meta;
    static if (is(T == Json)) {
      meta = Json.emptyObject
      .set("name", " robots")
      .set("content", content); }

    return meta;
  }

  static T viewport(T)(string content) {
    T meta;
    static if (is(T == Json)) {
      meta = Json.emptyObject
      .set("name", "viewport")
      .set("content", content); }

    return meta;
  }

  static T canonical(T)(string content) {
    T meta;
    static if (is(T == Json)) {
      meta = Json.emptyObject
      .set("rel", "canonical")
      .set("link", content); }

    return meta;
  }

  static T next(T)(string content) {
    T meta;
    static if (is(T == Json)) {
      meta = Json.emptyObject
      .set("rel", " next")
      .set("link", content); }

    return meta;
  }

  static T prev(T)(string content) {
    T meta;
    static if (is(T == Json)) {
      meta = Json.emptyObject
      .set("rel", " prev")
      .set("link", content); }

    return meta;
  }

  static T first(T)(string content) {
    T meta;
    static if (is(T == Json)) {
      meta = Json.emptyObject
      .set("rel", "first")
      .set("link", content); }

    return meta;
  }

  static T last(T)(string content) {
    T meta;
    static if (is(T == Json)) {
      meta = Json.emptyObject
      .set("rel", "last")
      .set("link", content); }

    return meta;
  }
}
