params ["_player", "_didJIP"];

_player setVariable ["PIG_startLoadout", getUnitLoadout _player];
_player addEventHandler ["Respawn", { 
	params ["_unit", "_corpse"];
	private _loadout = _unit getVariable "PIG_startLoadout"; if (!isNil "_loadout") then { _unit setUnitLoadout _loadout; }; 
}];

_player addEventHandler ["GetOutMan", {
	params ["_unit", "_role", "_vehicle", "_turret", "_isEject"];
	// If player ejects, detects if it's on ground. If it is, kill it.
	_unit spawn {
		waitUntil [{
			((isTouchingGround _this) || (((getPosATL _this) # 2) < 2) || (((getPosASL _this) # 2) < 2)) && PIG_jet_spawned
		}, 60, 0.3];
		_this setdamage 1;
	}
}];

enableRadio false;