/***********************************************************************************
*	Copyright: ©2015-2023 Ozan Nurettin Süel (sicherheitsschmiede)                   *
*	License  : Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt] *
*	Author   : Ozan Nurettin Süel (Sicherheitsschmiede)										           * 
***********************************************************************************/
module uim.filesystems.interfaces.link;

import uim.filesystems;
@safe:

interface ILink : IFilesystemEntry{
  bool isLink();
  bool isFileLink();
  bool isFolderLink();
}

