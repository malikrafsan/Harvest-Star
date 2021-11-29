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
item('Carrot', 'Harvest', 20).
item('Wheat', 'Harvest', 40).
item('Potato', 'Harvest', 30).
item('Tomato', 'Harvest', 50).
item('Snapper', 'Fish', 30).
item('Catfish', 'Fish', 40).
item('Crab', 'Fish', 50).
item('Tuna', 'Fish', 60).
item('Salmon', 'Fish', 70).
item('Eel', 'Fish', 20).
item('Cow', 'Animal', 1500).
item('Sheep', 'Animal', 1000).
item('Chicken', 'Animal', 500).
item('Egg', 'Livestock', 100).
item('Milk', 'Livestock', 200).
item('Wool', 'Livestock', 150).
item('Potion', _ , 1000).

plural('Rusty Shovel', 'Rusty Shovels').
plural('Iron Shovel', 'Iron Shovels').
plural('Steel Shovel', 'Steel Shovels').
plural('Training Fishing Rod', 'Training Fishing Rods').
plural('Quality Fishing Rod', 'Quality Fishing Rods').
plural('Pro Fishing Rod', 'Pro Fishing Rods').
plural('Carrot', 'Carrots').
plural('Wheat', 'Wheats').
plural('Potato', 'Potatoes').
plural('Tomato', 'Tomatoes').
plural('Snapper', 'Snappers').
plural('Catfish', 'Catfishes').
plural('Crab', 'Crabs').
plural('Tuna','Tunas').
plural('Salmon','Salmons').
plural('Eel','Eels').
plural('Cow', 'Cows').
plural('Sheep', 'Sheeps').
plural('Chicken', 'Chickens').
plural('Egg', 'Eggs').
plural('Milk', 'Milks').
plural('Wool', 'Wools').
plural('Potion', 'Potions').

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
sinonim('Tuna', tuna).
sinonim('Salmon', salmon).
sinonim('Eel', eel).
sinonim('Cow', cow).
sinonim('Sheep', sheep).
sinonim('Chicken', chicken).
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