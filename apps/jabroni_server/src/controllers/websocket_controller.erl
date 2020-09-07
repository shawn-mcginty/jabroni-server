%%%-------------------------------------------------------------------
%%% @author shawn
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 01. Sep 2020 11:08 PM
%%%-------------------------------------------------------------------
-module(websocket_controller).
-author("shawn").

%% API
-export([init/2, websocket_init/1, websocket_handle/2, websocket_info/2, terminate/3]).

init(Req0, State) ->
  io:fwrite("websocket client trying to connect...~n"),
  case cowboy_req:parse_header(<<"sec-websocket-protocol">>, Req0) of
    undefined ->
      io:fwrite("websocket client connected.~n"),
      {cowboy_websocket, Req0, State};
    Sub_protocols ->
      case lists:keymember(<<"mqtt">>, 1, Sub_protocols) of
        true ->
          Req = cowboy_req:set_resp_header(<<"sec-websocket-protocol">>, <<"mqtt">>, Req0),
          {cowboy_websocket, Req, State};
        false ->
          Req = cowboy_req:reply(400, Req0),
          {ok, Req, State}
      end
  end.

websocket_init(State) ->
  erlang:send_after(5000, self(), ping),
  gen_server:call(all_clients, {join, self()}),
  {[{text, <<"ack|connected">>}], State}.

websocket_handle(Frame = {text, Body}, State) ->
  io:fwrite("websocket_handle 1"),
  {Ns, Msg} = message_utils:pop_message_part(Body),
  io:fwrite(Ns),
  case Ns of
    <<"chat_msg">> ->
      io:fwrite("return that shiz"),
      gen_server:cast(all_clients, {text, "chat_msg_ack|" ++ Msg}),
      {ok, State};
    _ ->
      {ok, State}
  end;
websocket_handle(_Frame, State) ->
  {ok, State}.

websocket_info(ping, State) ->
  erlang:send_after(5000, self(), ping),
  io:fwrite("send ping to ~s~n", [pid_to_list(self())]),
  {[ping], State};
websocket_info({text, Msg}, State) ->
  {[{text, Msg}], State};
websocket_info(_Frame, State) ->
  {ok, State}.

terminate(Reason, _PartialReq, _State) ->
  gen_server:call(all_clients, {leave, self()}),
  ok.