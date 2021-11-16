:- dynamic(player_invequipment/2).    /* (EquipmentName, Qty) */
:- dynamic(player_invitem/2).    /* (ItemName, Qty) */

/* REVISI DARI PDF DISKUSI, INI AGAK LUMAYAN BEDA BANGET SOALNYA LIST OF ITEMS SULIT */


/* Count the amount of a spesific item or equipment in inventory */
itemQuantity(Name, Qtot) :-
    findall(Qty, player_invitem(Name, Qty), List),
	sum_list(List,Qtot).

equipmentQuantity(Name, Qtot) :-
    findall(Qty, player_invequipment(Name, Qty), List),
	sum_list(List,Qtot).

/* Count the NEFF of the inventory */
inventoryNeff(Neff) :-
    itemQuantity(_, Qty),
    equipmentQuantity(_, Qty1),
    Neff is Qty + Qty1.

/* To print all the items in inventory */
inventoryequipment :-
    forall(player_invequipment(Name,Qty),(write(Qty), equipment(Name,Level,_,_),write(' Level '), write(Level), write(' '), write(Name), nl)).

inventoryitem :-
    forall(player_invitem(Name,Qty),(write(Qty), write(' '),  write(Name), nl)).

inventory :-
    inventoryNeff(Neff),
    nl,write('Your inventory ('), write(Neff), write('/100)'), nl,
    inventoryequipment,
    inventoryitem.

/* To add item or equipment to the inventory*/
addItem(_) :- /* Inventory is, so fail. */
    inventoryNeff(Neff),
    (Neff >= 100),
    write('Inventory is full!'), nl, !, fail.

addItem(Name) :- /* item not in inventory, so add 1 */
    item(Name, _, _),
    \+player_invitem(Name,_),
    asserta(player_invitem(Name,1)),!.

addItem(Name) :- /* item already in inventory, so qty + 1 */
    player_invitem(Name, Qty),
    Qty1 is Qty + 1,
    retract(player_invitem(Name,Qty)),
    asserta(player_invitem(Name,Qty1)), !.

addEquipment(_) :- /* Inventory is full, so fail. */
    inventoryNeff(Neff),
    (Neff >= 100),
    write('Inventory is full!'), nl, !, fail.

addEquipment(Name) :- /* Equipment not in inventory, so add 1 */
    equipment(Name, _, _,_),
    \+player_invequipment(Name,_),
    asserta(player_invequipment(Name,1)),!.

addEquipment(Name) :- /* Equipment already in inventory, so qty + 1 */
    player_invequipment(Name, Qty),
    Qty1 is Qty + 1,
    retract(player_invequipment(Name,Qty)),
    asserta(player_invequipment(Name,Qty1)), !.

/* Delete an item or equipment from the inventory */

delItem(Name) :- /* Item not in inventory */
    \+player_invitem(Name,_), !, fail. 

delItem(Name) :- /* Exactly 1 item, so remove it */
    player_invitem(Name,Qty),
    Qty =:= 1,
    retract(player_invitem(Name,Qty)), !.

delItem(Name) :- /* More than 1 Item, so minus 1 */
    player_invitem(Name,Qty),
    Qty1 is Qty - 1,
    retract(player_invitem(Name,Qty)),
    asserta(player_invitem(Name,Qty1)), !.

delEquipment(Name) :- /* Equipment not in inventory */
    \+player_invequipment(Name,_), !, fail.

delEquipment(Name) :- /* Exactly 1 equipment, so remove it */
    player_invequipment(Name,Qty),
    Qty =:= 1,
    retract(player_invequipment(Name,Qty)), !.

delEquipment(Name) :- /* More than 1 equipment, so qty minus 1 */
    player_invequipment(Name,Qty),
    Qty1 is Qty - 1,
    retract(player_invequipment(Name,Qty)),
    asserta(player_invequipment(Name,Qty1)), !.

/* To use add and del multiple N times*/
addItemNtimes(_, 0) :- !.
addItemNtimes(Name, N) :- 
    addItem(Name), N1 is N - 1, addItemNtimes(Name, N1).

addEquipmentNtimes(_, 0) :- !.
addEquipmentNtimes(Name, N) :- 
    addEquipment(Name), N1 is N - 1, addEquipmentNtimes(Name, N1).

delItemNtimes(_, 0) :- !.
delItemNtimes(Name, N) :- 
    delItem(Name), N1 is N - 1, delItemNtimes(Name, N1).

delEquipmentNtimes(_, 0) :- !.
delEquipmentNtimes(Name, N) :- 
    delEquipment(Name), N1 is N - 1, delEquipmentNtimes(Name, N1).

throwItemitem(Name) :- 
    player_invitem(Name,Qty),
    write("How many "), write(Name), write(" do you want to throw?"),
    read(X), nl,
    (X > Qty -> write('You don`t have enough '), write(Name), write(', canceling...'), nl ;
    delItemNtimes(Name,X)).

throwItemequipment(Name) :- 
    player_invequipment(Name,Qty),
    write("How many "), write(Name), write(" do you want to throw?"),
    read(X), nl,
    (X > Qty -> write('You don`t have enough '), write(Name), write(', canceling...'), nl ;
    delEquipmentNtimes(Name,X)).

throwItem :- 
    inventory, nl,
    write('What do you want to throw?'), nl,
    read('Name'), nl,
    (player_invitem(Name,_) -> throwItemitem(Name) ; 
    player_invequipment(Name,_) -> throwItemequipment(Name) ;
    \+(player_invitem(Name,_), player_invequipment(Name,_)) -> write('Item not in inventory, canceling.....')).

tesread :-
    read(X),
    write(X).


/* addEquipment('Rusty Shovel').
addEquipment('Iron Shovel').
addItem('Egg').
addItem('Crab').
addEquipmentNtimes('Rusty Shovel',7).
addItemNtimes('Egg',8).
addEquipmentNtimes('Iron Shovel',3).
addItemNtimes('Crab',5).
*/

