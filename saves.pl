saveall :-
    /* Single predicates */
    diary(TotDate, Sentences),
    write('diary('), write(TotDate), write(',\''),write(Sentences), write('\').'), nl,
    player_position(X1,Y1),
    write(player_position(X1,Y1)), write('.'), nl,
    player_lvl(Leveltotal, Level1, Level2, Level3),
    write(player_lvl(Leveltotal, Level1, Level2, Level3)),write('.'), nl,
    player_xp(Xptotal, Xp1, Xp2, Xp3),
    write(player_xp(Xptotal, Xp1, Xp2, Xp3)),write('.'), nl,
    player_job(Job),
    write('player_job(\''),write(Job),write('\').'), nl,
    money(Gold),
    write(money(Gold)),write('.'), nl,
    state(State),
    write(state(State)),write('.'),nl,
    world(Date, Season, Weather),
    write('world('), write(Date), write(',\''), write(Season), write('\',\''), write(Weather), write('\').'), nl,
    time(Time),
    write(time(Time)),write('.'),nl,
    alchemist_date(AD),
    write(alchemist_date(AD)),write('.'),nl,
    
    /* Special Check */
    (
      quest_ongoing(Aa,Bb,Cc),
      write(quest_ongoing(Aa,Bb,Cc)), write('.'),nl,!;
      true
    ),
    (
      quest_completion(Aaa, Bbb, Ccc),
      write(quest_completion(Aaa, Bbb, Ccc)), write('.'),nl,!;
      true
    ),


    /* Multi dynamic predicates */
    (
      forall(
        potions_qty(NoPot, PotQty),
        (
          write(potions_qty(NoPot, PotQty)), write('.'), nl
        )
      )
    ),
    (
      forall(
        animal(Animal, ANQTY, ANState),
        (
          write('animal(\''), write(Animal), write('\','), write(ANQTY), write(','), write(ANState), write(').'), nl
        )
      )
    ),
    (
      forall(
        map_harvest(Symbol, X, Y, T),
        (
          write('map_harvest(\''), write(Symbol), write('\','), write(X), write(','), write(Y), write(','), write(T), write(').'),nl
        )
      ),!;
      true
    ),
    (
      forall(player_inv(Name,Qty),(write('player_inv(\''),write(Name),write('\','),write(Qty), write(').'), nl)),!;
      true
    ).
