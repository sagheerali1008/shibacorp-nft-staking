// SPDX-License-Identifier: MIT
pragma solidity >0.6.0;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/EnumerableSet.sol";
import "./BShibaNFT.sol";

contract BShibaFactory is Ownable {
    using EnumerableSet for EnumerableSet.AddressSet;

    EnumerableSet.AddressSet nfts;

    event Creat(address indexed addr, address indexed owner, uint mintLimit, string baseURI);
    event Remove(address indexed nft);
    event Update(address indexed nft);

    function create(address _owner, uint _mintLimit, string memory _baseURI) external onlyOwner returns (address) {
        address nft = address(new BShibaNFT(_mintLimit, _baseURI));
        Ownable(nft).transferOwnership(_owner);

        _checkOrAdd(nft);
        emit Creat(nft, _owner, _mintLimit, _baseURI);

        return nft;
    }

    function remove(address _nft) external onlyOwner {
        if (nfts.contains(_nft) == true) {
            nfts.remove(_nft);
        }

        emit Remove(_nft);
    }

    function count() external view returns (uint) {
        return nfts.length();
    }

    function nftByIndex(uint _index) external view returns (address) {
        require(_index < nfts.length(), "Invalid index");
        return nfts.at(_index);
    }

    function nftList() external view returns (address[] memory) {
        address[] memory list = new address[](nfts.length());
        for (uint256 i = 0; i < nfts.length(); i++) {
            list[i] = nfts.at(i);
        }
        return list;
    }

    function _checkOrAdd(address _nft) internal {
        if (nfts.contains(_nft) == false) {
            nfts.add(_nft);
        }
    }
}