:- listen(redis_consume(Key, Data, Context), consume(Key, Data, Context)).

consume(Key, Data, Context) :-
    sub_atom(Key, _, _, 0, ':command'),
    !,
    command(Data, Context.put(key, Key)).
consume(Key, Data, Context) :-
    sub_atom(Key, _, _, 0, ':query'),
    !,
    query(Data, Context.put(key, Key)).

command(Data, Context) :-
    get_dict(command, Data, Command),
    get_dict(key, Data, Key),
    key_address(Key, Address),
    !,
    check_out_stream_pair(Address, StreamPair),
    hdx_command(StreamPair, Command),
    check_in_stream_pair(Address, StreamPair),
    xadd(r, Key, _, _{message:Context.message,
                      key:Context.key,
                      group:Context.group,
                      consumer:Context.consumer}).
command(_, _).

query(Data, Context) :-
    get_dict(query, Data, Query),
    get_dict(key, Data, Key),
    key_address(Key, Address),
    !,
    check_out_stream_pair(Address, StreamPair),
    hdx_query(StreamPair, Query, Reply),
    check_in_stream_pair(Address, StreamPair),
    xadd(r, Key, _, _{reply:Reply,
                      key:Context.key,
                      message:Context.message,
                      group:Context.group,
                      consumer:Context.consumer}).
query(_, _).
