
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

% --------------------------------------------------------------------------- %
% Meta interpreter.                                                           %
% --------------------------------------------------------------------------- %


eval(G) :-
    eval(G, []).

eval((G1, G2), Conts) :- !,
    eval(G1,[G2|Conts]).

% 1     =/2
eval(X = Y, Conts) :- !,
    X = Y,
    continue(Conts).

% 2     is/1
eval(X is Y, Conts) :- !,
    X is Y,
    continue(Conts).

% 3     (;)/2
eval((G1; G2), Conts) :- !,
    (eval(G1, Conts); eval(G2, Conts)).

% 4     >/2
eval(X > Y, Conts) :- !,
    X > Y,
    continue(Conts).

% 5     writeln/1
eval(writeln(X), Conts) :- !,
    writeln(X),
    continue(Conts).

% 6     read/1
eval(read(X), Conts) :- !,
    read(X),
    continue(Conts).

% 7     call/1
eval(call(X), Conts) :- !,
    call(X),
    continue(Conts).

% 8     functor/3
eval(functor(X, Y, Z), Conts) :- !,
    functor(X, Y, Z),
    continue(Conts).

% 9     arg/3
eval(arg(X, Y, Z), Conts) :- !,
    arg(X, Y, Z),
    continue(Conts).

% 10    =../2
eval(X =.. Y, Conts) :- !,
    X =.. Y,
    continue(Conts).

% end/0 instruction
eval(end, _) :- !,
    true.

eval(true, Conts) :- !,
    continue(Conts).

eval(G, Conts) :-
    clause(G, NG),
    eval(NG, Conts).

continue([]).
continue([G|Conts]) :-
    eval(G, Conts).

