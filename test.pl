% Testcode voor Fasen 2 en 3.
%
% searchTree zal werken met Fase 2 code. Voor getPath heb je Fase 3 code
% nodig. Uiteraard moet met Fase 3 code searchTree nog steeds werken.
%
% Veel debugplezier!
% Felix

% searchTree probeert de elementen uit de boom te unificeren met het gegeven
% element. Werkt enkel met nonvar gezochte element. Als het element var is,
% zal het dit unificeren met het eerste element uit de wortelkinderen.

% ?- [test].
% ?- [cps2].
% ?- eval(searchTree([1,2,3,4,[5,6,7],[[8],9]], 8)).
% true.
%
% ?- eval(searchTree([1,2,3,4,[5,6,7],[[8],9]], 10)).
% false.
%
% ?- eval(searchTree([1,2,3,4,[5,X,7],[[Y],9]], 10)).
% X = 10.
%

searchTree(Tree, Value) :-
    mark(searchTree_(Tree, Value)).
searchTree_([Value|_], Value) :-
    unwind.
searchTree_([Tree|Rest], Value) :-
    searchTree_(Tree, Value);
    searchTree_(Rest, Value).

% getPath weergeeft de relatie tussen een boom, een element uit die boom,
% en het path naar die boom. Merk op dat de paden van achter naar voor
% gelezen moeten worden om het element terug te vinden. Dit kan echter
% eenvoudig omgekeerd worden voor wie wil.

% ?- [test].
% ?- [cps3].
% ?- eval(getPath([1,2,3,4,[5,6,7],[[8],9]], 8, P)).
% P = [0, 0, 5].
%
% ?- eval(getPath([1,2,3,4,[5,6,7],[[8],9]], 10, P)).
% false.
%
% ?- eval(getPath([1,2,3,4,[5,6,7],[[8],9]], X, [0,0,5])).
% X = 8.
%
% ?- eval(getPath([1,2,3,4,[5,6,7],[[X],9]], 10, P)).
% X = 10,
% P = [0, 0, 5].
%

getPath(Tree, Value, Path) :-
    handle(getPath_(Tree, Value, 0, []), Path).

getPath_([Value|_], Value, Index, Path) :-
    raise([Index|Path]).
getPath_([Tree|Rest], Value, Index, Path) :-
    getPath_(Tree, Value, 0, [Index|Path]);
    (Index_ is Index + 1, 
     getPath_(Rest, Value, Index_, Path)).

