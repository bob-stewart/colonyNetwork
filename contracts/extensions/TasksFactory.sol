/*
  This file is part of The Colony Network.

  The Colony Network is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  The Colony Network is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with The Colony Network. If not, see <http://www.gnu.org/licenses/>.
*/

pragma solidity 0.5.8;
pragma experimental ABIEncoderV2;

import "./../ColonyDataTypes.sol";
import "./../IColony.sol";
import "./../ColonyAuthority.sol";
import "./ExtensionFactory.sol";
import "./Tasks.sol";


contract TasksFactory is ExtensionFactory, ColonyDataTypes { // ignore-swc-123
  mapping (address => Tasks) public deployedExtensions;

  function deployExtension(address _colony) external {
    require(IColony(_colony).hasUserRole(msg.sender, 1, ColonyRole.Root), "colony-extension-user-not-root"); // ignore-swc-123
    require(deployedExtensions[_colony] == Tasks(0x00), "colony-extension-already-deployed");
    Tasks newExtensionAddress = new Tasks(_colony);
    deployedExtensions[_colony] = newExtensionAddress;
    emit ExtensionDeployed("Tasks", _colony, address(newExtensionAddress));
  }

  function removeExtension(address _colony) external {
    require(IColony(_colony).hasUserRole(msg.sender, 1, ColonyRole.Root), "colony-extension-user-not-root"); // ignore-swc-123
    deployedExtensions[_colony] = Tasks(0x00);
    emit ExtensionRemoved("Tasks", _colony);
  }
}