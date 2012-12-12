%

main :-
    loop(work).

loop(G) :-
    call(G),
    loop(G).

work :-
    read(Number),
    work_(Number).

work_(0) :-
    writeln('I’ve seen enough'),
    end.

work_(N) :-
    N > 0,
    writeln('That’s a nice number.').

%

eval_main :-
    eval_loop_work([]).

eval_loop_work(Conts) :-
    eval_read(Number, [work_(Number), loop(work)|Conts]).

eval_read(Number, Conts) :-
    read(Number),
    continue(Conts).

eval_work_(0, Conts) :-
    writeln('I\'ve seen enough'),
    continue([end|Conts]).

eval_work_(N, Conts) :-
    N > 0,
    continue([writeln('That\'s a nice number.')|Conts]).

eval_writeln(X, Conts) :-
    writeln(X),
    continue(Conts).

continue([]).
continue([end|_]).
continue([work_(Number)|Conts]) :-
    eval_work_(Number, Conts).
continue([loop(work)|Conts]) :-
    eval_loop_work(Conts).
continue([writeln(X)|Conts]) :-
    eval_writeln(X, Conts).
