%

eval_fib(N, F) :-
    eval_fib(N, F, []).

eval_fib(N, F, Conts) :-
    N > 1,
    N1 is N - 1,
    eval_fib(N1, F1, [N2 is N1 - 1, fib(N2, F2), F is F1 + F2|Conts]).

eval_fib(0, 1, Conts) :-
    continue(Conts).

eval_fib(1, 1, Conts) :-
    continue(Conts).

eval_is(X, Y, Conts) :-
    X is Y,
    continue(Conts).

clause_fib(N, F, (N > 1, N1 is N - 1, fib(N1, F1), N2 is N1 - 1, fib(N2, F2), F is F1 + F2)).
clause_fib(0, 1, true).
clause_fib(1, 1, true).

continue([]).
continue([(X is Y)|Conts]) :-
    eval_is(X, Y, Conts).
continue([fib(N, F)|Conts]) :-
    eval_fib(N, F, Conts).

