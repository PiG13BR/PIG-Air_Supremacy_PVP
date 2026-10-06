/*
	Set view distance at the start of the game
*/

_this spawn {
	while {true} do {
		setViewDistance (_this select 0);
		setObjectViewDistance (_this select 0);
		sleep 0.1;
	};
};
