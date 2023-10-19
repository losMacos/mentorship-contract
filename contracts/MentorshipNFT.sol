// SPDX-License-Identifier: MIT
pragma solidity 0.8.11;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "./IImageDescriptor.sol";

contract MentorshipNFT is ERC721, AccessControl {
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    uint256 public totalSupply = 0;

    mapping(uint256 => string) public roles; // Stores Names of roles
    mapping(uint256 => address) public imageDescriptor; // Stores address of ImageDescriptors

    // Data stored for each tokenId:
    mapping(uint256 => uint256) public tokenImageDescriptor;
    mapping(uint256 => uint256) public year;
    mapping(uint256 => uint256) public season;
    mapping(uint256 => uint256) public role;
    mapping(uint256 => string) public handle;
    mapping(uint256 => string) public other;

    constructor() ERC721("Mentorship Programme", "MENT") {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(MINTER_ROLE, msg.sender);
        roles[0] = "mentee";
        roles[1] = "mentor";
        roles[2] = "team";
    }

    // Set a new contract to describe tokenURIs
    function setImageDescriptor(
        uint256 _imageDescriptor,
        address _imageDescriptorAddr
    ) public onlyRole(MINTER_ROLE) {
        imageDescriptor[_imageDescriptor] = _imageDescriptorAddr;
    }

    // Set a new role for mentorship programme participants
    function setRoles(uint256 _roleId, string calldata _roleName)
        public
        onlyRole(MINTER_ROLE)
    {
        roles[_roleId] = _roleName;
    }

    function mint(
        address _to,
        uint256 _imageDescriptor,
        uint256 _year,
        uint256 _season,
        uint256 _role,
        string calldata _handle,
        string calldata _other
    ) public onlyRole(MINTER_ROLE) {
        require(
            imageDescriptor[_imageDescriptor] != address(0x0),
            "MENT: Invalid imageDescriptor"
        );
        require(
            keccak256(bytes(roles[_role])) != keccak256(bytes("")),
            "MENT: Nonexistant Role"
        );

        totalSupply++;
        _safeMint(_to, totalSupply);
        tokenImageDescriptor[totalSupply] = _imageDescriptor;
        year[totalSupply] = _year;
        season[totalSupply] = _season;
        role[totalSupply] = _role;
        handle[totalSupply] = _handle;
        other[totalSupply] = _other;
    }

    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        require(_exists(tokenId), "MENT: Nonexistent token");

        uint256 _year = year[tokenId];
        uint256 _season = season[tokenId];
        string memory _role = roles[role[tokenId]];
        string memory _handle = handle[tokenId];
        string memory _other = other[tokenId];

        address imgDescAddr = imageDescriptor[tokenImageDescriptor[tokenId]];

        IImageDescriptor d = IImageDescriptor(imgDescAddr);

        (bool isRawSVG, string memory imageData) = d.image(
            abi.encode(_year, _season, _role, _handle, _other)
        );

        string[12] memory json;
        json[0] = '{"description": "Mentorship Programme NFTs","image';
        json[1] = isRawSVG ? '_data":"' : '":"';
        // json[] = imageData;
        json[2] = '","name": "';
        // json[] = symbol();
        json[3] = " #";
        json[4] = Strings.toString(tokenId);
        json[5] = '", "attributes":[{"trait_type":"Year","value":"';
        json[6] = Strings.toString(_year);
        json[7] = '"},{"trait_type":"Season","value":"';
        json[8] = Strings.toString(_season);
        json[9] = '"},{"trait_type":"Role","value":"';
        // json[] = _role;
        json[10] = '"},{"trait_type":"Handle","value":"';

        if (bytes(_other).length > 0) {
            json[11] = string(
                abi.encodePacked(
                    '"},{"trait_type":"Other","value":"',
                    _other,
                    '"}]}'
                )
            );
        } else {
            json[11] = '"}]}';
        }

        string memory jsonStr = string(
            abi.encodePacked(
                json[0],
                json[1],
                imageData,
                json[2],
                symbol(),
                json[3],
                json[4],
                json[5]
            )
        );

        jsonStr = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        jsonStr,
                        json[6],
                        json[7],
                        json[8],
                        json[9],
                        _role,
                        json[10],
                        _handle,
                        json[11]
                    )
                )
            )
        );

        return
            string(abi.encodePacked("data:application/json;base64,", jsonStr));
    }

    // Burnable & Transferable, only by MINTER_ROLE addresses
    function burn(uint256 tokenId) public onlyRole(MINTER_ROLE) {
        _burn(tokenId);
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal override {
        _checkRole(MINTER_ROLE, msg.sender);
        super._beforeTokenTransfer(from, to, tokenId);
    }



    // The following functions are overrides required by Solidity.
    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, AccessControl)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}

// Goerli contract: https://goerli.etherscan.io/address/0x29931209cf1154c2955b73f7b27b42b4e9460096

// Mumbai contract: https://mumbai.polygonscan.com/address/0x02afacb9e8552b757fb077a235bfdc4f6b43e8f2#code