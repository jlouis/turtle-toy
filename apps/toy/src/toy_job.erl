-module(toy_job).

-export([loop/4, handle_info/2]).

loop(_, _, Payload, State) ->
    Msg = binary_to_term(Payload),
    lager:debug("Msg received: ~p", [Msg]),
    timer:sleep(timer:minutes(10)),
    lager:debug("Message acked"),
    {ack, State}.

handle_info(Info, State) ->
    lager:debug("Info message received: ~p", [Info]),
    {ok, State}.
