%%%-------------------------------------------------------------------
%%% @author shawn
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 04. Sep 2020 10:16 PM
%%%-------------------------------------------------------------------
-module(message_utils_test).
-author("shawn").

-include_lib("eunit/include/eunit.hrl").

pop_message_part_simple_string_test() -> {"head", "body"} = message_utils:pop_message_part("head|body").

pop_message_part_empty_string_test() -> {"", ""} = message_utils:pop_message_part("").

pop_message_part_string_without_splitter_test() -> {"", "body"} = message_utils:pop_message_part("body").

pop_message_part_string_with_many_splitters_test() ->
  {"foo", "body|with|splitters"} = message_utils:pop_message_part("foo|body|with|splitters").

pop_message_part_string_head_of_splitter_test() -> {"", "tail"} = message_utils:pop_message_part("|tail").
