/*
	File: fn_convoyObjective.sqf
	Author: PiG13BR - https://github.com/PiG13BR
	Date: 2024/01/11
	Last Update: 2024/09/11
	License: MIT License - http://www.opensource.org/licenses/MIT

	Description:
		Creates and manages the convoy objective

	Parameter(s):
		_sideDefend - side that will defend the convoy [SIDE]
		_sideAttack - side that will attack the convoy [SIDE]
	
	Returns:
		-
*/

params["_sideDefend", "_sideAttack"];

missionNamespace setVariable ["PIG_convoyDestination", false];
PIG_convoyDefendSide = _sideDefend;
PIG_convoyAttackSide = _sideAttack;

// Get spawn, middle and despawn markers from preset
private _markers = [_sideDefend] call PIG_routes_convoy; // [spawn marker, [middle markers], despawn marker]
_markers params [
	["_spawn_marker", "", [""]], 
	["_middle_markers", [], [[]]], 
	["_despawn_marker", "", [""]]
];

if (_spawn_marker isEqualTo "") exitWith {diag_log "[WARNING] No spawn marker for convoy found"; [] call PIG_fnc_selectTask;};
if (count (_middle_markers) < 1) exitWith {diag_log "[WARNING] No middle markers for convoy found"; [] call PIG_fnc_selectTask;};
if (_despawn_marker isEqualTo "") exitWith {diag_log "[WARNING] No despawn marker for convoy found"; [] call PIG_fnc_selectTask;};

private _spawn_pos = getMarkerPos _spawn_marker;
private _despawn_pos = getMarkerPos _despawn_marker;

// Get vehicle composition from preset
private _convoy_pool = [_sideDefend] call PIG_presets_convoy;
if (_convoy_pool isEqualTo []) exitWith {diag_log "[WARNING] No convoy pool found/convoy pool is empty"; [] call PIG_fnc_selectTask;};

_convoy_vehicles = [];
private _convoy_group = createGroup [_sideDefend, true];

