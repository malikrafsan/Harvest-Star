/* Helper Function */
:- include('helper.pl').
/* Facts */
:- include('items.pl').
/* Systems and Dynamics */
:- include('player.pl').
:- include('map.pl').
:- include('inventory.pl').
:- include('world.pl').
:- include('list_diary.pl').
:- include('saves.pl').
/* Gameplay */
:- include('exploration.pl').
:- include('quest.pl').
:- include('fishing.pl').
:- include('farming.pl').
:- include('ranching.pl').
:- include('marketplace.pl').
:- include('house.pl').
:- include('alchemist.pl').
:- include('fairy.pl').

writeOpening :-
    write('  _   _                           _   '), nl,
    write(' | | | | __ _ _ ____   _____  ___| |_ '), nl,
    write(' | |_| |/ _` | `__\\ \\ / / _ \\/ __| __|'), nl,
    write(' |  _  | (_| | |   \\ V /  __/\\__ \\ |_ '), nl,
    write(' |_| |_|\\__,_|_|    \\_/ \\___||___/\\__|'), nl, nl,
    sleep(0.9),
    write('Harvest Star!!!'), nl, nl,
    sleep(0.9),
    write('Lets play and pay our debts together!'), nl.

help :- 
    write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'),nl,
    write('%                              ~Harvest Star~                                  %'),nl,
    write('% 1. start  : untuk memulai petualanganmu                                      %'),nl,
    write('% 2. map    : menampilkan peta                                                 %'),nl,
    write('% 3. status : menampilkan kondisimu terkini                                    %'),nl,
    write('% 4. w      : gerak ke utara 1 langkah                                         %'),nl,
    write('% 5. s      : gerak ke selatan 1 langkah                                       %'),nl,
    write('% 6. d      : gerak ke ke timur 1 langkah                                      %'),nl,
    write('% 7. a      : gerak ke barat 1 langkah                                         %'),nl,
    write('% 8. help   : menampilkan segala bantuan                                       %'),nl,
    write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'),nl.

startGame :- 
    sleep(0.5),
    writeOpening, nl, sleep(1),
    help.

start :- 
    \+ player_job(_), !, (
        resetAll,
        initAll
    ) ; (
        write('Game has already started!'), nl , write('Please quitGame first if you want to start the game over.')
    ).

quitGame :-
    player_job(_), !, (
        write('Are you sure you want to quit the game?') ,nl,
        write('Your progress will be lost. (yes/no)'),nl,
        read(Quitgame), Quitgame == 'yes', !, (
                write('Succesfully exited the game.'), nl,
                resetAll
            ) ; (
                true
            )
        ) ; (
            write('Game has not started')
    ).


isGameStarted :-
    \+ player_job(_), !,
    write('Harvest Star is not started yet.'), nl,
    write('Please start the game first.'), nl, fail
    ; true.

initAll :-
    initPlayer,
    initMap,
    initAlchemist,
    initWorld. 

resetAll :- /* ini tolong rectract in semua wkwkkw takut ada yang kelewatan */
    resetPlayer,
    resetMap,
    resetQuest,
    resetAlchemist,
    resetWorld,
    resetRanch.


exit :-
  isGameStarted,
  \+ state(outside),
  retract(state(_)),
  asserta(state(outside)),
  write('You go outside.'),nl.


clean_save :-
  open('list_diary.pl', write,X),
  close(X).