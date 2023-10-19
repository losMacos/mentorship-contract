// SPDX-License-Identifier: MIT
pragma solidity 0.8.11;

interface IImageDescriptor {
    function image(bytes calldata data)
        external
        pure
        returns (bool isRawSVG, string memory);
}
