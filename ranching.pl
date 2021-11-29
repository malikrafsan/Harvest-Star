% DYNAMIC VALUE
:- dynamic(animal/3). % name, quantity, dayleft

% COMMANDS
ranch :-
  isGameStarted, (
    % Melakukan command ranch dan sebagai fungsi utama
    isOnRanchBuilding,
    (
      (
        retract(state(_))
        ;write('You don\'t have state, asserting state ranch'),nl
      ),
      assertz(state(ranch)),
      (
        hasAnimal,
        write('Welcome to the ranch! You have:'),nl,nl,
        displayAnimal,nl,
        write('What do you want to do?'),nl
        ;
        nl,write('You have no animals, you need to buy animal first'),nl
      )
    ),!;
    write('You are not in ranch building')
  ).

chicken :-
  exploit_animal('Chicken'). 
  
cow :-
  exploit_animal('Cow').

sheep :-
  exploit_animal('Sheep').

% FACTS AND RULES
animal_output('Cow', 'Milk').
animal_output('Sheep', 'Wool').
animal_output('Chicken', 'Egg').
upperLimitXPRanch(11).

isOnRanchBuilding :-
  % Mengembalikan true jika player berada di building ranch
  player_position(X,Y),
  map_object('R',X,Y).

updateDayLeft :-
  % Mengupdate dayleft animal
  forall(animal(Name,Qty,Dayleft),(
    retract(animal(Name,Qty,Dayleft)),
    Dayleft = 0,assertz(animal(Name,Qty,0)),!
    ;
    NewDayLeft is Dayleft - 1,
    assertz(animal(Name,Qty,NewDayLeft))
  )).

hasAnimal :-
  % Mengembalikan true jika player memiliki hewan
  animal(_,_,_),!.

displayAnimal :-
  % Menampilkan hewan yang dimiliki player
  forall(animal(Name, Quantity, DayLeft),
    (write(Quantity), write(' '), write(Name), write(' with '), write(DayLeft),write(' day left to exploit'),nl)
  ).


animal_dont_give_output_msg(X) :-
  % Menampilkan pesan dimana hewan tidak diberikan output
  write('Your '), write(X), write(' hasn\'t produced any '),
  animal_output(X,Y), write(Y), write('.'),nl,
  write('Please check again later.').

resetDayLeft(Animal) :-
  % Mengisi kembali dayleft animal yang telah diambil output-nya
  retract(animal(Animal,Qty,_)),
  (
    Max is Qty+1,
    player_lvl(_,_,_,Lranch),
    Limit is Max // Lranch,
    random(1,Limit,Res)
    ,!;
    Res is 1
  ),
  assertz(animal(Animal,Qty,Res)).

addToRanchItem(Animal,Qty) :-
  % Menambahkan output hewan ke dalam inventory
  animal_output(Animal, Output),
  sinonim(Output,LowerCaseOutput),
  Max is Qty + 1,
  random(1,Max,Res),
  addItemNtimes(Output,Res),
  write('You got '), write(Res), write(' '),
  write(LowerCaseOutput), write('!'),nl,
  (
    progressQuest(0,0,Res)
    ,!;!
  ),
  resetDayLeft(Animal).

addRanchXP :-
  % Menambahkan XP ranching pada player
  upperLimitXPRanch(Limit), 
  random(1,Limit,X),
  add_xp(0,0,X).

exploit_animal(Animal) :-
  % Mengambil output hewan jika dayleft hewan 0
  state(X),
  X = ranch,
  (
    animal(Animal,Qty,Dayleft),
    (
      Dayleft = 0,
      addToRanchItem(Animal,Qty),
      addRanchXP,
      addTime(10)
      ,!;
      animal_dont_give_output_msg(Animal)
    );
    write('You don\'t have any '), write(Animal), write('.'),nl
  ),!;
  write('You are not in ranch state'),nl. 

addAnimal(Animal) :-
  % Menambahkan hewan ke dalam inventory hewan ranch
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

resetRanch :-
  retractall(animal(_,_,_)).
