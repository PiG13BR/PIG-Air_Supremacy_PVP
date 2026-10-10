mode = 1;	// whitelist only
jip = 0;	// JIP flag not allowed

// BIS
class BIS_fnc_debugConsoleExec				{ allowedTargets = 0; }; //Allow debug console (optional)
class BIS_fnc_effectKilledAirDestruction	{ allowedTargets = 0; jip = 0; };
class BIS_fnc_effectKilledSecondaries		{ allowedTargets = 0; jip = 0; };
class BIS_fnc_fire							{ allowedTargets = 0; jip = 0; };
class BIS_fnc_objectVar						{ allowedTargets = 0; jip = 0; };
class BIS_fnc_setCustomSoundController		{ allowedTargets = 0; jip = 0; };

// Camera handle
class PIG_fnc_handleKeyDown	        { allowedTargets = 1; jip = 0; };
class PIG_fnc_handleMouse	        { allowedTargets = 1; jip = 0; };
class PIG_fnc_handleScrollWheel	        { allowedTargets = 1; jip = 0; };
class PIG_fnc_loadCameraHandle	        { allowedTargets = 1; jip = 0; };
class PIG_fnc_mouseButtonDown	        { allowedTargets = 1; jip = 0; };
class PIG_fnc_mouseButtonUp	        { allowedTargets = 1; jip = 0; };
class PIG_fnc_unloadCameraHandle	        { allowedTargets = 1; jip = 0; };
class PIG_fnc_updateCamPos	        { allowedTargets = 1; jip = 0; };

// PAS
class PIG_fnc_applyTurretPylon	        { allowedTargets = 1; jip = 1; };
class PIG_fnc_createPASRsc	        { allowedTargets = 1; jip = 1; };
class PIG_fnc_createTurretButtons	        { allowedTargets = 1; jip = 1; };
class PIG_fnc_deleteAirPreset	        { allowedTargets = 1; jip = 1; };
class PIG_fnc_fillMagazinesListBox	        { allowedTargets = 1; jip = 1; };
class PIG_fnc_getAllPylonsPos	        { allowedTargets = 1; jip = 1; };
class PIG_fnc_getCfgWeapons	        { allowedTargets = 1; jip = 1; };
class PIG_fnc_getPylonTurret	        { allowedTargets = 1; jip = 1; };
class PIG_fnc_handleAirMagazinesLb	        { allowedTargets = 1; jip = 1; };
class PIG_fnc_handleAirPresetsLb	        { allowedTargets = 1; jip = 1; };
class PIG_fnc_handleLoadPresetButton	        { allowedTargets = 1; jip = 1; };
class PIG_fnc_handleMagazineCombo        { allowedTargets = 1; jip = 1; };
class PIG_fnc_handlePlanesCb	        { allowedTargets = 1; jip = 1; };
class PIG_fnc_handlePresetDoubleClick	        { allowedTargets = 1; jip = 1; };
class PIG_fnc_handlePresetEdit	        { allowedTargets = 1; jip = 1; };
class PIG_fnc_handleTurretButton	        { allowedTargets = 1; jip = 1; };
class PIG_fnc_hint	        { allowedTargets = 1; jip = 1; };
class PIG_fnc_loadAirPreset	        { allowedTargets = 1; jip = 1; };
class PIG_fnc_loadPASMenu	        { allowedTargets = 1; jip = 1; };
class PIG_fnc_loadPylonsLb	        { allowedTargets = 1; jip = 1; };
class PIG_fnc_reloadLoadout	        { allowedTargets = 1; jip = 1; };
class PIG_fnc_reloadPresetsLb	        { allowedTargets = 1; jip = 1; };
class PIG_fnc_removeTurretWeapons	        { allowedTargets = 1; jip = 1; };
class PIG_fnc_renameAirPreset	        { allowedTargets = 1; jip = 1; };
class PIG_fnc_resetAirProfileLoadout	        { allowedTargets = 1; jip = 1; };
class PIG_fnc_reloadPresetControls	        { allowedTargets = 1; jip = 1; };
class PIG_fnc_saveAirPreset	        { allowedTargets = 1; jip = 1; };
class PIG_fnc_saveNewAirPreset	        { allowedTargets = 1; jip = 1; };
class PIG_fnc_setFavoriteMagazine	        { allowedTargets = 1; jip = 1; };
class PIG_fnc_setLbPictureRight	        { allowedTargets = 1; jip = 1; };
class PIG_fnc_setPylonConfiguration	        { allowedTargets = 1; jip = 1; };
class PIG_fnc_spawnButton	        { allowedTargets = 1; jip = 1; };
class PIG_fnc_spawnLocalJet	        { allowedTargets = 1; jip = 1; };
class PIG_fnc_unloadPASMenu	        { allowedTargets = 1; jip = 1; };
class PIG_fnc_updateTurretButton	        { allowedTargets = 1; jip = 1; };

// Main mission functions
class PIG_fnc_repairRearmRefuel	        { allowedTargets = 0; jip = 1; }
class PIG_fnc_safeZone	        { allowedTargets = 0; jip = 1; }