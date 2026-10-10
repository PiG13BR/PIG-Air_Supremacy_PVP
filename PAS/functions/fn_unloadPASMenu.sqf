#include "..\defines.hpp"
/*
	File: fn_unloadPASMenu.sqf
	Author: PiG13BR - https://github.com/PiG13BR
	Date: 14/10/2025
	Last Update: 07/10/2026
	License: MIT License - http://www.opensource.org/licenses/MIT

	Description:
		Unloads pylon armament selector

	Parameter(s):
		_display - display to unload [DISPLAY, defauls to displayNull]
	
	Returns:
		-
*/
params["_display"];

if !(PIG_jet_spawned) then {
	[] call PIG_fnc_createPASRsc;
};

private _aircraft = localNameSpace getVariable ["PIG_PAS_aircraft", objNull];

// Clear variables
// PIG_PAS_airLoadout = nil;
PIG_PAS_pylonsTurret = nil;

deleteVehicle (localNamespace getVariable 'PIG_PAS_LightSource');
localNamespace setvariable ["PIG_PAS_LightSource", nil];
PIG_PAS_pylonsPosHash = nil;

localNameSpace setVariable ["PIG_PAS_pylonName", nil];

// Unload camera
[] call PIG_fnc_unloadCameraHandle;

if !(isNil "PIG_PAS_turretUpdateHandle") then {
	removeMissionEventHandler ["Draw3D", PIG_PAS_turretUpdateHandle];
};

_aircraft setVariable ["PIG_PAS_isBusy", false];
localNamespace getVariable ["PIG_PAS_aircraft", nil];

PIG_PAS_player = nil;

deleteVehicle (localNamespace getVariable 'PIG_PAS_vehicleLocal');
localNamespace setVariable ['PIG_PAS_vehicleLocal', nil];