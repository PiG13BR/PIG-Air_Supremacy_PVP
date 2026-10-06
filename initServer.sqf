private _AAA_east_group = createGroup [east, true];
{
    _x allowDamage false;
    _AAA_east_group createVehicleCrew _x;
}forEach [EAST_AAA, EAST_SAM];

private _AAA_west_group = createGroup [west, true];
{
    _x allowDamage false;
    _AAA_west_group createVehicleCrew _x;
}forEach [WEST_AAA, WEST_SAM]