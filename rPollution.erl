%%%-------------------------------------------------------------------
%%% @author Joanna
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 09. maj 2017 10:41
%%%-------------------------------------------------------------------
-module(rPollution).
-author("Joanna").

-behaviour(gen_server).

%% API
-export([start_link/0]).

%% gen_server callbacks
-export([init/1,
  handle_call/3,
  handle_cast/2,
  handle_info/2,
  terminate/2,
  code_change/3]).

-export([print/0,addStation/2,addValue/4, removeValue/3,getOneValue/3,getStationMean/2,getDailyMean/2]).

-define(SERVER, ?MODULE).

-record(state, {}).

%%%===================================================================
%%% API
%%%===================================================================

%%--------------------------------------------------------------------
%% @doc
%% Starts the server
%%
%% @end
%%--------------------------------------------------------------------

% start() -> gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).
% checkout(Who, Book) -> gen_server:call(?MODULE, {checkout, Who, Book}).
% lookup(Book) -> gen_server:call(?MODULE, {lookup, Book}).
% return(Book) -> gen_server:call(?MODULE, {return, Book}).

-spec(start_link() ->
  {ok, Pid :: pid()} | ignore | {error, Reason :: term()}).
start_link() ->
  gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

%todo end this one here maybe {Info, Pid} = rPo:start_link()
% todo crash function
% http://learnyousomeerlang.com/clients-and-servers

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Initializes the server
%%
%% @spec init(Args) -> {ok, State} |
%%                     {ok, State, Timeout} |
%%                     ignore |
%%                     {stop, Reason}
%% @end
%%--------------------------------------------------------------------

% as initial value we will give empty Monitor

-spec(init(Args :: term()) ->
  {ok, State :: #state{}} | {ok, State :: #state{}, timeout() | hibernate} |
  {stop, Reason :: term()} | ignore).
init([]) ->
  {ok, []}.


addStation(Name,{Latitude, Longitude}) -> gen_server:call(?SERVER, {addStation,Name,{Latitude, Longitude}}).
addValue({Latitude, Longitude},{Day,Hour},Type,Value) -> gen_server:call(?SERVER, {addValue,{Latitude, Longitude},{Day,Hour},Type,Value});
addValue(Name,{Day,Hour},Type,Value)-> gen_server:call(?SERVER, {addValue,Name,{Day,Hour},Type,Value}).
getDailyMean(Type,Day)-> gen_server:call(?SERVER, {getDailyMean,Type,Day}).
getStationMean(Name,Type)-> gen_server:call(?SERVER, {getStationMean,Name,Type}).
getOneValue(Name,Type,{Day,Hour})-> gen_server:call(?SERVER, {getOneValue,Name,Type,{Day,Hour}}).
removeValue(Name,{Day,Hour},Type)-> gen_server:call(?SERVER, {removeValue,Name,{Day,Hour},Type}).

% print()-> gen_server:call(?SERVER, {print}).

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling call messages
%%
%% @end
%%--------------------------------------------------------------------
-spec(handle_call(Request :: term(), From :: {pid(), Tag :: term()},
    State :: #state{}) ->
  {reply, Reply :: term(), NewState :: #state{}} |
  {reply, Reply :: term(), NewState :: #state{}, timeout() | hibernate} |
  {noreply, NewState :: #state{}} |
  {noreply, NewState :: #state{}, timeout() | hibernate} |
  {stop, Reason :: term(), Reply :: term(), NewState :: #state{}} |
  {stop, Reason :: term(), NewState :: #state{}}).
handle_call({addValue,{Latitude, Longitude},{Day,Hour},Type,Value}, _From, State) ->
  case pollution:addValue({Latitude, Longitude},{Day,Hour},Type,Value,State) of
    {error, _} -> {reply,error, state};
    NewState -> {reply,ok, NewState}
  end;
handle_call({addValue,Name,{Day,Hour},Type,Value}, _From, State) ->
  case pollution:addValue(Name,{Day,Hour},Type,Value,State) of
    {error, _} -> {reply,error, state};
    NewState -> {reply,ok, NewState}
  end;
handle_call({addStation,Name,{Latitude, Longitude}}, _From, State) ->
  case pollution:addStation(Name,{Latitude, Longitude},State) of
    {error, _} -> {reply,error, state};
    NewState -> {reply,ok, NewState}
  end;
handle_call({getDailyMean,Type,Day}, _From, State) ->
  case pollution:getDailyMean(Type,Day,State) of
    {error, _} -> {reply,error, state};
    NewState -> {reply,ok, NewState}
  end;
handle_call({getStationMean,Name,Type}, _From, State) ->
  case pollution:getStationMean(Name,Type,State) of
    {error, _} -> {reply,error, state};
    NewState -> {reply,ok, NewState}
  end;
handle_call({getOneValue,Name,Type,{Day,Hour}}, _From, State) ->
  case pollution:getOneValue(Name,Type,{Day,Hour},State) of
    {error, _} -> {reply,error, state};
    NewState -> {reply,ok, NewState}
  end;
handle_call({removeValue,Name,{Day,Hour},Type}, _From, State) ->
  case pollution:removeValue(Name,{Day,Hour},Type,State) of
    {error, _} -> {reply,error, state};
    NewState -> {reply,ok, NewState}
  end.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling cast messages
%%
%% @end
%%--------------------------------------------------------------------
-spec(handle_cast(Request :: term(), State :: #state{}) ->
  {noreply, NewState :: #state{}} |
  {noreply, NewState :: #state{}, timeout() | hibernate} |
  {stop, Reason :: term(), NewState :: #state{}}).
handle_cast(_Request, State) ->
  {noreply, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling all non call/cast messages
%%
%% @spec handle_info(Info, State) -> {noreply, State} |
%%                                   {noreply, State, Timeout} |
%%                                   {stop, Reason, State}
%% @end
%%--------------------------------------------------------------------
-spec(handle_info(Info :: timeout() | term(), State :: #state{}) ->
  {noreply, NewState :: #state{}} |
  {noreply, NewState :: #state{}, timeout() | hibernate} |
  {stop, Reason :: term(), NewState :: #state{}}).
handle_info(_Info, State) ->
  {noreply, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% This function is called by a gen_server when it is about to
%% terminate. It should be the opposite of Module:init/1 and do any
%% necessary cleaning up. When it returns, the gen_server terminates
%% with Reason. The return value is ignored.
%%
%% @spec terminate(Reason, State) -> void()
%% @end
%%--------------------------------------------------------------------
-spec(terminate(Reason :: (normal | shutdown | {shutdown, term()} | term()),
    State :: #state{}) -> term()).
terminate(_Reason, _State) ->
  ok.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Convert process state when code is changed
%%
%% @spec code_change(OldVsn, State, Extra) -> {ok, NewState}
%% @end
%%--------------------------------------------------------------------
-spec(code_change(OldVsn :: term() | {down, term()}, State :: #state{},
    Extra :: term()) ->
  {ok, NewState :: #state{}} | {error, Reason :: term()}).
code_change(_OldVsn, State, _Extra) ->
  {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
