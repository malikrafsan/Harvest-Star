/* Untuk usable items, bentuknya  item(name, type, price) */
/* Untuk equipment, bentuknya equipment(name, level, type, price) */

/* Facts, items dapat berupa item ataupun equipment sesuai spek */

equipment('Rusty Shovel', 1, 'Harvest', 0).
equipment('Iron Shovel', 2, 'Harvest', 500).
equipment('Steel Shovel', 3, 'Harvest', 1000).
equipment('Training Fishing Rod', 1, 'Fish', 0).
equipment('Quality Fishing Rod', 2, 'Fish', 500).
equipment('Pro Fishing Rod', 3, 'Fish', 1000).

item('Carrot Seeds', 'Seeds', 20).
item('Wheat Seeds', 'Seeds', 40).
item('Potato Seeds', 'Seeds', 30).
item('Tomato Seeds', 'Seeds', 50).

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
item('Potion', _ , 1000).

sinonim('Rusty Shovel', rustyshovel).
sinonim('Iron Shovel', ironshovel).
sinonim('Steel Shovel', steelshovel).
sinonim('Training Fishing Rod', trainingfishingrod).
sinonim('Quality Fishing Rod', qualityfishingrod).
sinonim('Pro Fishing Rod', profishingrod).
sinonim('Carrot', carrot).
sinonim('Wheat', wheat).
sinonim('Potato', potato).
sinonim('Tomato', tomato).
sinonim('Snapper', snapper).
sinonim('Catfish', catfish).
sinonim('Crab', crab).
sinonim('Egg', egg).
sinonim('Milk', milk).
sinonim('Wool', wool).
sinonim('Potion', potion).

/* Still dont know the use of each items and equipments tho */

usePotion :-
    \+player_inv('Potion', _),
    write('You dont have enough Potion!') , nl.

usePotion:-
    player_inv('Potion', _),
    write('You have used Potion'), nl,
    delItem('Potion'),
    add_xp(80,80,80), nl.