/*
	File: fn_artyObjective.sqf
	Author: PiG13BR - https://github.com/PiG13BR
	Date: 07/11/2024
	Last Update: 07/10/2026
	License: MIT License - http://www.opensource.org/licenses/MIT

	Description:
		Creates and manages the artillery objective

	Parameter(s):
		_sideDefend - side that will defend the artillery positions [SIDE]
		_sideAttack - side that will attack the artillery positions [SIDE]
	
	Returns:
		-
*/

params["_sideDefend", "_sideAttack"];

missionNamespace setVariable ["PIG_allArtyDestroyed", false];
PIG_artyAttackSide = _sideAttack;

// Get spawn markers
_markers = [_sideDefend] call PIG_fnc_getArtyMarkers; // Array with 3 markers
if (_markers isEqualTo []) exitWith {diag_log "[WARNING] No spawn marker for artillery found"; [] call PIG_fnc_selectTask;};

// Get artillery and patrol preset
private _arty_preset = ([_sideDefend] call PIG_presets_artillery);
private _artyClass = _arty_preset # 0;
private _patrol = _arty_preset # 1;
if (_artyClass isEqualTo "") exitWith {diag_log "[WARNING] No artillery class found in the preset"; [] call PIG_fnc_selectTask;};
if (_patrol isEqualTo []) exitWith {diag_log "[WARNING] No patrol units classes found in the preset"; [] call PIG_fnc_selectTask;};

// Spawn artillery and patrol group
private _arty_vehicles = [];
private _patrolGroups = [];
{
	private _pos = getMarkerPos _x;

	// Create artillery
	private _artyVeh = createVehicle [_artyClass, _pos, [], 30, "NONE"];
	_artyVeh setDir (markerDir _x);

	private _grpArty = createVehicleCrew _artyVeh;
	_grpArty setBehaviour "COMBAT"; // Turn off lights

	_artyVeh deleteVehicleCrew (driver (_artyVeh)); // Making sure that doesn't move

	_arty_vehicles pushBack _artyVeh;

	// Create patrol squad
	private _grpPatrol = [(_pos) getPos [50, (random 360)], _sideDefend, _patrol] call BIS_fnc_spawnGroup;
	[_grpPatrol, _pos, 100] call BIS_fnc_taskPatrol;

	if (local _grpPatrol) then
	{
		_grpPatrol deleteGroupWhenEmpty true;
	}
	else // group is local to a client
	{
		[_grpPatrol, true] remoteExec ["deleteGroupWhenEmpty", groupOwner _grpPatrol];
	};

	_patrolGroups pushBack _grpPatrol;
}forEach _markers;

PIG_artyVehicles = _arty_vehicles;

// Add EH to artillery units and some attributes
{

	_x addEventHandler ["HandleDamage", {
		params ["_unit", "_selection", "_damage", "_source", "_projectile", "_hitIndex", "_instigator", "_hitPoint", "_directHit", "_context"];
		// avoid TK by making indestructible by friendly fire
		private ["_getDamage"];
		if ((side _source) != PIG_artyAttackSide) then {
			0
		} else {
			_getDamage = _damage;
			// Make somehow artillery easier to kill
			if ((!canFire _unit) || {!canMove _unit}) then {
				_unit setDamage 1;
			};
			if (_getDamage > 3) then {
				_unit setDamage 1;
			} else {
				_getDamage
			};
		};

	}];
	
	{
		_x addEventHandler ["HandleDamage", {
			params ["_unit", "_selection", "_damage", "_source", "_projectile", "_hitIndex", "_instigator", "_hitPoint", "_directHit", "_context"];
			// avoid TK by making indestructible by friendly fire
			private ["_getDamage"];
			if ((side _source) != PIG_artyAttackSide) then {
				0
			} else {
				_getDamage = _damage;
				// Make somehow artillery easier to kill
				if ((!canFire _unit) || {!canMove _unit}) then {
					_unit setDamage 1;
				};
				if (_getDamage > 3) then {
					_unit setDamage 1;
				} else {
					_getDamage
				};
			};

		}];
	}forEach (crew _x);

	_x addMPEventHandler ["MPKilled", {
		params ["_unit", "_selection", "_damage", "_source", "_projectile", "_hitIndex", "_instigator", "_hitPoint", "_directHit", "_context"];
		
		// Add score to player (testing)
		if (isPlayer _instigator) then {
			_instigator addScore 10;
		};

		PIG_artyVehicles deleteAt (PIG_artyVehicles find _unit);
	}];

	_x allowCrewInImmobile true;

	[_x, _sideAttack] spawn PIG_fnc_fakeArtyFire
}forEach _arty_vehicles;

