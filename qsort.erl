%%%-------------------------------------------------------------------
%%% @author Joanna
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 28. mar 2017 07:51
%%%-------------------------------------------------------------------
-module(qsort).
-author("Joanna").

%% API
-export([qs/1, randomElems/3, compareSpeeds/3]).

lessThan(List,Arg) -> [X || X <- List, X < Arg].
grtEqThan(List,Arg) -> [X || X <- List, X >= Arg].

qs([Pivot|Tail]) -> qs( lessThan(Tail,Pivot)) ++ [Pivot] ++ qs(grtEqThan(Tail,Pivot));
qs([]) -> [].

%random niewskazany wtedy kiedy mamy bardzo duzo procesów

%o rozmiarze N
randomElems(N, Min, Max) -> [ random:uniform(Max-Min) + Min|| X <-lists:seq(1,N)].


compareSpeeds(List, Fun1, Fun2) ->
  {Time1, _ } = timer:tc(Fun1, [List]),
  {Time2, _ } = timer:tc(Fun2, [List]),
  io:format("~w, ~w ~n", [Time1, Time2]).

%%%----------------------------------
%Zadanie:
%moduł Pollution
%nie narzucamy struktury wewnetrznej w jakiej to bedzie przechowywane czy mapy czy co
%+ dodatkowa funkcjonalnośc
%rozbudowanie tego modułu do końca semestru