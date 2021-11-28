:- dynamic(quest_ongoing/3). /* misi minimal harvest, fish, ranch, nanti di random generator */
:- dynamic(quest_completion/3). /* current target harvest, fish, ranch, nanti di random generator */

resetQuest :-
    retractall(quest_ongoing(_, _, _)),
    retractall(quest_completion(_,_,_)).

quest :-
    quest_ongoing(Harvest, Fish, Ranch), (
        quest_completion(CH, CF, CR),
        CH >= Harvest, CF >= Fish, CR >= Ranch, !, (
            isInObject('Q'), !, (
                write('Quest completed!'), nl,
                write('You got:'), nl,
                XPHA is Harvest * 60,
                XPFA is Fish * 20,
                XPRA is Ranch * 50,
                MoneyAdd is Harvest * 80 + Fish * 50 + Ranch * 70,
                write('XP Harvest: +'), write(XPHA), nl,
                write('XP Fishing: +'), write(XPFA), nl,
                write('XP Ranch: +'), write(XPRA), nl,
                write('Money: +'), write(MoneyAdd), nl,
                add_xp(XPHA, XPFA, XPRA),
                add_money(MoneyAdd),
                resetQuest
            ) ; (
                write('Your quest is completed. Claim it in building Q.')
            )
        ) ; (
            write('You already have an ongoing quest!'), nl,
            writeQuest
        )
    ), !.
quest :-
    isInObject('Q'),
    player_lvl(LevelTotal, LevelFs, LevelHv, LevelRn),
    HvLimit is 4 + (LevelHv * 3) + LevelTotal,
    FsLimit is 2 + (LevelFs * 5) + LevelTotal,
    RnLimit is 6 + (LevelRn * 2) + LevelTotal,
    random(1, HvLimit, Harvest),
    random(1, FsLimit, Fish),
    random(1, RnLimit, Ranch),
    asserta(quest_ongoing(Harvest, Fish, Ranch)),
    asserta(quest_completion(0, 0, 0)),
    write('You have a new quest!'), nl,
    writeQuest, !.
quest :-
    write('You are not in Quest \'Q\'.'), nl.

writeQuest :-
    quest_ongoing(Harvest, Fish, Ranch),
    quest_completion(CurHarvest, CurFish, CurRanch),
    write('You must collect:'), nl,
    write('- '), write(Harvest), write(' item harvest ['), write(CurHarvest), write(' current]'), nl,
    write('- '), write(Fish), write(' item fishing ['), write(CurFish), write(' current]'), nl,
    write('- '), write(Ranch), write(' item ranch ['), write(CurRanch), write(' current]'), nl.

progressQuest(AddHarvest, AddFish, AddRanch) :-
    quest_completion(CH, CF, CR),
    NH is CH + AddHarvest,
    NF is CF + AddFish,
    NR is CR + AddRanch,
    retractall(quest_completion(_,_,_)),
    asserta(quest_completion(NH, NF, NR)).
