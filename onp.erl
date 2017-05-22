%%%-------------------------------------------------------------------
%%% @author Joanna
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 24. mar 2017 08:52
%%%-------------------------------------------------------------------
-module(onp).
-author("Joanna").

%% API
-export([onp/1]).

onp(Wyrazenie) ->
  Sparsowane = string:tokens(Wyrazenie," "), %czemu tutaj z ; nie działało??
  policz(Sparsowane,[]).


policz([],[H|T]) -> H; %zdejmowanie wyniku ze stosu
policz(["+"|Reszta],[A,B|T]) -> policz(Reszta,[A + B| T]);
policz(["-"|Reszta],[A,B|T]) -> policz(Reszta,[A - B| T]);
policz(["*"|Reszta],[A,B|T]) -> policz(Reszta,[A * B| T]);
policz(["/"|Reszta],[A,B|T]) -> policz(Reszta,[B/A| T]);
policz(["sqrt" | Reszta],[A | T]) -> policz(Reszta, [math:sqrt(A)| T] );
policz(["pow" | Reszta],[Wykladnik, Podstawa | T]) -> policz(Reszta, [math:pow(Podstawa,Wykladnik)| T] );
policz(["sin" | Reszta],[A | T]) -> policz(Reszta, [math:sin(A)| T] );
policz(["cos" | Reszta],[A | T]) -> policz(Reszta, [math:cos(A)| T] );
policz(["tan" | Reszta],[A | T]) -> policz(Reszta, [math:tan(A)| T] );
policz(["ctan" | Reszta],[A | T]) -> policz(Reszta, [1/math:tan(A)| T] );
policz([Liczba | Reszta], Stos) ->
  case (string:rchr(Liczba,$.) > 0) of
    true -> policz (Reszta, [list_to_float(Liczba)|Stos]);
    false-> policz (Reszta, [list_to_integer(Liczba)|Stos])
  end.
