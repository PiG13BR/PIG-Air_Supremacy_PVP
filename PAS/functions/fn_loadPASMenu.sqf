#include "..\defines.hpp"
/*
	File: fn_loadPASMenu.sqf
	Author: PiG13BR - https://github.com/PiG13BR
	Date: 14/10/2025
	Last Update: 03/10/2026
	License: MIT License - http://www.opensource.org/licenses/MIT

	Description:
		Loads pylon armament selector menu

	Parameter(s):
		_display - loaded display [DISPLAY, defauls to displayNull]
		_aircraft - aircraft to change pylons [OBJECT, defaults to objNull]
	
	Returns:
		-
*/
params[["_display", findDisplay 46]];

if (_display == displayNull) exitWith {};

localNameSpace setVariable ["PIG_PAS_pylonIndex", -1];

private _side = side (group player);

PIG_PAS_pylonsTurret = createHashMap;
PIG_PAS_cfgPresets = createHashMap;

// Spawn pos jet placeholder
private _pattern = format["%1_jet_placeholder", tolowerANSI (str _side)];
private _markers = allMapMarkers select {((toLowerANSI _x) find _pattern) == 0};
_markerPlaceholder = selectRandom _markers;
localNameSpace setVariable ["PIG_PAS_placeholderMarker", _markerPlaceholder];

// Create lightsoruce (lifted from arsenal.sqf)
_intensity = 20;
_light = "#lightpoint" createvehicleLocal (getPosATL _placeholder);
_light setlightbrightness _intensity;
_light setlightambient [1, 1, 1];
_light setlightcolor [0, 0, 0];
_light lightattachobject [_placeholder, [0, 0, -_intensity * 7]];
_light setLightDayLight false;

localNamespace setvariable ["PIG_PAS_LightSource", _light];

PIG_PAS_airLoadout = [];

[_display] call PIG_fnc_reloadPresetControls;

private _ctrlPlanesCb = _display displayCtrl IDC_PLANES_COMBOBOX;

private _preset = ([_side] call PIG_planes_preset);
if (_preset isEqualTo []) exitWith {_display closeDisplay 1; ["Preset array is empty"] call BIS_fnc_error};

{
	_name = getText(configFile >> "CfgVehicles" >> _x >> "displayName");
	_ctrlPlanesCb lbAdd _name;
	_ctrlPlanesCb lbSetData [_forEachIndex, _x]
}forEach _preset;

// Select an airplane
_ctrlPlanesCb lbSetCurSel 0;