// onPlayerRespawn.sqf
params ["_unit", "_corpse"];

waitUntil {!isNil "PIG_serverReady"};

PIG_jet_spawned = false;
PIG_jet_ready = false;

_unit allowDamage false;

// Delete the corpse. Checking if the corpse is null.
if (!(isNull _corpse)) then {
	// Return parent object of the corpse (corpse inside a vehicle)
    _vehicle = objectParent _corpse;
	
    if (!(isNull _vehicle)) then {
	// The corpse is inside a vehicle
        _vehicle deleteVehicleCrew _corpse;
    } else {
		// The corpse is not inside a vehicle
        deleteVehicle _corpse;
    };
};

if (!PIG_serverReady || {!PIG_clientReady}) then {
    waitUntil {
        sleep 0.1; 
        0 cutText ["Iniciando...", "BLACK FADED"]; 

        (PIG_clientReady) && {PIG_serverReady}
    };
};

cutText ['', 'BLACK IN'];

[_unit] call PIG_fnc_createPASRsc;
