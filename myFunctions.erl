%%%-------------------------------------------------------------------
%%% @author Joanna
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 14. mar 2017 10:13
%%%-------------------------------------------------------------------
-module(myFunctions).
-author("Joanna").

%% API
-export([power/2, contains/2, duplicateElements/1, duplicateElements2/1, divisibleBy/2, toBinary/1]).

power(A,1) -> A;
power(A,N) -> A * power(A,N-1).


contains([],B)-> false;
contains([B | T],B)-> true;
contains([H | T],B) -> contains(T,B).

% z ++, kopiuje w innej kolejnosci
duplicateElements([]) -> [];
duplicateElements(H) -> H ++ H ;
duplicateElements([H|T]) -> H ++ duplicateElements(T).

duplicateElements2([]) -> [];
duplicateElements2([H]) -> [H | H] ;
duplicateElements2([H|T]) -> [ H , H | duplicateElements(T)].


divisibleBy([],D) -> [];
divisibleBy([H|T], D) ->
  if
    (H rem D == 0)  ->  [H | divisibleBy(T,D)];
    true -> divisibleBy(T,D)
  end.
%wybiera tylko liczby podzielne przez dana liste

toBinary(B) ->lists:reverse([N - $0 || N <- integer_to_list(B, 2)]).

%divisibleBy2([],liczba)->[];
%divisibleBy2([H|T],liczba)->
 % ( H rem liczba)
  %  0 -> [H | divisibleBy(T,D)];
   % _ ->    divisibleBy(T,D).


% zwraca liczbę w postaci binarnej (jako liste)
%todo jak ją naprawić?
%toBinary2(0,[result]) -> result;
%toBinary2(number, [result])-> toBinary2(number/2, result ++ [number rem 2]).

%todo zadanie dokończ zadanka bez if-ów i caseów!! (if'a sie nie uzywa nigdy, case'a tylko czasami)
%wzorce moga byc
%nazywać zmienne lepiej

%todo kalkulator odwrotnej notacji polskiej
%ok 3-4 linijki do zaladowania i po 2 linijki na kazdy operator

