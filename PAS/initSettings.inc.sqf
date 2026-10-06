// Invert camera movement
[
    "PIG_PAS_camInverted",
    "CHECKBOX",
    localize "STR_TITLE_SETTING_INVERT_CAMERA",
    localize "STR_PAS_TITLE",
    false
] call CBA_fnc_addSetting;

// Required objects nearby
[
    "PIG_PAS_RequireNearby", 
    "EDITBOX",  
    [localize "STR_PAS_SETTING_NEARBYOBJECTS_DESCRIPTION", localize "STR_PAS_SETTING_NEARBYOBJECTS_TOOLTIP"], 
    [localize "STR_PAS_TITLE"], 
    "['Land_Missle_Trolley_02_F', 'Land_Bomb_Trolley_01_F']",
    true // Global
] call CBA_fnc_addSetting;