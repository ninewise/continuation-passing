

eval(G) :-
    eval(G,[]).

eval((G1,G2),Conts) :- !,
    eval(G1,[G2|Conts]).
eval(true, Conts) :- !,
    continue(Conts).
eval(G,Conts) :-
    clause(G,NG),
eval(NG,Conts).
    continue([]).

continue([G|Conts]) :-
    eval(G,Conts).

