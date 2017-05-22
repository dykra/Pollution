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