// The convoy will spawn in order, one vehicle behind another
private _offSet = 0;
for "_i" from 1 to (PIG_convoyVehiclesLength_param) do {
	
	private _vehicleClass = "";
	private _realIndex = (_i - 1); // for selecting the right elements from array

	switch (_i) do {
		case 1 : {
			// First vehicle is scout vehicle
			_vehicleClass = (selectRandom (_convoy_pool # _realIndex));
		};
		case PIG_convoyVehiclesLength_param : {
			// Last vehicle is escort vehicle
			_vehicleClass = (selectRandom (_convoy_pool # ((count _convoy_pool) - 1)));
		};
		default {
			// Select randomly middle vehicles
			private _random_pool = selectRandom (_convoy_pool);
			_vehicleClass = selectRandom (_random_pool);
		};
	};
	
	private _vehicle = createVehicle [_vehicleClass, (_spawn_pos getpos [_offset, ((markerDir _spawn_marker) - 180)]), [], 0, "NONE"];
	_vehicle setDir (markerDir _spawn_marker);
	_offSet = _offSet + 20; // Next vehicle will spawn behind the recent spawned one

	_convoy_group createVehicleCrew _vehicle;

	_convoy_vehicles pushBack _vehicle; // Put convoy vehicles into the array
};

PIG_convoyVehicles = _convoy_vehicles;

// Add EH for each vehicles and some attributes
{
	_x addEventHandler ["HandleDamage", {
		params ["_unit", "_selection", "_damage", "_source", "_projectile", "_hitIndex", "_instigator", "_hitPoint", "_directHit", "_context"];
		// If unable to move, explode it.
		if (!canMove _unit) then {_unit setDamage 1; _unit removeEventHandler [_thisEvent, _thisEventHandler]};
		// If flipped, explode it
		if ((vectorUp _unit) vectorCos (surfaceNormal getPos _unit) < 0.5) then {
			_unit setDamage 1; _unit removeEventHandler [_thisEvent, _thisEventHandler]
		};
	}];

	_x addMPEventHandler ["MPKilled", {
		params ["_unit", "_killer", "_instigator", "_useEffects"];

		private _convoy_vehicles = PIG_convoyVehicles - [_unit];
		missionNamespace setVariable ["PIG_convoyVehicles", _convoy_vehicles];

		// Add score to player (testing)
		if (isPlayer _instigator) then {
			_instigator addScore 10;
		};

		// Change the leader/lead vehicle of the group right away
		private _lead_veh = PIG_convoyVehicles # 0;
		(group (effectiveCommander _lead_veh)) selectLeader (effectiveCommander _lead_veh);

		// This script below is to replace the wreck with some effects
		_unit spawn {
			if (isNil {missionNamespace getVariable "PIG_particlesEffects"}) then {
				missionNamespace setVariable ["PIG_particlesEffects", []];
			};

			_light = createVehicleLocal ["#lightpoint", (getPos _this) vectorAdd [0,0,2], [], 0, "CAN_COLLIDE"];
			_light setLightColor [1,0.4,0];
			_light setLightAmbient [1,0.4,0];
			_light setLightIntensity 1000;
			_light setLightAttenuation [0,4,4,0];
			_light setLightDayLight false;
			_smoke = "#particlesource" createVehicleLocal (getPos _this);
			_smoke setParticleClass "BigDestructionSmoke";
			_fire = "#particlesource" createVehicleLocal (getPos _this);
			_fire setParticleClass  "BigDestructionFire";

			(missionNamespace getVariable "PIG_particlesEffects") append [_fire, _smoke, _light];

			sleep 7;

			deleteVehicle _this; // Ugly solution to give ride of the wreck
		};

		_unit removeMPEventHandler [_thisEvent, _thisEventHandler];
	}];
	
	// Engine off can mean that the AI is fucking stuck somewhere
	_x addEventHandler ["Engine", {
		params ["_vehicle", "_engineState"];
		if (!_engineState) then {

			if (!alive _vehicle) exitWith {_vehicle removeEventHandler [_thisEvent, _thisEventHandler]};

			// Let's try to reset it's position
			//_vehicle setPos ((_vehicle) getPos [10, (getDir _vehicle)]);
			_vehicle setVectorUp surfaceNormal position _vehicle;

			// Find possible wreck blocking the path
			private _wreck = ((nearestObjects [_vehicle, ["LandVehicle"], 30]) select {!alive _x}); 
			if (count _wreck > 0) then {
				{
					deleteVehicle _x;
				}forEach _wreck
			};

			//_vehicle engineOn true;
			(effectiveCommander _vehicle) doMove ((_vehicle) getPos [20, (getDir _vehicle)]);

			private _grp = group (effectiveCommander _vehicle);
			(effectiveCommander _vehicle) doFollow (leader _grp);
		};
	}];
	
	_x addEventHandler ["Fuel", {
		params ["_vehicle", "_hasFuel"];
		if (!_hasFuel) then {
			_vehicle setFuel 1;
		}
	}];

	_x addEventHandler ["GetOut", {
		params ["_vehicle", "_role", "_unit", "_turret", "_isEject"];
		// This EH will trigger even if the _unit is deleted

		// If unit get out the vehicle, delete it
		deleteVehicle _unit;
		if ((crew _vehicle) isEqualTo []) then {
			// Explode it if it's empty
			_vehicle setdamage 1;
		};
	}];

	_x allowCrewInImmobile true;
	_x limitSpeed 45;
	
}forEach PIG_convoyVehicles;

// Attributes for the convoy group (units)
{
	_x disableAI "AUTOCOMBAT";
	_x disableAI "AUTOTARGET";
	_x disableAI "LIGHTS";
	_x disableAI "TARGET";
	_x disableAI "CHECKVISIBLE";
	_x allowFleeing 0;
}forEach units _convoy_group;

_convoy_group setFormation "COLUMN";
_convoy_group setBehaviour "CARELESS";
_convoy_group setCombatMode "BLUE";
//_convoy_group setSpeedMode "LIMITED";

// If convoy group leader changes, update the task position
_convoy_group addEventHandler ["LeaderChanged", {
	params ["_group", "_newLeader"];

	// Update task destination
	["convoy_defend_task", [vehicle _newLeader, true]] call BIS_fnc_taskSetDestination;
	["convoy_attack_task", [vehicle _newLeader, false]] call BIS_fnc_taskSetDestination;
}];

// If a unit from the group gets killed
_convoy_group addEventHandler ["UnitKilled", {
	params ["_group", "_unit", "_killer", "_instigator", "_useEffects"];

	// Check if the dead unit is the driver
	if (driver (vehicle _unit) == _unit) then {
		{moveOut _x}forEach (crew (vehicle _unit)); // Will active the vehicle "GetOut" EH
	};
}];

// Waypoints
missionNamespace setVariable ['PIG_convoyDestination', false];
{
	_wpPos = getMarkerPos _x;
	if (_wpPos isEqualTo [0,0,0]) then {diag_log format ["Problematic convoy marker: %1", _x]; continue}; // If marker's position doesn't exist, run the next iteration
	private _waypoint = _convoy_group addWaypoint [_wpPos, 0];
	_waypoint setWaypointType "MOVE";
	_waypoint setWaypointCompletionRadius 50;
}forEach _middle_markers;

private _waypoint = _convoy_group addWaypoint [_despawn_pos, 0];
_waypoint setWaypointType "MOVE";
_waypoint setWaypointCompletionRadius 50;
_waypoint setWaypointStatements ["true", "if (isServer) then {missionNamespace setVariable ['PIG_convoyDestination', true];}"];

// Tasks
[
	_sideDefend, 
	"convoy_defend_task", 
	"convoyDefendTask", 
	[vehicle (leader _convoy_group), true], 
	"defend" // Icon
] call PIG_fnc_createTask;

[
	_sideAttack, 
	"convoy_attack_task", 
	"convoyAttackTask", 
	[vehicle (leader _convoy_group), false], 
	"destroy" // Icon
] call PIG_fnc_createTask;

// Create additional markers
_startMarker = createMarker ["marker_start_convoy", _spawn_pos];
_endMarker = createMarker ["marker_destination_convoy", _despawn_pos];
_startMarker setMarkerType "mil_start";
_endMarker setMarkerType "mil_end";
_startMarker setMarkerText "Partida";
_endMarker setMarkerText "Destino";
switch (_sideDefend) do {
	case west : {
		_startMarker setMarkerColor "colorWEST";
		_endMarker setMarkerColor "colorWEST";
	};
	case east : {
		_startMarker setMarkerColor "ColorEAST";
		_endMarker setMarkerColor "ColorEAST";
	};
};

spawn {
	waitUntil [{(({alive _x} count PIG_convoyVehicles) < 1) || {missionNamespace getVariable ['PIG_convoyDestination', false]}}, -1, 1];

	if ((count PIG_convoyVehicles == 0) && {!(missionNamespace getVariable ['PIG_convoyDestination', false])}) then {
		['convoy_attack_task', 'SUCCEEDED', true] call BIS_fnc_taskSetState; 
		['convoy_defend_task', 'FAILED', true] call BIS_fnc_taskSetState;
		[PIG_convoyDefendSide, -10] call BIS_fnc_respawnTickets; 
	} else {
		['convoy_attack_task', 'FAILED', true] call BIS_fnc_taskSetState; 
		['convoy_defend_task', 'SUCCEEDED', true] call BIS_fnc_taskSetState;
		[PIG_convoyAttackSide, -10] call BIS_fnc_respawnTickets; 
	};
	if ((count PIG_convoyVehicles > 0) && {missionNamespace getVariable ['PIG_convoyDestination', false]}) then {
		{
			deleteVehicleCrew _x;
			deleteVehicle _x;
		}forEach PIG_convoyVehicles;
	};
	PIG_convoyVehicles = nil;
	missionNamespace setVariable ["PIG_convoyDestination", nil];
	{deleteMarker _x} forEach ['marker_start_convoy', 'marker_destination_convoy'];

	diag_log "[CONVOY OBJECTIVE] Convoy objective finished";
	[] call PIG_fnc_selectTask;
};

diag_log "[CONVOY OBJECTIVE] Convoy objective started";
PIG_lastTaskPlayed pushBack "CONVOY";