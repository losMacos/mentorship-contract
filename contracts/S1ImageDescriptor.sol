// SPDX-License-Identifier: MIT
pragma solidity 0.8.11;

import "./IImageDescriptor.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

string constant SVG_START = "<svg width='350' height='350' viewBox='0 0 400 400' xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' font-family='sans-serif'><defs> <path d='M60,200a140,140 0 1,0 280,0' id='a' /><path d='M20,200a180,180 0 1,0 360,0' id='b' /><path d='M50,200a150,150 0 1,1 300,0' id='c' /><path d='M75,200a125,125 0 1,1 250,0' id='f' /><radialGradient id='i' fx='.8' fy='.4'><stop stop-color='#52d9' offset='0' /><stop stop-color='#52d6' offset='.5' /><stop stop-color='#52d0' offset='1' /></radialGradient><radialGradient id='j' fx='.4' fy='.8'><stop stop-color='#d3f8' offset='0' /><stop stop-color='#d3f4' offset='.5' /><stop stop-color='#d3f0' offset='1' /></radialGradient><linearGradient id='k' x1='.3' y1='.1' x2='.7' y2='1'><stop stop-color='#fff' offset='.21' /><stop stop-color='#000' offset='.41' /><stop stop-color='#fff' offset='.49' /><stop stop-color='#000' offset='.5' /><stop stop-color='#fff' offset='.51' /><stop stop-color='#000' offset='.81' /></linearGradient><filter id='s'><feDropShadow dx='-.5' dy='0' stdDeviation='0' flood-color='#7ef' /><feDropShadow dx='.5' dy='0' stdDeviation='0' flood-color='#d3f' /></filter><filter id='t'><feDropShadow dx='0' dy='0' stdDeviation='1' flood-color='#d3f' /></filter><filter id='u'><feDropShadow dx='0' dy='0' stdDeviation='1' flood-color='#000' /></filter><filter id='v'><feDropShadow dx='0' dy='0' stdDeviation='1' flood-color='#fff' /></filter></defs><circle cx='200' cy='200' r='200' fill='#000' /><circle cx='200' cy='200' r='190' stroke-width='1.5' stroke='#fff'/><ellipse cx='210' cy='230' rx='95' ry='180' fill='url(#i)' /><ellipse cx='190' cy='210' rx='160' ry='75' fill='url(#j)' /><path fill='#b7d' d='M20 200q14-1 15-15q1 14 15 15q-14 1-15 15q-1-14-15-15' filter='url(#t)' /><path fill='#b7d' d='M350 200q14-1 15-15q1 14 15 15q-14 1-15 15q-1-14-15-15' filter='url(#t)' /><g text-anchor='middle' fill='#fff' font-size='26'><text x='285' y='0' font-family='Baskerville' font-size='22' textLength='380' ><textPath xlink:href='#b'>BUILDING WEB3 - MMXXII - S1</textPath></text><g font-weight='900'><g font-size='100' filter='url(#u)'><text x='138' y='235' fill='url(#k)'>D</text><text x='198' y='230' fill='url(#k)' font-weight='100'>_</text><text x='263' y='235' fill='url(#k)'>D</text></g><g filter='url(#s)' fill='#52d'><text x='235' y='300' font-size='40'><textPath xlink:href='#c'>MENTORSHIP</textPath></text><text x='235' y='300' dx='24' fill='black'><animate dur='6s' repeatCount='indefinite' attributeName='dx' values='22;-105;22' /><textPath xlink:href='#f'>";
string constant SVG_MIDDLE = "</textPath></text><text x='200' y='305' dx='20' fill='black' font-size='24'><textPath xlink:href='#a'>";
string constant SVG_END = "</textPath></text></g></g></g></svg>";

contract S1ImageDescriptor is IImageDescriptor {
    function image(bytes calldata data)
        external
        pure
        returns (bool isRawSVG, string memory)
    {
        (, , string memory role, string memory handle, ) = abi.decode(
            data,
            (uint256, uint256, string, string, string)
        );

        return (
            true,
            string(
                abi.encodePacked(SVG_START, role, SVG_MIDDLE, handle, SVG_END)
            )
        );
    }
}
