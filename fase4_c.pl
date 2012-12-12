%

eval_product(L, P) :-
    eval_product(L, P, [], X),
    ( X = true ->
        true
    ; X = unwind ->
        writeln('ERROR: uncaught \'unwind\''),
        false
    ; X = raise(N) ->
        format('ERROR: uncaught \'raise(~w)\'', N),
        false
    ).

eval_product(L, P, Conts, R) :-
    eval_handle_product_(L, P, P, Conts, R).

eval_handle_product_(L, P, X, Conts, true) :-
    (
        eval_product_(L, P, _, raise(X)),
        !
    ;
        eval_product_(L, P, [], true)
    ),
    continue(Conts, _).

eval_product_([], 1, Conts, R) :-
    continue(Conts, true).

eval_product_([X|Xs], P, Conts, R) :-
    X \== 0,
    continue([product_(Xs, P1), P is X * P1|Conts], R).

eval_product_([X|_], _, Conts, R) :-
    X == 0,
    continue([raise(0)|Conts], R).

eval_is(X, Y, Conts, R) :-
    X is Y,
    continue(Conts, R).

continue([], true).
continue([raise(0)|_], raise(0)).
continue([product_(L, P)|Conts], R) :-
    eval_product_(L, P, Conts, R).
continue([X is Y|Conts], R) :-
    eval_is(X, Y, Conts, R).

