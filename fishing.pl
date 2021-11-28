% COMMANDS
fish:-
    canFish -> takeFish
    ;write('You can\'t fish here').

% FACTS AND RULES
fish_list(['Tuna', 'Salmon', 'Catfist', 'Eel', 'Crab', 'Snapper']).
fish_list_length(6).
upperLimitXPFish(11).
defaultChance(1000).
thresholdChance(500).

isTiles(X,Y):-
    % Mengembalikan true jika posisi X Y merupakan tiles air
    map_object('o',X,Y).

canFish :-
    % Mengembalikan true jika player bisa memancing
    state(outside),
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

% Mencari elemen dalam list pada index tertentu
indexOf([Head|Tail],0,Head) :- !.
indexOf([Head|Tail],Idx,Elmt):-
    Idx > 0,
    Idx1 is Idx - 1,
    indexOf(Tail, Idx1, Res),
    Elmt = Res.

addFishXP :-
    % Menambahkan XP pada player sesuai job
    upperLimitXPFish(Limit1), 
    random(1,Limit1,X),
    add_xp(X,0,0),
    write('You gained '),
    write(X),
    write(' fishing exp!'),nl.

getChance(Chance) :-
    % Menentukan chance tambahan player mendapatkan ikan berdasarkan equipment 
    player_inv(Name,_),
    equipment(Name,Lvl,'Fish',Price),
    Chance is Lvl * Price
    ,!;
    Chance is 0.

isGotFish :-
    % Mengembalikan true jika player mendapatkan ikan sesuai chance dan threshold
    defaultChance(Chance),
    getChance(ChanceEquipment),
    TotalChance is Chance + ChanceEquipment,
    random(0,TotalChance,X),
    thresholdChance(Threshold),
    X >= Threshold.

takeFish :-
    % Melakukan fishing dan menambahkan XP pada player
    fish_list(X),
    fish_list_length(Length),
    (
        isGotFish,
        (
            random(0,Length,Idx),
            indexOf(X,Idx,Elmt),
            player_lvl(Ltot,Lfish,Lfarm,Lranch),
            Limit is Lfish * 2,
            random(1,Limit,Qty),
            addItemNtimes(Elmt,Qty),
            (
                progressQuest(0,Qty,0)
                ,!;!
            ),
            write('You got a '),
            write(Elmt),
            write(' with quantity: '), write(Qty), nl
        ),!;
        write('You didn\'t get anything!'),nl
    ),
    addFishXP.

