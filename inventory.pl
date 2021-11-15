:- dynamic(player_invequipment/2).    /* (EquipmentName, Qty) */
:- dynamic(player_invitem/2).    /* (ItemName, Qty) */

/* Facts, items dapat berupa items ataupun equipment sesuai spek */
/* REVISI DARI PDF DISKUSI, INI AGAK LUMAYAN BEDA BANGET SOALNYA LIST OF ITEMS SULIT */
/* Untuk usable items, bentuknya  item(name, type, price) */
/* Untuk equipment, bentuknya equipment(name, level, type, price) */

equipment('Rusty Shovel', 1, 'Harvest', 0).
equipment('Iron Shovel', 2, 'Harvest', 500).
equipment('Steel Shovel', 3, 'Harvest', 1000).
equipment('Training Fishing Rod', 1, 'Fish', 0).
equipment('Quality Fishing Rod', 2, 'Fish', 500).
equipment('Pro Fishing Rod', 3, 'Fish', 1000).

item('Carrot', 'Harvest', 100).
item('Wheat', 'Harvest', 100).
item('Potato', 'Harvest', 150).
item('Tomato', 'Harvest', 200).
item('Snapper', 'Fish', 150).
item('Catfish', 'Fish', 200).
item('Crab', 'Fish', 200).
item('Egg', 'Livestock', 100).
item('Milk', 'Livestock', 200).
item('Wool', 'Livestock', 150).

/* Count the amount of a spesific item or equipment in inventory */
itemQuantity(Name, Qtot) :-
    findall(Qty, player_invitem(Name, Qty), List),
	sum_list(List,Qtot).

equipmentQuantity(Name, Qtot) :-
    findall(Qty, player_invequipment(Name, Qty), List),
	sum_list(List,Qtot).

/* To print all the items in inventory */
inventoryequipment :-
    forall(player_invequipment(Name,Qty),(write(Qty), equipment(Name,Level,_,_),write(' Level '), write(Level), write(' '), write(Name), nl)).

inventoryitem :-
    forall(player_invitem(Name,Qty),(write(Qty), write(' '),  write(Name), nl)).

inventory :-
    itemQuantity(_, Qty),
    equipmentQuantity(_, Qty1),
    Qtot is Qty + Qty1,
    nl,write('Your inventory ('), write(Qtot), write('/100)'), nl,
    inventoryequipment,
    inventoryitem.

/* To add item or equipment to the inventory*/
addItem(_) :- /* Inventory is full! */
    itemQuantity(_, Qty),
    equipmentQuantity(_, Qty1),
    (Qty + Qty1 >= 100),
    write('Inventory is full!'), nl, !, fail.

addItem(Name) :- /* item not in inventory, make 1 */
    item(Name, _, _),
    \+player_invitem(Name,_),
    asserta(player_invitem(Name,1)),!.

addItem(Name) :- /* item already in inventory, add 1 */
    player_invitem(Name, Qty),
    Qty1 is Qty + 1,
    retract(player_invitem(Name,Qty)),
    asserta(player_invitem(Name,Qty1)), !.

addEquipment(_) :- /* Inventory is full! */
    itemQuantity(_, Qty),
    equipmentQuantity(_, Qty1),
    (Qty + Qty1 >= 100),
    write('Inventory is full!'), nl, !, fail.

addEquipment(Name) :- /* Equipment not in inventory, make 1 */
    equipment(Name, _, _,_),
    \+player_invequipment(Name,_),
    asserta(player_invequipment(Name,1)),!.

addEquipment(Name) :- /* Equipment already in inventory, add 1 */
    player_invequipment(Name, Qty),
    Qty1 is Qty + 1,
    retract(player_invequipment(Name,Qty)),
    asserta(player_invequipment(Name,Qty1)), !.

/* Delete an item or equipment from the inventory */
/* BELUM KELAR */

/*delItemInv(Item) :-
    \+itemInv(Item,_), !, fail.

delItemInv(Item) :-
    itemInv(Item,X),
    X =:= 1,
    retract(itemInv(Item,X)), !.

delItemInv(Item) :-
    itemInv(Item,X),
    Y is X - 1,
    retract(itemInv(Item,X)),
    asserta(itemInv(Item,Y)), !.*/

/* addEquipment('Rusty Shovel').
addEquipment('Iron Shovel').
addItem('Egg').
addItem('Crab').
*/

/*  write(Qty), write(' Level '),
    equipment(Name,Level,_,_),
    write(Level), write(' '), write(Name), nl. */

