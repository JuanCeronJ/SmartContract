pragma solidity ^0.6.2;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/token/ERC721/ERC721Burnable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract KaleidoERC721MintableBurnable is ERC721Burnable, AccessControl {

    struct Player {
        string playerId;
        string playerName;
        string weight;
        string height;
        string hashDocument;
    }
    
    mapping(string => Player[]) players; 

    event NewToken(string name, string id);

    string[] public mintedContract;
    
    mapping(string => bool) _passportExists;

    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    constructor(string memory name, string memory symbol) ERC721(name, symbol) public {
        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
        _setupRole(MINTER_ROLE, _msgSender());
    }

    function mint(address to, uint256 tokenId) public {
        require(hasRole(MINTER_ROLE, _msgSender()), "KaleidoERC721Mintable: must have minter role to mint");
        _mint(to, tokenId);
    }

    function mintWithTokenURI(address to, uint256 tokenId, string memory tokenURI) public {
        mint(to, tokenId);
        _setTokenURI(tokenId, tokenURI);
    }

    function _getTokens() public view returns (string[] memory) {
        return mintedContract;
    }

    function _createTokenPassport(string memory _playerId,string memory _namePlayer,string memory _weight,string memory _height,string memory _hashDocument) public {
        
       // require(!_passportExists[_playerId], 'Passport player token already exists!');

        mintedContract.push(_playerId);

        players[_playerId].push(Player(_playerId, _namePlayer, _weight, _height, _hashDocument));

      //  _passportExists[_playerId] = true;

        emit NewToken(_namePlayer, _playerId);
    }
    
    function _getTokenPassport(string memory _playerId) public view returns (Player[] memory) {
        return players[_playerId];
    }
}