// Parent Tasks
[
	_sideDefend, 
	"artyDef_task", 
	"parent_artyDefendTask", 
	objNull, 
	"defend" // Icon
] call PIG_fnc_createTask;

[
	_sideAttack, 
	"artyAtt_task", 
	"parent_artyAttackTask", 
	objNull, 
	"destroy" // Icon
] call PIG_fnc_createTask;

// Create Timer
missionNamespace setVariable ["PIG_timerTimeOut", false, true];
[PIG_artyTimer_param] remoteExecCall ["PIG_fnc_manageTimer", 0, true];

{
	_defFormat = (format ["artyDefTask_%1",( _forEachIndex + 1)]);
	_attFormat = (format ["artyAttTask_%1",( _forEachIndex + 1)]);

	// Tasks
	[
		_sideDefend, 
		[_defFormat, "artyDef_task"], 
		["", format["Defenda a artilharia (%1)", (mapGridPosition _x)], ""], 
		[_x, true], 
		"defend", // Icon
		"AUTOASSIGNED",
		false
	] call PIG_fnc_createTask;

	[
		_sideAttack, 
		[_attFormat, "artyAtt_task"], 
		["", format["Destrua a artilharia (%1)", (mapGridPosition _x)], ""], 
		[_x, false], 
		"destroy", // Icon
		"AUTOASSIGNED",
		false
	] call PIG_fnc_createTask;

	// Monitor individual arty
	[_x, _defFormat, _attFormat, _sideDefend] spawn {
		params["_arty", "_defTask", "_attTask", "_sideDefend"];

		waitUntil [{!alive _arty || {missionNamespace getVariable ['PIG_timerTimeOut', false]}}, -1, 1];

		if (!alive _arty) then {
			[_sideDefend, -3] call BIS_fnc_respawnTickets;
			if ((count PIG_artyVehicles == 0) || {missionNamespace getVariable ['PIG_timerTimeOut', false]}) exitWith {};
			[_attTask, 'SUCCEEDED', true] call BIS_fnc_taskSetState; 
			[_defTask, 'FAILED', true] call BIS_fnc_taskSetState;
		};
	};
}forEach _arty_vehicles;

// Create the main trigger to manage the task
[_sideAttack, _patrolGroups] spawn {
	params["_sideAttack", "_patrolGroups"];
	waitUntil [{(count PIG_artyVehicles == 0) || {missionNamespace getVariable ['PIG_timerTimeOut', false]}}, -1, 1];

	private _tickets = (count PIG_artyVehicles * 3);
	if ((count PIG_artyVehicles == 0) && {!(missionNamespace getVariable ['PIG_timerTimeOut', false])}) then {
		[-1, true] call BIS_fnc_countdown;
		['artyAtt_task', 'SUCCEEDED', true] call BIS_fnc_taskSetState; 
		['artyDef_task', 'FAILED', true] call BIS_fnc_taskSetState; 
	} else {
		['artyAtt_task', 'FAILED', true] call BIS_fnc_taskSetState; 
		['artyDef_task', 'SUCCEEDED', true] call BIS_fnc_taskSetState;
		[_sideAttack, - _tickets] call BIS_fnc_respawnTickets;
	};

	if ((count PIG_artyVehicles > 0) && {missionNamespace getVariable ['PIG_timerTimeOut', false]}) then {
		{
			deleteVehicleCrew _x;
			deleteVehicle _x;
		}forEach PIG_artyVehicles;
	};

	{
		{deleteVehicle _x}forEach (units _x);
	}forEach _patrolGroups;

	PIG_artyAttackSide = nil;
	PIG_artyVehicles = nil;

	diag_log "[ARTILLERY OBJECTIVE] Artillery objective finished";
	[] call PIG_fnc_selectTask;
};

diag_log "[ARTILLERY OBJECTIVE] Artillery objective started";
PIG_lastTaskPlayed pushBack "ARTY";