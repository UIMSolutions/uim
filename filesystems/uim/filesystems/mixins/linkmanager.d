/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.filesystems.mixins.linkmanager;

import uim.filesystems;

@safe:
mixin template TLinkManager() {
  bool existsLinks(string aPath) {
    return this.existsLinks(toPathItems(aPath, pathSeparator));    
  }
  bool existsLinks(string[] aPath) {
    return (this.countLinks(aPath) > 0);
  }  
  size_t countLinks(string aPath) {
    return this.countLinks(toPathItems(aPath, pathSeparator));    
  }
  size_t countLinks(string[] aPath) {
    return this.links(aPath).length;
  }

  ILink[] links(string aPathAndName) {
    return this.links(toPathItems(aPathAndName, pathSeparator));    
  }
  ILink[] links(string[] aPathAndName) {
    return null;
  }

  bool removeLinks(string aPath) {
    return this.removeLinks(toPathItems(aPath, pathSeparator));
  }
  
  bool removeLinks(string[] aPath) {
    return false;
  }

  bool existsLink(string aPath) {
    return this.existsLink(toPathItems(aPath, pathSeparator));
  } 
  bool existsLink(string[] aPath) {
    return (this.link(aPath) ? true : false);
  } 
      
  ILink link(string aPath) {
    return this.link(toPathItems(aPath, pathSeparator));
  }
  ILink link(string[] aPath) {
    return null;
  }
  bool addLink(ILink aLink) {
    return false;
  }

  ILink createLink(string aPath) {
    return this.createLink(toPathItems(aPath, pathSeparator));
  }
  ILink createLink(string[] aPath) {
    return null; 
  }

  bool removeLink(string aPath) {
    return this.removeLink(toPathItems(aPath, pathSeparator));
  }
  bool removeLink(string[] aPath) {
    return false; 
  }

  bool copyLink(string fromPath, string toPath) {
    return false;
  }

  bool copyLink(string[] fromPath, string[] toPath) {
    return false;
  }

  bool moveLink(string fromPath, string toPath) {
    return false;
  }

  bool moveLink(string[] fromPath, string[] toPath) {
    return false;
  }
}

