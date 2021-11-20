:- dynamic(animal/3). % name, quantity, dayleft
:- dynamic(ranch_item/2). % name, quantity
:- dynamic(state/1).

animal_list([cow, sheep, chicken, goat]).
animal_output(cow, milk).
animal_output(sheep, wool).
animal_output(chicken, egg).
animal_output(goat, meat).

% TODO: delete this later
map_object(0,0,'R').
player_position(0,0).

isOnRanchBuilding :-
  player_position(X,Y),
  map_object(X,Y,'R'). 

updateDayLeft :-
  forall(animal(Name,Qty,Dayleft),(
    retract(animal(Name,Qty,Dayleft)),
    Dayleft = 0,assertz(animal(Name,Qty,0)),!
    ;
    NewDayLeft is Dayleft - 1,
    assertz(animal(Name,Qty,NewDayLeft))
  )).

displayAnimal :-
  forall(animal(Name, Quantity, DayLeft),
    (write(Quantity), write(' '), write(Name), nl)
  ).

init_ranch :-
  assertz(animal(cow, 10, 3)),
  assertz(animal(sheep, 4, 5)),
  assertz(animal(chicken, 1, 6)),
  assertz(state(idle)).

ranch :-
  retract(state(_)),
  assertz(state(ranch)),
  isOnRanchBuilding,
  write('Welcome to the ranch! You have:'),nl,
  displayAnimal,
  nl,
  write('What do you want to do?'),nl,!
  ;
  write('You are not in ranch building').

animal_dont_give_output_msg(X) :-
  write('Your '), write(X), write(' hasn\'t produced any '),
  animal_output(X,Y), write(Y), write('.'),nl,
  write('Please check again later.').

resetDayLeft(Animal) :-
  retract(animal(Animal,Qty,DayLeft)),
  Max is Qty+1,
  random(1,Max,Res),
  assertz(animal(Animal,Qty,Res)).

addToRanchItem(Animal,Qty) :-
  animal_output(Animal, Output),
  Max is Qty + 1,
  random(1,Max,Res),
  assertz(ranch_item(Output,Res)),
  write('You got '), write(Res), write(' '),
  write(Output), write('!'),
  resetDayLeft(Animal).

exploit_animal(Animal) :-
  state(X),
  X = ranch,
  (
    animal(Animal,Qty,Dayleft),
    (Dayleft = 0,
    addToRanchItem(Animal,Qty),!
    ;
    animal_dont_give_output_msg(Animal))
  ),!;(
    write('You are not in ranch state'),nl
  ). 

chicken :-
  exploit_animal(chicken). 
  
cow :-
  exploit_animal(cow).

sheep :-
  exploit_animal(sheep).

goat :-
  exploit_animal(goat).
