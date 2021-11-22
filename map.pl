:- dynamic(map_object/3).
:- dynamic(map_harvest/4).
:- dynamic(player_position/2). /* posisinya dalam x,y kali ya */

/*  Building/map object can be
    'M' (Marketplace)
    'R' (Ranching)
    'H' (House)
    'o' (Water Tile)
    '=' (Digged Tile) */

/* Facts */
map_size(14,17).
/* Map Objects */
map_object('M', 9, 11).
map_object('R', 9, 4).
map_object('H', 6, 5).
map_object('Q', 6, 2).
/* Water Tile */
map_object('o', 4, 7).
map_object('o', 5, 7).
map_object('o', 6, 7).
map_object('o', 3, 8).
map_object('o', 4, 8).
map_object('o', 5, 8).
map_object('o', 6, 8).
map_object('o', 7, 8).
map_object('o', 4, 9).
map_object('o', 5, 9).
map_object('o', 6, 9).

/* Rules */
/* Init - Reset*/
initMap :-
    map_object('H', X, Y),
    asserta(player_position(X,Y)).

resetMap :-
    retractall(map_object(_,_,_)),
    retractall(map_harvest(_,_,_,_)),
    retractall(player_position(_,_)).

/* Check if player in a specific Object */
isInObject(Object) :-
    player_position(X,Y),
    map_object(Object, X, Y).

/* Check if player in a harvest tile */
isInHarvest(Harvest) :-
    player_position(X,Y),
    map_harvest(Harvest, _, X, Y).

/* Check if player in an empty tile */
isEmptyTile :-
    \+ (isInObject(_); isInHarvest(_)).

/* Check if a position is in map range */
isInMap(X,Y) :-
    map_size(XMax,YMax),
    X >= 0,
    X < XMax,
    Y >= 0,
    Y < YMax.

displayMap(XMax, YMax, X, Y) :-
    Y =< YMax, X =< XMax,
    ((Y == -1, !; Y == YMax), !, (
        write('#')
    ) ; (
        (X == -1, !; X == XMax), !, write('#');
        player_position(X, Y), !, write('P');
        map_object(Obj, X, Y), !, write(Obj);
        map_harvest(Hrv, X, Y), !, write(Hrv);
        write('-')
    )),
    (X == XMax, !, (
        YN is Y + 1,
        XN = -1, nl
    ) ; (
        YN = Y,
        XN is X + 1
    )),
    displayMap(XMax, YMax, XN, YN).

map :-
    map_size(XMax, YMax),
    displayMap(XMax, YMax, -1, -1).
