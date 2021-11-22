:- dynamic(state/1).  /* State Machine */

/* Facts */
:- include('items.pl').
/* Systems and Dynamics */
:- include('player.pl').
:- include('map.pl').
:- include('inventoryver2.pl').
:- include('world.pl').
/* Gameplay */
:- include('exploration.pl').
:- include('quest.pl').
:- include('fishing.pl').
:- include('marketplace.pl').
:- include('house.pl').

writeOpening :-
    write('  _   _                           _   '), nl,
    write(' | | | | __ _ _ ____   _____  ___| |_ '), nl,
    write(' | |_| |/ _` | `__\\ \\ / / _ \\/ __| __|'), nl,
    write(' |  _  | (_| | |   \\ V /  __/\\__ \\ |_ '), nl,
    write(' |_| |_|\\__,_|_|    \\_/ \\___||___/\\__|'), nl, nl,
    write('Harvest Star!!!'), nl, nl,
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
    writeOpening, nl,
    help.

start :- 
    resetAll,
    initAll.

initAll :-
    initPlayer,
    initMap.

resetAll :- /* ini tolong rectract in semua wkwkkw takut ada yang kelewatan */
    resetPlayer,
    resetQuest.
