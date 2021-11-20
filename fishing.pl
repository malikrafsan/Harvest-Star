:- dynamic(player_xp/4). 
:- dynamic(player_position/2).
:- dynamic(fish_items/2).

map_object(1,0,'o').
map_object(1,1,'o').
map_object(2,1,'o').
map_object(2,2,'o').

fish_list([tuna, salmon, catfist, eel, clownfish, shark]).
fish_list_length(6).

init_xp:-
    asserta(player_xp(0,0,0,0)), !.

init_pos:-
    asserta(player_position(0,0)).

startFishing:-
    init_pos,
    init_xp,
    write('welcome!'),nl.

isTiles(X,Y):-
    map_object(X,Y,Z),
    Z = 'o'.

canFish:-
    player_position(X,Y),
    X1 is X - 1,
    Y1 is Y - 1,
    X2 is X + 1,
    Y2 is Y + 1,
    (isTiles(X1,Y);
    isTiles(X2,Y);
    isTiles(X,Y1);
    isTiles(X,Y2)).

indexOf([Head|Tail],0,Head) :- !.
indexOf([Head|Tail],Idx,Elmt):-
  Idx > 0,
  Idx1 is Idx - 1,
  indexOf(Tail, Idx1, Res),
  Elmt = Res.

addItem(Item, Qty) :-
    fish_items(Item, X),
    retract(fish_items(Item,Y)),
    NewQty is X + Qty,
    assertz(fish_items(Item, NewQty)),!
    ;
    assertz(fish_items(Item, Qty)).

takeFish :-
    fish_list(X),
    fish_list_length(Length),
    random(0,Length,Idx),
    indexOf(X,Idx,Elmt),
    random(1,10,Qty),
    addItem(Elmt,Qty),
    write('You got a '),
    write(Elmt),
    write(' with quantity: '), write(Qty), nl.

cantFishMsg :-
    write('you can not fish here').

fish:-
    canFish -> takeFish
    ;
    cantFishMsg.

