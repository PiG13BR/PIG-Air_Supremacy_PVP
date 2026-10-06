#include "..\defines.hpp"
/*
	File: fn_handlePlanesCb.sqf
	Author: PiG13BR - https://github.com/PiG13BR
	Date: 03/10/2026
	Last Update: 05/10/2026
	License: MIT License - http://www.opensource.org/licenses/MIT

	Description:
        Handles planes selector

	Parameter(s):
		_control - combo box [CONTROL]
	
	Returns:
		-
*/
params ["_control", "_lbCurSel", "_lbSelection"];

private _display = ctrlParent _control;

// Get aircraft selected
private _ctrlPlanesCb = _display displayCtrl IDC_PLANES_COMBOBOX;
private _aircraftSel = _ctrlPlanesCb lbData _lbCurSel;
localNameSpace setVariable ["PIG_airCraftSelected", _aircraftSel];

// Spawn local jet
private _vehicleLocal = _aircraftSel call PIG_fnc_spawnLocalJet;
localNamespace setVariable ["PIG_PAS_aircraft", _vehicleLocal];

//private _lastAngle = uiNamespace getVariable "PIG_jetMenu_lastCamera"; // Maintain the same camera angle when changing the airplane
//[_vehicleLocal, _lastAngle] call PIG_fnc_cameraAngle;
//--------------- Camera
[_display, _vehicleLocal] call PIG_fnc_loadCameraHandle;

[_display, _vehicleLocal] call PIG_fnc_loadPylonsLb;