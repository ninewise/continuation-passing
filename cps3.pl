
% --------------------------------------------------------------------------- %
% Fibonacci program.                                                          %
% --------------------------------------------------------------------------- %

fib(0, 1).
fib(1, 1).
fib(N, F) :-
    N > 1,
    N1 is N - 1,
    fib(N1, F1),
    N2 is N1 - 1,
    fib(N2, F2),
    F is F1 + F2.

% --------------------------------------------------------------------------- %
% Testing clauses.                                                            %
% --------------------------------------------------------------------------- %

% Fase 1.
p :-
    writeln(start(p)),
    q,
    writeln(end(p)).
q :-
    writeln(start(q)),
    end,
    writeln(end(q)).

% Fase 2.
ex1 :-
    writeln(a),
    mark(ex1_1),
    writeln(d).
ex1_1 :-
    writeln(b),
    unwind,
    writeln(c).
ex2 :-
    writeln(a),
    mark(ex2_1),
    writeln(b).
ex2_1 :-
    writeln(c),
    mark(ex2_2),
    writeln(d).
ex2_2 :-
    writeln(e),
    unwind,
    writeln(f).

% Fase 3
product(L, P) :-
    handle(product_(L, P), P).

product_([], 1).
product_([X|Xs], P) :-
    X \== 0,
    product_(Xs, P1),
    P is X * P1.
product_([X|_], P) :-
    X == 0,
    raise(0).


% --------------------------------------------------------------------------- %
% Meta interpreter.                                                           %
% --------------------------------------------------------------------------- %


eval(G) :-
    eval(G, [], X),
    ( X = true ->
        true
    ; X = unwind ->
        writeln('ERROR: uncaught \'unwind\''),
        false
    ; X = raise(N) ->
        format('ERROR: uncaught \'raise(~w)\'', N),
        false
    ).
        

eval((G1, G2), Conts, X) :- !,
    eval(G1, [G2|Conts], X).

% 1     =/2
eval(X = Y, Conts, R) :- !,
    X = Y,
    continue(Conts, R).

% 2     is/1
eval(X is Y, Conts, R) :- !,
    X is Y,
    continue(Conts, R).

% 3     (;)/2
eval((G1; G2), Conts, _) :- !,
    (eval(G1, Conts, true); eval(G2, Conts, true)).

% 4     >/2
eval(X > Y, Conts, R) :- !,
    X > Y,
    continue(Conts, R).

% 5     writeln/1
eval(writeln(X), Conts, R) :- !,
    writeln(X),
    continue(Conts, R).

% 6     read/1
eval(read(X), Conts, R) :- !,
    read(X),
    continue(Conts, R).

% 7     call/1
eval(call(X), Conts, R) :- !,
    call(X),
    continue(Conts, R).

% 8     functor/3
eval(functor(X, Y, Z), Conts, R) :- !,
    functor(X, Y, Z),
    continue(Conts, R).

% 9     arg/3
eval(arg(X, Y, Z), Conts, R) :- !,
    arg(X, Y, Z),
    continue(Conts, R).

% 10    =../2
eval(X =.. Y, Conts, R) :- !,
    X =.. Y,
    continue(Conts, R).

% 11    \==/2
eval(X \== Y, Conts, R) :- !,
    X \== Y,
    continue(Conts, R).

% 12    ==/2
eval(X == Y, Conts, R) :- !,
    X == Y,
    continue(Conts, R).

% end/0
eval(end, _, true) :- !,
    true.

% mark/1
eval(mark(G), Conts, true) :- !,
    (
        eval(G, _, unwind),
        !
    ; 
        eval(G, [], true)
    ),
    continue(Conts, _).

% unwind/0
eval(unwind, _, unwind) :- !,
    true.

% handle/2
eval(handle(G, X), Conts, true) :- !,
    (
        eval(G, _, raise(X)),
        !
    ;
        eval(G, [], true)
    ),
    continue(Conts, _).

% raise/1
eval(raise(X), _, raise(X)) :- !,
    true.

eval(true, Conts, R) :- !,
    continue(Conts, true).

eval(G, Conts, R) :- !,
    clause(G, NG),
    eval(NG, Conts, R).

eval(_, _, false).

continue([], true).
continue([G|Conts], R) :-
    eval(G, Conts, R).

