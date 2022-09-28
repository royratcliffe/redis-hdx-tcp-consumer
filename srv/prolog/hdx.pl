:- setting(hdx_time_out, number, env('HDX_TIME_OUT', 3.0), '').

hdx_command(StreamPair, Command) :-
    stream_pair(StreamPair, _, Out),
    hdx(Out, Command).

hdx_query(StreamPair, Query, Reply) :-
    setting(hdx_time_out, TimeOut),
    hdx(StreamPair, Query, Codes, TimeOut),
    string_codes(Reply, Codes).

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

No need to distinguish between command and query at the lower layers of
duplex communication. The upper-level stream determines the mode: either
both halves of the half-duplex cycle, write then read for the query
stream; else write only for the command stream.

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

hdx(StreamPair, Term, Codes, TimeOut) :-
    stream_pair(StreamPair, In, Out),
    hdx(Out, Term),
    hdx(In, Codes, TimeOut).

hdx(Out, Term) :-
    write(Out, Term),
    nl(Out),
    flush_output(Out).

hdx(In, Codes, TimeOut) :-
    wait_for_input([In], [Ready], TimeOut),
    fill_buffer(Ready),
    read_pending_codes(Ready, Codes, []).
