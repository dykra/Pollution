%%%-------------------------------------------------------------------
%%% @author Joanna
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 11. kwi 2017 09:45
%%%-------------------------------------------------------------------
-module(pingpong).
-author("Joanna").

%% API
-export([start/0,ping_loop/0,pong_loop/0,play/1]).
%start je wystartuje
%czekaja na wiaodmośc bo mają nie robić nic
%play wywołana w konosli i wysyła komunikat z liczbą do jednego z tych 2 procesów
%zmniejzaja liczbe o 1 i wysyalaja do drugiego + druk komuniaku i sleepna 1
%sporo komunikatów miedzy sobą

%uruchamia oba procesy
start() ->
  PidPing = spawn(pingpong, ping_loop,[]),
  register(ping, PidPing),
  PidPong = spawn(pingpong, pong_loop,[]),
  register(pong, PidPong).



ping_loop()->
  receive
    0 -> ping_loop();
    N -> pong ! N-1,timer:sleep(3000),io:format(" Ping wyslal ~w ~n",[N-1]), ping_loop()
   after
    20000 -> stop()
  end.


pong_loop()->
  receive
    0 -> pong_loop();
    N -> ping ! N-1, timer:sleep(3000),io:format(" Pong wyslal ~w ~n",[N-1]),pong_loop()
  after
    20000 -> stop()
  end.

stop() ->
  ok.

play(N)->
  ping ! N.