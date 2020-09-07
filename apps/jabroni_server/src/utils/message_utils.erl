%%%-------------------------------------------------------------------
%%% @author shawn
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 04. Sep 2020 10:03 PM
%%%-------------------------------------------------------------------
-module(message_utils).
-author("shawn").

%% API
-export([pop_message_part/1]).

-type message_parts() :: {string() | binary(), string() | binary()}.

-spec pop_message_part(string() | binary()) -> message_parts().
pop_message_part("") ->
  {"", ""};
pop_message_part(Msg) ->
  case string:find(Msg, "|") of
    nomatch -> {"", Msg};
    _ ->
      [Part, Rest] = string:split(Msg, "|"),
      {Part, Rest}
  end.
