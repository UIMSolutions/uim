/***********************************************************************************
*	Copyright: © 2015-2024 Ozan Nurettin Süel (sicherheitsschmiede)                   *
*	License  : Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt] *
*	Author   : Ozan Nurettin Süel (UIManufaktur)										           * 
***********************************************************************************/
module uim.filesystems.interfaces.linkmanager;

import uim.filesystems;

@safe:
interface ILinkManager {
  bool existsLinks(string aPath);
  bool existsLinks(string[] aPath);

  size_t countLinks(string aPath);
  size_t countLinks(string[] aPath);

  ILink[] links(string aPath);
  ILink[] links(string[] aPath);

  // Returns a Link object for a specified path.
  ILink link(string aPath);
  ILink link(string[] aPath);

  bool existsLink(string aPath);
  bool existsLink(string[] aPath);

  bool addLink(ILink aLink);

  // Copies link from one location to another.
  bool copyLink(string fromPath, string toPath);
  bool copyLink(string[] fromPath, string[] toPath);

  // Moves one or more links from one location to another.
  bool moveLink(string fromPath, string toPath);
  bool moveLink(string[] fromPath, string[] toPath);

  // Checks if a specified link exists.
  final bool linkshasKey(ILink[] someLinks) {
    if (someLinks.isEmpty) {
      return false;
    }

    return someLinks.all!(link => link.exists);
  }

  // Deletes specified link.
  bool removeLinks(string aPath);
  bool removeLinks(string[] aPath);

  // Deletes specified link.
  ILink createLink(string aPath);
  ILink createLink(string[] aPath);

  // Deletes specified link.
  bool removeLink(string aPath);
  bool removeLink(string[] aPath);
}
