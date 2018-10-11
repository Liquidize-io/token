pragma solidity ^0.4.24;

import "./access/Manageable.sol";


/**
 * @title Asset information.
 * @dev Stores information about a specified real asset.
 */
contract AssetInfo is Manageable {
  string private _fixedDocsLink;
  string private _varDocsLink;

  /**
   * Event for updated running documents logging.
   * @param token Token associated with this asset.
   * @param oldLink Old link.
   * @param newLink New link.
   */
  event UpdateRunningDocuments(
    address token,
    string oldLink,
    string newLink
  );

  /**
   * @param fixedDocsLink A link to a zip file containing fixed legal documents of the asset.
   * @param varDocsLink A link to a zip file containing running documents of the asset.
   */
  constructor(string fixedDocsLink, string varDocsLink) public {
    _fixedDocsLink = fixedDocsLink;
    _varDocsLink = varDocsLink;
  }

  /**
   * @dev Updates information about where to find new running documents of this asset.
   * @param link A link to a zip file containing running documents of the asset.
   */
  function changeRunningDocuments(string link) public onlyManager {
    string memory old = _varDocsLink;
    _varDocsLink = link;

    emit UpdateRunningDocuments(this, old, _varDocsLink);
  }

  function fixedDocsLink() public view returns (string) {
    return _fixedDocsLink;
  }

  function varDocsLink() public view returns (string) {
    return _varDocsLink;
  }
}
