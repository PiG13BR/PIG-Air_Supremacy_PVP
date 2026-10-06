params["_control"];

private _display = ctrlParent _control;

// Spawning the jet
private _vehicleClass = localNameSpace getVariable "PIG_airCraftSelected";

private _spawned = [PIG_PAS_player, _vehicleClass] call PIG_fnc_spawnJet;

if (_spawned) then {
    _display closeDisplay 1;
};