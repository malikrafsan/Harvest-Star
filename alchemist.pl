:- dynamic(alchemist_date/1).
:- dynamic(potions_qty/2).

potions(1, 'Red Potion', 175, 'Add 150 XP Farming').
potions(2, 'Green Potion', 100, 'Add 50 XP Fishing').
potions(3, 'Blue Potion', 250, 'Add 120 XP Ranching').
potions_exp_add(1, 150, 0, 0).
potions_exp_add(2, 0, 50, 0).
potions_exp_add(3, 0, 0, 120).

initAlchemist :-
    random(6, 12, AcRand),
    NAcRand is mod(AcRand, 30) + 1,
    resetAlchemist,
    restockAlchemist,
    asserta(alchemist_date(NAcRand)).

restockAlchemist :-
    retractall(potions_qty(_, _)),
    asserta(potions_qty(1, 5)),
    asserta(potions_qty(2, 5)),
    asserta(potions_qty(3, 5)).

resetAlchemist :-
    retractall(alchemist_date(_)),
    retractall(potions_qty(_, _)).

printPotions :-
    forall(
        (potions(Id, Name, Price, Desc)),
        (
            potions_qty(Id, Qty),
            write(Id), write('.\t'), write(Name), nl,
            write('\tQty: '), write(Qty), write(' | Price: '), write(Price), write(' Gold / each'), nl,
            write('\t'), write(Desc), nl
        )
    ).

isAlchemistDate :-
    alchemist_date(AcDate),
    world(Date, _, _),
    AcDate == Date.

advAlchemistDate :-
    % Set alchemist date
    isAlchemistDate,
    alchemist_date(AcDate),
    restockAlchemist,
    random(6, 12, AcRand),
    AcDateNew is AcDate + AcRand,
    asserta(alchemist_date(AcDateNew)).

alchemist :-
    isAlchemistDate, isInObject('A'),
    write('Welcome to Alchemist.'), nl,
    write('We sell potions to increase your XP!'), nl,
    write('We restock the potion each day we open.'), nl,
    write('Here\'s potions that you can buy:'), nl,
    printPotions,
    write('What potion did you want to buy?'), nl,
    read(Id),
    (
        potions(Id, _, Price, _), !;
        write('Invalid potion, cancelling order...'), nl, fail
    ),
    (
        potions_qty(Id, Qty), Qty > 0, !;
        write('Potion is out of stock, cancelling order...'), nl, fail
    ),
    write('How many potions did you want to buy?'), nl,
    read(QtyBuy),
    (
        0 < QtyBuy, QtyBuy =< Qty, !;
        write('Invalid quantity, cancelling order...'), nl, fail
    ),
    (
        money(Gold), SubGold is Price * QtyBuy, Gold >= SubGold, !;
        write('Not enough gold, cancelling order...'), nl, fail
    ),
    write('Thanks for your purchase.'), nl,
    sub_money(SubGold),
    retract(potions_qty(Id, Qty)),
    NewQty is Qty - QtyBuy,
    asserta(potions_qty(Id, NewQty)),
    potions_exp_add(Id, XPFarming, XPFishing, XPRanching),
    NXPH is XPFarming * QtyBuy,
    NXPF is XPFishing * QtyBuy,
    NXPR is XPRanching * QtyBuy,
    add_xp(NXPF, NXPH, NXPR).

alchemist :-
    isAlchemistDate, !,
    write('You\'re not in Alchemist \'A\' location'), nl;
    write('Alchemist is not available'), nl.
