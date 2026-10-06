/*
	Author: PiG13BR

	Put classnames of the airplanes that you want the players to use.
	I recommend to repeat the same classes in both teams to make sure that the gameplay will be balanced
*/

params["_side"];
private _planes = [];

switch (_side) do {
	case east : {
		_planes = [
			// NATO Planes (Vanilla)
			"B_Plane_CAS_01_dynamicLoadout_F", 
			"B_Plane_Fighter_01_F", 
			// OPFOR Planes (Vanilla)
			"O_Plane_Fighter_02_F",
			"O_Plane_Fighter_02_Stealth_F",
			// AAF Planes
			"I_Plane_Fighter_04_F",
			"I_Plane_Fighter_03_dynamicLoadout_F",
			// FIR
			"FIR_A10C",
			"FIR_F14D",
			"FIR_F15D",
			"FIR_F16D",
			"FIR_F18D",
			"FIR_AV8B_NA_Blank",
			"FIR_F22",
			"FIR_Su25SM3"
		];
	};
	case west : {
		_planes = [
			// NATO Planes (Vanilla)
			"B_Plane_Fighter_01_F", 
			// OPFOR Planes (Vanilla)
			"O_Plane_CAS_02_dynamicLoadout_F",
			"O_Plane_Fighter_02_F",
			"O_Plane_Fighter_02_Stealth_F",
			// AAF Planes
			"I_Plane_Fighter_04_F",
			"I_Plane_Fighter_03_dynamicLoadout_F",
			// FIR
			"FIR_A10C",
			"FIR_F14D",
			"FIR_F15D",
			"FIR_F16D",
			"FIR_F18D",
			"FIR_AV8B_NA_Blank",
			"FIR_F22",
			"FIR_Su25SM3"
		];
	}
};

_planes = _planes select {isClass (configFile >> "CfgVehicles" >> _x)};

_planes