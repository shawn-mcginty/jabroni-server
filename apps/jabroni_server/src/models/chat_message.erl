-module(chat_message).
-author("shawn").

-record(message, {author::string(), created_on::float(), body::string()}).

%% API
-export([make/1, to_string/1]).

-spec make(string()) -> #message{}.
make(Msg) ->
  {CreatedOnStr, Rest} = message_utils:pop_message_part(Msg),
  {Author, Body} = message_utils:pop_message_part(Rest),
  {CreatedOn, _} = string:to_float((CreatedOnStr)),
  #message{author = Author, created_on = CreatedOn, body = Body}.

-spec to_string(#message{}) -> string().
to_string(Msg) ->
  Body = Msg#message.body,
  Author = Msg#message.author,
  CreatedOn = erlang:binary_to_list(erlang:float_to_binary(Msg#message.created_on, [{decimals, 1}, compact])),
  CreatedOn ++ "|" ++ Author ++ "|" ++ Body.
