:- dynamic(animal/3). % name, quantity, dayleft
% :- dynamic(ranch_item/2). % name, quantity

% animal_list([cow, sheep, chicken]).
animal_output(cow, 'Milk').
animal_output(sheep, 'Wool').
animal_output(chicken, 'Egg').
upperLimitNormalXPRanch(11).
upperLimitRancherXPRanch(21).

isOnRanchBuilding :-
  player_position(X,Y),
  map_object('R',X,Y).

updateDayLeft :-
  forall(animal(Name,Qty,Dayleft),(
    retract(animal(Name,Qty,Dayleft)),
    Dayleft = 0,assertz(animal(Name,Qty,0)),!
    ;
    NewDayLeft is Dayleft - 1,
    assertz(animal(Name,Qty,NewDayLeft))
  )).

hasAnimal :-
  animal(_,_,_),!.

displayAnimal :-
  forall(animal(Name, Quantity, DayLeft),
    (write(Quantity), write(' '), write(Name), nl)
  ).

init_ranch :-
  assertz(animal(cow, 10, 3)),
  assertz(animal(sheep, 4, 5)),
  assertz(animal(chicken, 1, 6)).

ranch :-
  isOnRanchBuilding,
  (
    (
      state(ranch)
      ;assertz(state(ranch))
    ),
    write('Welcome to the ranch! You have:'),nl,nl,
    (
      hasAnimal,
      displayAnimal,nl
      ;
      write('You have no animals, you need to buy animal first'),nl,nl
    ),
    write('What do you want to do?'),nl
  ),!;
  write('You are not in ranch building').

animal_dont_give_output_msg(X) :-
  write('Your '), write(X), write(' hasn\'t produced any '),
  animal_output(X,Y), write(Y), write('.'),nl,
  write('Please check again later.').

resetDayLeft(Animal) :-
  retract(animal(Animal,Qty,DayLeft)),
  (
    Max is Qty+1,
    player_lvl(Ltot,Lfish,Lfarm,Lranch),
    Limit is Max // Lranch,
    random(1,Limit,Res)
    ,!;
    Res is 1
  ),
  assertz(animal(Animal,Qty,Res)).

addToRanchItem(Animal,Qty) :-
  animal_output(Animal, Output),
  sinonim(Output,LowerCaseOutput),
  Max is Qty + 1,
  random(1,Max,Res),
  addItemNtimes(Output,Res),
  write('You got '), write(Res), write(' '),
  write(LowerCaseOutput), write('!'),nl,
  resetDayLeft(Animal).

isPlayerRancher :-
  player_job('Rancher').

addRanchXP :-
  (
    isPlayerRancher, 
    upperLimitRancherXPRanch(Limit), 
    random(1,Limit,X)
    ,!;
    upperLimitNormalXPRanch(Limit1), 
    random(1,Limit1,X)
  ),
  add_xp(0,0,X),
  write('You gained '),
  write(X),
  write(' ranching exp!'),nl.

exploit_animal(Animal) :-
  state(X),
  X = ranch,
  (
    animal(Animal,Qty,Dayleft),
    (
      Dayleft = 0,
      addToRanchItem(Animal,Qty),
      addRanchXP
      ,!;
      animal_dont_give_output_msg(Animal)
    );
    write('You don\'t have any '), write(Animal), write('.'),nl
  ),!;
  write('You are not in ranch state'),nl. 

chicken :-
  exploit_animal(chicken). 
  
cow :-
  exploit_animal(cow).

sheep :-
  exploit_animal(sheep).

addAnimal(Animal) :-
  (
    retract(animal(Animal,Qty,Dayleft)),
    (
      NewQty is Qty + 1,
      assertz(animal(Animal,NewQty,Dayleft))
    )
    ,!;
    random(1,10,X),
    assertz(animal(Animal,1,X))
  ).

exitRanch :-
  retract(state(ranch)),
  write('You go outside the ranch.'), nl.