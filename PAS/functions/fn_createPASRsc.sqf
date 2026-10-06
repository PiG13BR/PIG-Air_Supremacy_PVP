#include "..\defines.hpp"
/*
	File: fn_createPASRsc.sqf
	Author: PiG13BR - https://github.com/PiG13BR
	Date: 14/10/2025
	Last Update: 03/10/2026
	License: MIT License - http://www.opensource.org/licenses/MIT

	Description:
		Create display for pylon armament selector
		
	Parameter(s):
		_player - player that opened the display [OBJECT, defaults to player]
	
	Returns:
		-
*/

params[["_player", player, [objNull]]];

private _displayToUse = findDisplay IDD_MISSION;

PIG_PAS_player = _player;

[{_this createDisplay "PIG_PAS_RscMainMenu"}, _displayToUse] call CBA_fnc_execNextFrame;