PIG_planes_preset = compileFinal preprocessFileLineNumbers "presets\players\planes.sqf";

// Set up RRR for each team
[east] call PIG_fnc_createRRR;
[west] call PIG_fnc_createRRR;

PIG_clientReady = true;