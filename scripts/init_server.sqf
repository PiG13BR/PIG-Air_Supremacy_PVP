// Remove fog
0 setFog 0;

// Init presets
PIG_presets_convoy = compileFinal preprocessFileLineNumbers "presets\convoy\convoy_preset.sqf";
PIG_routes_convoy = compileFinal preprocessFileLineNumbers "presets\convoy\convoy_routes.sqf";
PIG_presets_artillery = compileFinal preprocessFileLineNumbers "presets\artillery\artillery_preset.sqf";

// Spawn schedule codes
spawn PIG_fnc_selectTask;
spawn PIG_fnc_autoCleaner;
spawn PIG_fnc_timeMultiplier;
spawn PIG_fnc_manageWeather;
spawn PIG_fnc_curatorRegisterObjects; // Update objects for zeus
