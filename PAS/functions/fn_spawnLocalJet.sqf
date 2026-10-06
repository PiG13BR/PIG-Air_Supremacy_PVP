/*
	File: fn_spawnLocalJet.sqf
	Author: PiG13BR - https://github.com/PiG13BR
	Date: 03/10/2026
	Last Update: 04/10/2026
	License: MIT License - http://www.opensource.org/licenses/MIT

	Description:
		Spawns local aircraft for the player

	Parameter(s):
		_aircraftClass - aircraft class to spawn as local vehicle [STRING]
	
	Returns:
		-
*/
params["_aircraftClass"];

// Delete local vehicle if already exists
if !(localNamespace isNil "PIG_PAS_vehicleLocal") then {deleteVehicle (localNamespace getVariable "PIG_PAS_vehicleLocal")};
private _marker = localNameSpace getVariable "PIG_PAS_placeholderMarker";
private _vehicle = createVehicleLocal [_aircraftClass, (markerPos [_marker, true]), [], 0, "CAN_COLLIDE"];

_vehicle setVehiclePosition [(markerPos [_marker, true]), [], 0, "CAN_COLLIDE"]; // For carrier
_vehicle setDir (markerDir _marker);
localNamespace setVariable ["PIG_PAS_vehicleLocal", _vehicle];

//_vehicle enableSimulation false;
_vehicle setPhysicsCollisionFlag false;
_vehicle allowDamage false;

_vehicle