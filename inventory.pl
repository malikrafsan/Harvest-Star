:- dynamic(player_inv/2).    /* (ItemName, Qty) */

/* INI NYOBA VERSI INVENTORY KALAU DIGABUNG, NANTI MINTA SARAN MAU PAKE YG MANA */

/* Count the amount of a spesific item or equipment in inventory */
itemQuantity(Name, Qtot) :-
    findall(Qty, player_inv(Name, Qty), List), /* Pake list biar kalau equipmentnya gaada, gk error, sum nya 0 */
	sum_list(List,Qtot).

/* Count the NEFF of the inventory */
inventoryNeff(Neff) :-
    itemQuantity(_, Qty),
    Neff is Qty.

/* To print all the items in inventory */
inventory :-
    inventoryNeff(Neff),
    nl,write('Your inventory ('), write(Neff), write('/100)'), nl,
    (\+player_inv(_,_), write('Your inventory is empty!'), nl,!;
    forall(player_inv(Name,Qty),(equipment(Name,Level,_,_) -> write(Qty),write(' Level '), write(Level), write(' '), write(Name), nl; 
    write(Qty), write(' '),  write(Name), nl))).

/* To add item or equipment to the inventory*/
addItem(_) :- /* Inventory is full, so fail. */
    inventoryNeff(Neff),
    (Neff >= 100),
    write('Inventory is full!'), nl, !, fail.

addItem(Name) :- /* item not in inventory, so add 1 */
    item(Name, _, _),
    \+player_inv(Name,_),
    assertz(player_inv(Name,1)),!.

addItem(Name) :- /* Same as above but equipment version */
    equipment(Name,_, _, _),
    \+player_inv(Name,_),
    asserta(player_inv(Name,1)),!.

addItem(Name) :- /* item already in inventory, so qty + 1 */
    player_inv(Name, Qty),
    Qty1 is Qty + 1,
    retract(player_inv(Name,Qty)),
    (equipment(Name,_,_,_) -> asserta(player_inv(Name,Qty1));
    assertz(player_inv(Name,Qty1))), !.

/* Delete an item or equipment from the inventory */

delItem(Name) :- /* Item not in inventory */
    \+player_inv(Name,_), !, fail. 

delItem(Name) :- /* Exactly 1 item, so remove it */
    player_inv(Name,Qty),
    Qty =:= 1,
    retract(player_inv(Name,Qty)), !.

delItem(Name) :- /* More than 1 Item, so minus 1 */
    player_inv(Name,Qty),
    Qty1 is Qty - 1,
    retract(player_inv(Name,Qty)),
    (equipment(Name,_,_,_) -> asserta(player_inv(Name,Qty1));
    assertz(player_inv(Name,Qty1))), !.

/* To use add and del multiple N times*/
addItemNtimes(_, 0) :- !.
addItemNtimes(Name, N) :- 
    addItem(Name), N1 is N - 1, addItemNtimes(Name, N1).

delItemNtimes(_, 0) :- !.
delItemNtimes(Name, N) :- 
    delItem(Name), N1 is N - 1, delItemNtimes(Name, N1).

/* command throwItem seperti pada spek tubes */
itemdibuang(Name) :- 
    player_inv(Name,Qty),
    write('How many '), write(Name), write(' do you want to throw?'), nl,
    read(X), nl,
    (X > Qty , write('You don`t have enough '), write(Name), write(', cancelling...'), nl ;
    delItemNtimes(Name,X)).

throwItem :- 
    inventory, nl,
    write('What do you want to throw?'), nl,
    read_string(Name), nl,
    (\+player_inv(Name,_), write('Item not in inventory, cancelling.....'), !;
    itemdibuang(Name)).

giveDefaultItems :- 
    addItemNtimes('Training Fishing Rod',1),
    addItemNtimes('Egg',5),
    addItemNtimes('Rusty Shovel',1),
    addItemNtimes('Carrot',5),
    addItemNtimes('Snapper',3).

/* addItem('Rusty Shovel').
addItem('Iron Shovel').
addItem('Egg').
addItem('Crab').
addItemNtimes('Rusty Shovel',7).
addItemNtimes('Egg',8).
addItemNtimes('Iron Shovel',3).
addItemNtimes('Crab',5).
*/

