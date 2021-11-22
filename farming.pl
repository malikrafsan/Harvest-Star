:- dynamic(map_object/3).
:- dynamic(player_position/2).
:- dynamic(seed_inventory/2).
:- dynamic(map_harvest/4).
:- dynamic(harvest_inventory/1).

map_object(1,2,'A').
map_object(1,3,'D').
map_object(2,2,'C').
map_object(1,1,'B').

digTileSymbol('=').
harvest(corn,'c').
harvest(wheat,'w').
harvest(tomato,'t').
harvest(potato,'p').

init:-
    asserta(player_position(9,1)),
    asserta(seed_inventory(tomato,2)),
    asserta(seed_inventory(corn,1)). 

isNotEmptyTile :-
    player_position(X,Y),
    map_object(X,Y,O)
    ;
    map_harvest(X,Y,S,H).

cantDigMsg :-
    write('you can\'t dig here\n').

doDig :-
    player_position(X,Y),
    digTileSymbol(S),
    assertz(map_harvest(X,Y,S,-1)), 
    write('you dig the tile\n').

dig :-
    isNotEmptyTile, 
    write('you can\'t dig here\n'),!
    ;
    doDig.

cantPlantMsg :-
    write('you can\'t plant here\n').

changeTilesHarvest(Harvest) :-
    player_position(X,Y),
    harvest(Harvest,S),
    random(1,10,R),
    retract(map_harvest(X,Y,_,_)),
    assertz(map_harvest(X,Y,S,R)).

doPlant(X) :-
    retract(seed_inventory(X,N)),(
        changeTilesHarvest(X),
        nl,write('You planted a '),
        write(X), write(' seed.\n'),
        N1 is N-1,
        (N1 = 0,
        !;
        assertz(seed_inventory(X,N1)))
    ),!;
    write('your input is invalid').

planting :-
    write('You have: '),nl,
    forall(seed_inventory(Name,Qty),(
        write('-   '),write(Qty),write(' '),write(Name),nl
    )),
    write('What do you want to plant?'),nl,
    read(X),
    doPlant(X).

plant :-
    player_position(X,Y),
    digTileSymbol(S),
    map_harvest(X,Y,S,Z),
    planting,!
    ;
    cantPlantMsg.
    
updateHarvestTime :-
    forall((map_harvest(X,Y,Symbol,HarvestTime)),(
        retract(map_harvest(X,Y,Symbol,HarvestTime)),
        HarvestTime = 0, 
        assertz(map_harvest(X,Y,Symbol,0)),!
        ;
        NewHarvestTime is HarvestTime-1,
        assertz(map_harvest(X,Y,Symbol,NewHarvestTime))
    )).

addHarvestItem(Symbol) :-
    harvest(Item,Symbol),
    assertz(harvest_inventory(Item)).

harvest :-
    player_position(X,Y),
    map_harvest(X,Y,Symbol,HarvestTime),
    (
        HarvestTime = 0,
        addHarvestItem(Symbol),
        retract(map_harvest(X,Y,Symbol,HarvestTime)),
        !;
        write('Your plant is not ready to be harvested')   
    ),!;
    write('You are not in harvest place').