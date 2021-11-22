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
  % TODO: Cek posisi di market
  ((retract(state(outside)),
  asserta(state(inMarket)); 
  state(inMarket)),
  write('You entered the market.\n'),
  write('What do you want to do?\n'),
  write('1. Buy\n'),
  write('2. Sell\n'),!;
  write('You can\'t go to market now'),!).

buy :-
  ((retract(state(inMarket)), asserta(state(isBuying)),!;
      state(isBuying)),
    write('What do you want to buy?\n'),
    world(_,Season,_),
    forall(
      (player_inv(Name, _), equipment(Name, Lvl,Type,_)), 
      (Lvl1 is Lvl + 1, 
       equipment(Name1, Lvl1, Type,Price1),
       write('- '), write(Name1),write(' ('), write(Price1), write(') '), nl)),
    forall(
      marketListing(Season, Item2),
      (item(Item2, 'Seeds', Price2), write('- '), write(Item2),write(' ('), write(Price2), write(')'),nl)),
    write('Type item name or \'cancel\' to cancel: '),nl,
    (read(Inp),money(NowMoney),
     (Inp == cancel,!;
      (marketListing(Season, Inp), item(Inp, 'Seeds', Price), 
       write('How Much? (Your money: '), write(NowMoney), write(')'), nl, read(X),!;
       X is 1,equipment(Inp, Lvl, Type, Price),OldLvl is Lvl - 1, equipment(Old, OldLvl, Type, _),!), 
      TotPrice is Price * X; retract(player_inv(Old, _)),
      (NowMoney >= TotPrice), addItemNtimes(Inp, X),
      write(X), write(' '), write(Inp), write(' has been bought for: '), write(TotPrice), nl,
      sub_money(TotPrice)),
     retract(state(isBuying)),
     asserta(state(inMarket)), !;
     write('Invalid input...'), nl, buy,!),!;
    write('You are not in the market.\n')).

sell :-
  ((retract(state(inMarket)),
  asserta(state(isSelling));state(isSelling)),
  write('What do you want to sell?\n'),
  forall(
    player_inv(Name, Qty), 
    (item(Name, _, Price) -> write(Qty), write(' '), write(Name), write(' ['), TotPrice is Price * Qty, write(TotPrice), write('] Gold'),nl )),
  write('Type item name or \'cancel\' to cancel:'),nl,
  (read(Name1), (Name1 == cancel,!;
  player_inv(Name1, Qty1), item(Name1, _, Price1), 
  write('How much?'), nl,
  read(X), 
  X =< Qty1, delItemNtimes(Name1, X), 
  TotPrice1 is Qty1 * Price1, add_money(TotPrice1),!),
  retract(state(isSelling)),
  asserta(state(inMarket)), !;
  write('Invalid input...'),nl, sell,!),!;
  write('You are not in the market.')).

exit :-
  retract(state(inMarket)),
  asserta(state(outside)),
  write('You go outside the market.'),nl.
