% COMMANDS
dig :-
    % Melakukan command dig sesuai validasi
    isNotEmptyTile, 
    write('you can\'t dig here\n'),!
    ;
    doDig.

plant :-
    % Melakukan command plant sesuai validasi
    player_position(X,Y),
    (
        map_harvest('=',X,Y,_), planting
        ,!;
        write('you can\'t plant here\n')        
    ).

harvest :-
    % Melakukan command harvest sesuai validasi
    player_position(X,Y),
    map_harvest(Symbol,X,Y,HarvestTime),
    (
        HarvestTime = 0,
        addHarvestItem(Symbol),
        retract(map_harvest(Symbol,X,Y,HarvestTime)),
        addFarmXP
        ,!;
        write('Your plant is not ready to be harvested')   
    ),!;
    write('You are not in harvest place').


% FACTS AND RULES
harvest(carrot,'c').
harvest(wheat,'w').
harvest(tomato,'t').
harvest(potato,'p').
seedItem('Carrot Seeds', carrot).
seedItem('Wheat Seeds', wheat).
seedItem('Tomato Seeds', tomato).
seedItem('Potato Seeds', potato).
harvestItem('Carrot', carrot).
harvestItem('Wheat', wheat).
harvestItem('Tomato', tomato).
harvestItem('Potato', potato).
limitDayHarvest(10).
upperLimitXPFarm(11).

initHarvest:- % FOR TESTING ONLY
    addItemNtimes('Carrot Seeds',4),
    addItemNtimes('Wheat Seeds',1),
    addItemNtimes('Tomato Seeds',10),
    addItemNtimes('Potato Seeds',2).

isNotEmptyTile :-
    % Mengembalikan true jika posisi player merupakan posisi gedung atau tanaman
    player_position(X,Y),
    (
        map_object(_,X,Y)
        ;map_harvest(_,X,Y,_)
    ).

doDig :-
    % Melakukan dig ke tiles tanah dan mengubah map
    player_position(X,Y),
    assertz(map_harvest('=',X,Y,-1)), 
    write('you dig the tile\n').

changeTilesHarvest(Harvest) :-
    % Mengubah tiles map menjadi simbol tanaman
    player_position(X,Y),
    harvest(Harvest,S),
    limitDayHarvest(Limit),
    (
        player_inv(Name,_),
        equipment(Name,Lvl,'Harvest',_)
        ,!;
        Lvl is 1
    ),
    Max is Limit // Lvl,
    random(1,Max,R),
    retract(map_harvest(_,X,Y,_)),
    assertz(map_harvest(S,X,Y,R)).

doPlant(X) :-
    % Melakukan penanaman sesuai parameter dan mengurangi jumlah pada inventory
    seedItem(Name,X),
    (
        delItem(Name),
        changeTilesHarvest(X),
        nl,write('You planted a '),
        write(X), write(' seed.\n')
    ),!;
    write('your input is invalid').

hasSeed :-
    % Mengembalikan true jika player memiliki seed
    player_inv(Name,_),
    item(Name,'Seeds',_),!.

planting :-
    % Melakukan penanaman berdasarkan input user
    hasSeed,
    (
        write('You have: '),nl,
        forall(player_inv(Name,Qty),(
            item(Name,'Seeds',_),
            seedItem(Name,RealName),
            write('-   '),write(Qty),write(' '),write(RealName),write(' seed'),nl
            ,!;!
        )),
        write('What do you want to plant?'),nl,
        read(X),
        doPlant(X)
    ),!;
    write('You don\'t have any seeds').

updateHarvestTime :-
    % Meng-update semua harvest time dari semua tanaman
    forall((map_harvest(Symbol,X,Y,HarvestTime)),(
        retract(map_harvest(Symbol,X,Y,HarvestTime)),
        HarvestTime = 0, 
        assertz(map_harvest(Symbol,X,Y,0))
        ,!;
        NewHarvestTime is HarvestTime-1,
        assertz(map_harvest(Symbol,X,Y,NewHarvestTime))
    )).

addHarvestItem(Symbol) :-
    % Menambahkan harvest item ke inventory
    harvest(Item,Symbol),
    harvestItem(Name,Item),
    player_lvl(_,_,Lfarm,_),
    Max is Lfarm * 3,
    random(1,Max,Random),
    addItemNtimes(Name,Random),
    (
        progressQuest(Random,0,0)
        ,!;!
    ).

addFarmXP :-
    % Menambahkan XP pada player sesuai job
    upperLimitXPFarm(Limit), 
    random(1,Limit,X),
    add_xp(0,X,0),
    write('You gained '),
    write(X),
    write(' farming exp!'),nl.