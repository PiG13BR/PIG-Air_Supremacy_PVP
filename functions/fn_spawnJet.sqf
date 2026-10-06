/*
	File: fn_spawnJet.sqf
	Author: PiG13BR - https://github.com/PiG13BR
	Date: 31/10/2024
	Last Update: 05/10/2026
	License: MIT License - http://www.opensource.org/licenses/MIT

	Description:
		Spawn selected jet with loadout configuration selected and teleport the player to it

	Parameter(s):
		_pilot - unit player [OBJECT, defaults to player]
		_vehicleClass - plane classname [STRING, defaults to ""]
	
	Returns:
		[BOOL]
*/

params[
	["_pilot", player, [objNull]],
	["_vehicleClass", "", [""]]
];

if (isNull _pilot) exitWith {["No pilots found"] call bis_fnc_error; false};
if (_vehicleClass isEqualTo "") exitWith {systemChat "Escolha um avião"; false};

private _side = side (group _pilot);

// Make a marker name pattern that depends on the spawned unit side
private _markerPattern = format ["respawn_jet_%1", if (_side == west) then { "west" } else { toLowerANSI (str _side)}];

// Get all the map markers and selects only the marker that matches the pattern
private _markers = allMapMarkers select { ((toLowerANSI _x) find _markerPattern) == 0 };

if ((count _markers) == 0) exitWith { ["No markers were found"] call bis_fnc_erro; falser }; // If no markers were found, exit the scope

// For the array that contains the markers, select randomly one of them and get it's position.
private _marker = selectRandom _markers;
private _position = getMarkerPos _marker;

// Position will return numbers in [x,y,z] coords, so the command "set" is selecting the 3 element of the array (z), that is the altitude.
_position set [2, 1000]; // Set spawn altitude. Change the last number if you want to change the altitude.

private _vehicle = createVehicle [_vehicleClass, _position, [], 50, "FLY"];
_vehicle setAirplaneThrottle 1;
_vehicle allowDamage false;

// Use the returned jet to set it's direction accordingly of the spawn marker direction
_vehicle setDir (markerDir _marker);
_vehicle setPosASL _position;
_vehicle setVelocityModelSpace [0,200,0];

// Teleports the player to the jet pilot seat
_pilot moveInDriver _vehicle;

[_vehicle, _pilot, _marker] spawn {
	params ["_vehicle", "_pilot", "_marker"];
	// Setting up the jet pylons loadout

	private _pylonLoaded = 0;

	// Add the selected pylons loadout
	{
		private _magazine = _x # 0;
		private _turret = _x # 1;
		private _index =  _forEachIndex + 1;

		[_vehicle, _index, _magazine, _turret] call PIG_fnc_setPylonConfiguration;

		private _name = getText(configFile >> "cfgMagazines" >> _magazine >> "displayName");

		if (_magazine isEqualTo "") then {
			sleep 0.5;
			systemChat format ["[MUNIÇÃO] Pylon %1 não carregado", _index];
		} else {
			sleep 1;
			systemChat format ["[MUNIÇÃO] Pylon %1 está armado com %2", _index, _name];

			_pylonLoaded = _pylonLoaded + 1; // Pylon armed, add to calculate fuel consumption coeficient
		};
	}forEach PIG_PAS_airLoadout;

	// Set fuel consumption
	if (_pylonLoaded isNotEqualTo 0) then {
		_vehicle setFuelConsumptionCoef (_pylonLoaded * PIG_fuelConsumption_param);
	};

	PIG_PAS_airLoadout = nil;
};

// Safe spawn
[_vehicle, _pilot, _marker] spawn PIG_fnc_safeSpawn;

PIG_jet_spawned = true;

true