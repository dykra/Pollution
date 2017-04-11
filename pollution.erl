%%%-------------------------------------------------------------------
%%% @author Joanna
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 06. kwi 2017 18:49

%%%-------------------------------------------------------------------
-module(pollution).
-author("Joanna").

%% API

-export([createMonitor/0,addStation/3,addValue/5,removeValue/4,getOneValue/4,getStationMean/3,getDailyMean/3, getMinimumPollutionStation/2]).
-record(station,{name, latitude, longitude, measurements=[]}).
-record(measurement,{localTime, valueType,value}).

createMonitor() -> [].

addStation(Name, {Latitude,Longitude}, Monitor) ->
  case ((lists:any(fun(#station{name = A}) -> A=:=Name end,Monitor)) or (lists:any(fun(#station{latitude = A, longitude = B}) -> ( A =:= Latitude andalso B =:= Longitude )end,Monitor))) of
    true -> {error,"Taka stacja już istnieje."};
    _ -> [#station{name = Name, latitude = Latitude, longitude=Longitude}|Monitor]
  end.


addValue({Latitude,Longitude},LocalTime,ValueType,Value,Monitor) ->
  case lists:any(fun(#station{longitude = Long,latitude = Lati,measurements = Measur})-> (Long=:=Longitude) and (Lati=:=Latitude) and
    ( not lists:any(fun(#measurement{localTime = A,valueType = Type})-> (A=:=LocalTime) and (Type =:= ValueType) end, Measur)) end,Monitor) of
    true -> addValueAlways({Latitude, Longitude}, LocalTime, ValueType, Value, Monitor);
    _ -> {error,"Taka stacja nie istnieje lub taka wartość jest już dodana."}
  end;

addValue(Name,LocalTime,ValueType,Value,Monitor) ->
  case lists:any(fun(#station{name = A,measurements = Measur})-> A=:=Name andalso
    lists:any(fun(#measurement{localTime = A,valueType = Type})-> A=:=LocalTime andalso Type =:= ValueType end, Measur) end,Monitor) of
    false -> addValueAlways(Name, LocalTime, ValueType, Value, Monitor);
    _ -> {error,"Taka stacja nie istnieje lub taka wartość jest już dodana."}
  end.


addValueAlways({Latitude, Longitude}, LocalTime, Type, Value, []) ->[#station{latitude = Latitude, longitude=Longitude},measurments=[#measurement{localTime = LocalTime, valueType = Type,value = Value}]];
addValueAlways({Latitude, Longitude}, LocalTime, Type, Value, [H=#station{latitude=Latitude,longitude=Longitude}|T]) ->
  [#station{name=H#station.name ,latitude = Latitude, longitude=Longitude, measurements = H#station.measurements++[#measurement{localTime = LocalTime, valueType = Type,value = Value}] }|T];
addValueAlways({Latitude, Longitude}, LocalTime, Type, Value, [H|T]) -> [H|addValueAlways({Latitude, Longitude}, LocalTime, Type, Value, T)];

addValueAlways(Name, LocalTime, Type, Value, []) ->[#station{name = Name},measurments=[#measurement{localTime = LocalTime, valueType = Type,value = Value}]];
addValueAlways(Name, LocalTime, Type, Value, [H=#station{name = Name}|T]) ->
  [#station{name=Name ,latitude = H#station.latitude, longitude=H#station.longitude, measurements = H#station.measurements++[#measurement{localTime = LocalTime, valueType = Type,value = Value}] }|T];
addValueAlways(Name, LocalTime, Type, Value, [H|T]) -> [H|addValueAlways(Name, LocalTime, Type, Value, T)].

removeValue({Latitude,Longitude},LocalTime,ValueType,Monitor) ->
  case lists:any(fun(#station{longitude = Long,latitude = Lati,measurements = Measur})-> (Long=:=Longitude) and (Lati=:=Latitude) and
    (lists:any(fun(#measurement{localTime = A,valueType = Type})-> (A=:=LocalTime) and (Type =:= ValueType) end, Measur)) end,Monitor) of
     true -> removeValueAlways({Latitude,Longitude},LocalTime,ValueType,Monitor);
    _ -> {error,"Taka stacja nie istnieje lub nie ma takiej wartości."}
  end;
removeValue(Name,LocalTime,ValueType,Monitor) ->
  case lists:any(fun(#station{name = A,measurements = Measur})-> A=:=Name andalso
    lists:any(fun(#measurement{localTime = A,valueType = Type})-> A=:=LocalTime andalso Type =:= ValueType end, Measur) end,Monitor) of
    false -> removeValueAlways(Name,LocalTime,ValueType,Monitor);
    _ -> {error,"Taka stacja nie istnieje lub taka wartość jest już dodana."}
  end.

removeValueAlways({_,_}, _, _, []) -> [];
removeValueAlways({Latitude, Longitude}, LocalTime, Type, [H=#station{latitude=Latitude,longitude=Longitude}|T]) -> [#station{name=H#station.name, longitude =Longitude, latitude =Latitude,
  measurements = lists:filter((fun(#measurement{localTime = A,valueType = B, value = Value})-> (A/=LocalTime) and (B/=Type) end), H#station.measurements)}];
removeValueAlways({Latitude, Longitude}, LocalTime, Type, [H|T]) ->[H | removeValue({Latitude, Longitude}, LocalTime, Type,T)];

removeValueAlways(_, _, _, []) -> [];
removeValueAlways(Name, LocalTime, Type, [H=#station{name=Name}|T]) -> [#station{name=H#station.name, longitude =H#station.longitude, latitude =H#station.latitude,
  measurements = lists:filter((fun(#measurement{localTime = A,valueType = B, value = Value})-> (A/=LocalTime) and (B/=Type) end), H#station.measurements)}];
removeValueAlways(Name, LocalTime, Type, [H|T]) ->[H | removeValue(Name, LocalTime, Type,T)].

getOneValue(_,_,_, []) -> {error, "Nie ma takiej wartości"};
getOneValue(Name,LocalTime,Type,[H=#station{name=Name}|T]) -> getOne(lists:filter((fun(#measurement{localTime = A,valueType = B, value = Value})-> (A=:=LocalTime) and (B=:=Type) end), H#station.measurements));
getOneValue(Name,LocalTime,Type,[H|T]) -> getOneValue(Name,LocalTime,Type,T).

getOne([#measurement{value = V}]) -> V.

%--------------------------
averageWith0([], 0, _) -> 0;
averageWith0(List,Length,Sum) -> average(List,Length,Sum).

average([H|T], Length, Sum) -> average(T, Length + 1, Sum + H);
average([], Length, Sum) -> Sum / Length.

getStationMean(Name, Type, []) -> 0;
getStationMean(Name, ValueType,[H=#station{name=Name}|T]) -> averageWith0(getList(H, ValueType),0,0);
getStationMean(Name,Type,[H|T]) -> getStationMean(Name,Type,T).

getList(#station{name = Name, measurements = Measurments}, ValueType) ->
  lists:map(fun(#measurement{localTime = LocalTime,valueType = ValueType, value = V}) -> V end,
    lists:filter(fun(#measurement{valueType = Type1}) -> (Type1=:= ValueType) end,Measurments)).


getDailyMean(_, _, []) -> [];
getDailyMean(LocalTime, ValueType, Monitor) -> averageWith0(lists:filter(fun(#measurement{localTime = LocalTime1,valueType = ValueType1, value = V}) -> (LocalTime=:=LocalTime1)and (ValueType=:=ValueType1)  end, conCat(makeAllMeasurementsList(Monitor))),0,0).

makeAllMeasurementsList(Monitor) ->
  lists:map(fun(#station{name=N, latitude = Latitude, longitude = Longitude, measurements = Measurements}) -> Measurements end ,Monitor).

conCat([]) -> [];
conCat([H|Tail]) -> H++ conCat(Tail).


getMinimumPollutionValue(ValueType,Monitor) -> getMinimumPollutionValueHelper(getOnlyTypeMeasurements(ValueType,Monitor),10000000).

getOnlyTypeMeasurements(ValueType,Monitor) ->
  lists:filter( fun(#measurement{valueType = ValueType1}) -> ValueType=:=ValueType1 end  ,conCat(lists:map(fun(#station{name=N, latitude = Latitude, longitude = Longitude, measurements = Measurements}) -> Measurements end ,Monitor))).


getMinimumPollutionValueHelper([],MinValue) -> MinValue;
getMinimumPollutionValueHelper([H|T],MinValue) ->
  case H#measurement.value < MinValue of
    true -> getMinimumPollutionValueHelper(T,H#measurement.value);
    _ -> getMinimumPollutionValueHelper(T,MinValue)
  end.


getMinimumPollutionStation(ValueType,Monitor) -> findStationsForValue(ValueType,Monitor,getMinimumPollutionValue(ValueType,Monitor),[]).

findStationsForValue(_,[],_,Result) -> Result;
findStationsForValue(ValueType,[H|T],Value,Result) ->
  case lists:any(fun(#measurement{value = A,valueType = Type})-> (A=:=Value) and (Type =:= ValueType) end, H#station.measurements) of
    false -> findStationsForValue(ValueType,T,Value,Result);
    _ -> findStationsForValue(ValueType,T,Value,[H|Result])
  end.