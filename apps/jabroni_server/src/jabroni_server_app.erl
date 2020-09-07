%%%-------------------------------------------------------------------
%% @doc jabroni-server public API
%% @end
%%%-------------------------------------------------------------------

-module(jabroni_server_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    Dispatch = cowboy_router:compile([
        {'_', [
            {"/api/v1/plaintext", ping_controller, []},
            {"/websockets", websocket_controller, []}
        ]}
    ]),
    {ok, _} = cowboy:start_clear(http_api,
        [{port, 9000}],
        #{env => #{dispatch => Dispatch}}),
    all_clients:start_link(),
    jabroni_server_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
