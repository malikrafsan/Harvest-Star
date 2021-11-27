fish_list(['Tuna', 'Salmon', 'Catfist', 'Eel', 'Crab', 'Snapper']).
fish_list_length(6).
upperLimitXP(11).
upperLimitFishermanXP(21).
defaultChance(1000).
thresholdChance(500).
getFishChange(500).

isTiles(X,Y):-
    map_object('o',X,Y).

canFish:-
    player_position(X,Y),
    X1 is X - 1,
    Y1 is Y - 1,
    X2 is X + 1,
    Y2 is Y + 1,
    (
        isTiles(X1,Y)
        ;isTiles(X2,Y)
        ;isTiles(X,Y1)
        ;isTiles(X,Y2)
    ).

indexOf([Head|Tail],0,Head) :- !.
indexOf([Head|Tail],Idx,Elmt):-
    Idx > 0,
    Idx1 is Idx - 1,
    indexOf(Tail, Idx1, Res),
    Elmt = Res.

isPlayerFisher :-
    player_job('Fisherman').

addFishXP :-
    (
        isPlayerFisher, 
        upperLimitFishermanXP(Limit), 
        random(1,Limit,X)
        ,!;
        upperLimitXP(Limit1), 
        random(1,Limit1,X)
    ),
    add_xp(X,0,0),
    write('You gained '),
    write(X),
    write(' fishing exp!'),nl.

accumulatePriceLvl([],[], 0).
accumulatePriceLvl([HPrice|TPrice],[HLvl|TLvl],Sum) :-
    accumulatePriceLvl(TPrice,TLvl,Sum1),
    Sum is Sum1 + (HPrice * HLvl).

getChance(Chance) :-
    findall(Price,equipment(Name,Lvl,'Fish',Price),BagPrice),
    findall(Lvl,equipment(Name,Lvl,'Fish',Price),BagLvl),
    accumulatePriceLvl(BagPrice,BagLvl, Res),
    Chance is Res;
    Chance is 0.

isGotFish :-
    defaultChance(Chance),
    getChance(ChanceEquipment),
    TotalChance is Chance + ChanceEquipment,
    random(0,TotalChance,X),
    thresholdChance(Threshold),
    X >= Threshold.

takeFish :-
    fish_list(X),
    fish_list_length(Length),
    (
        isGotFish,
        random(0,Length,Idx),
        indexOf(X,Idx,Elmt),
        random(1,10,Qty),
        addItemNtimes(Elmt,Qty),
        write('You got a '),
        write(Elmt),
        write(' with quantity: '), write(Qty), nl
        ,!;
        write('You didn\'t get anything!'),nl
    ),
    addFishXP.

fish:-
    canFish -> takeFish
    ;
    write('You can\'t fishing here').

