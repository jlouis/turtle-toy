%%%-------------------------------------------------------------------
%% @doc toy top level supervisor.
%% @end
%%%-------------------------------------------------------------------
-module(toy_sup).

-behaviour(supervisor).

-include_lib("amqp_client/include/amqp_client.hrl").

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

-define(SERVER, ?MODULE).

%%====================================================================
%% API functions
%%====================================================================

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

%%====================================================================
%% Supervisor callbacks
%%====================================================================

%% Child :: {Id,StartFunc,Restart,Shutdown,Type,Modules}
init([]) ->
    {ok, { {one_for_all, 10, 600},
           [client(), server()
           ]} }.

%%====================================================================
%% Internal functions
%%====================================================================

client() ->
    turtle_publisher:child_spec(
      toy_amqp_proxy,
      amqp_server,
      [#'exchange.declare' { exchange = <<"test">>, type = <<"topic">>, durable = true }],
      #{ confirms => true, passive => false }).

server() ->      
    Q = <<"test.queue">>,
    Bind = <<"#">>,

    Config = #{
      name => toy_amqp_service,
      connection => amqp_server,
      function => fun toy_job:loop/4,
      handle_info => fun toy_job:handle_info/2,
      init_state => #{},
      declarations =>
        [#'exchange.declare' { exchange = <<"test">>, type = <<"topic">>, durable = true },
         #'queue.declare' { queue = Q, durable = true, arguments = [] },
         #'queue.bind' {
           queue = Q,
           exchange = <<"test">>,
           routing_key = Bind }],
      subscriber_count => 1,
      prefetch_count => 5,
      consume_queue => Q,
      passive => false
    },
    
    turtle_service:child_spec(Config).
      
