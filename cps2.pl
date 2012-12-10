
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


% --------------------------------------------------------------------------- %
% Meta interpreter.                                                           %
% --------------------------------------------------------------------------- %


eval(G) :-
    (
        eval(G, [], true),
        !
    ;
        eval(G, [], unwind),
        writeln('ERROR: uncaught \'unwind\''),
        false
    ).
        

eval((G1, G2), Conts, X) :- !,
    eval(G1, [G2|Conts], X).

% 1     =/2
eval(X = Y, Conts, _) :- !,
    X = Y,
    continue(Conts).

% 2     is/1
eval(X is Y, Conts, _) :- !,
    X is Y,
    continue(Conts).

% 3     (;)/2
eval((G1; G2), Conts, _) :- !,
    (eval(G1, Conts, true); eval(G2, Conts, true)).

% 4     >/2
eval(X > Y, Conts, _) :- !,
    X > Y,
    continue(Conts).

% 5     writeln/1
eval(writeln(X), Conts, _) :- !,
    writeln(X),
    continue(Conts).

% 6     read/1
eval(read(X), Conts, _) :- !,
    read(X),
    continue(Conts).

% 7     call/1
eval(call(X), Conts, _) :- !,
    call(X),
    continue(Conts).

% 8     functor/3
eval(functor(X, Y, Z), Conts, _) :- !,
    functor(X, Y, Z),
    continue(Conts).

% 9     arg/3
eval(arg(X, Y, Z), Conts, _) :- !,
    arg(X, Y, Z),
    continue(Conts).

% 10    =../2
eval(X =.. Y, Conts, _) :- !,
    X =.. Y,
    continue(Conts).

% end/0
eval(end, _, true) :- !,
    true.

% mark/1
eval(mark(G), Conts, _) :- !,
    (
        eval(G, _, unwind),
        !
    ; 
        eval(G, [], true)
    ),
    continue(Conts).

% unwind/0
eval(unwind, _, unwind) :- !,
    true.

eval(true, Conts, _) :- !,
    continue(Conts).

eval(G, Conts, _) :- !,
    clause(G, NG),
    eval(NG, Conts, _).

eval(_, _, false).

continue([]).
continue([G|Conts]) :-
    eval(G, Conts, _).

