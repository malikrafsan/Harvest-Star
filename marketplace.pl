marketListing('Spring', 'Carrot Seeds').
marketListing('Spring', 'Potato Seeds').
marketListing('Spring', 'Wheat Seeds').
marketListing('Summer', 'Tomato Seeds').
marketListing('Summer', 'Potato Seeds').
marketListing('Summer', 'Wheat Seeds').
marketListing('Fall', 'Wheat Seeds').
marketListing('Fall', 'Tomato Seeds').
marketListing('Fall', 'Carrot Seeds').
marketListing('Winter', 'Potato Seeds').

market :-
  (isInObject('M'),(retract(state(outside)),
  asserta(state(inMarket)); 
  state(inMarket)),
  write('You entered the market.\n'),
  write('What do you want to do?\n'),
  write('1. Buy\n'),
  write('2. Sell\n'),
  write('3. Exit\n'),!;
  write('You can\'t go to market now'),!).

listingEquipment :-
  forall(
    (player_inv(Name,_), equipment(Name, Lvl, Type,_)),
    (Lvl1 is Lvl  + 1,
     equipment(Name1, Lvl1, Type, Price1),
     write('- '), write(Name1), write(' ('), write(Price1), write(') '), nl)
  ).

listingMarket(Season) :-
  forall(
    marketListing(Season, Item2),
    (item(Item2, 'Seeds', Price2), write('- '), write(Item2), write(' ('),write(Price2), write(')'), nl)
  ).

listingAnimal :-
  forall(
    (item(Animal,'Animal',Price)),
    (
      write('- '), write(Animal), write(' ('), write(Price), write(')'),nl
    )
  ).

buy :-
  (
    (
      retract(state(inMarket)), asserta(state(isBuying)),!;
      state(isBuying)
    ),
    write('What do you want to buy?'), nl,
    world(_,Season,_),
    listingMarket(Season),
    listingAnimal,
    listingEquipment,
    write('Type item or \'cancel\' to cancel: '), nl,
    read_string(Inp), money(NowMoney),
    (
      (
        item(Inp, 'Animal', Price), Qty is 1, Lvl is -1,!;
        marketListing(Season, Inp), item(Inp, 'Seeds', Price),Lvl is -1,
        write('How Much? (Your money: '), write(NowMoney), write(')'), nl, read(Qty), !;
        equipment(Inp, Lvl, Type, Price), OldLvl is Lvl - 1, equipment(Old, OldLvl, Type, _),
        player_inv(Old, _), Qty is 1
      ),
      % Check uang
      (
        TotPrice is Qty * Price, NowMoney >= TotPrice,
        (
          Lvl > 0, delItem(Old),!; true  
        ),
        write(Qty), write(' '), write(Inp), write(' has been bought for: '), write(TotPrice),nl,
        sub_money(TotPrice), 
        (
          item(Inp, 'Animal', Price), addAnimal(Inp),!;
          addItemNtimes(Inp, Qty)
        ),!;
        write('You don\'t have enough money.'), nl
      ),!;
      Inp == 'cancel', write('Canceled'),nl,!;
      write('Invalid input.'),nl
    ),
    retract(state(isBuying)), asserta(state(inMarket)),!;
    write('You can\'t buy right now'), nl
  ).

listingInventory :-
  forall(
    player_inv(Name, Qty),
    (
      item(Name, _, Price) -> write(Qty), write(' '), write(Name), write(' ['), write(Price), write(']'), nl
    )
  ).

sell :-
  (
    (
      retract(state(inMarket)),asserta(state(isSelling)),!;
      state(isSelling)
    ),
    write('What do you want to sell?'), nl,
    listingInventory,
    write('Type item name or \'cancel\' to cancel: '), nl,
    read_string(Name),
    (
      (
        player_inv(Name, Qty), item(Name, _, Price),
        write('How Much?'), nl, read(X),
        (
          X =< Qty, TotPrice is Qty * Price, delItemNtimes(Name, X), add_money(TotPrice),!;
          write('You don\'t have that many.'),nl
        )
      ),!;
      Name == 'cancel', write('Canceled'),nl,!;
      write('Invalid input.')
    ),
    retract(state(isBuying)), asserta(state(inMarket)),!;
    write('You can\'t sell right now'),nl
  ).