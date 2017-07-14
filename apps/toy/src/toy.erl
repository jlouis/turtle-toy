-module(toy).
-export([feed/0]).

-spec feed() -> ok.
feed() ->
    [pub({msg, X}) || X <- lists:seq(1,20)],
    ok.

pub(Data) ->
    Exch = <<"test">>,
    RKey = <<"key">>,
    turtle_publisher:publish(
      toy_amqp_proxy,
      Exch,
      RKey,
      <<"application/x-erlang-term">>,
      term_to_binary(Data, [compressed]),
      #{}).
    
