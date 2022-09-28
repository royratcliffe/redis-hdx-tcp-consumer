:- volatile pool_stream_pair/2.
:- dynamic pool_stream_pair/2.

check_in_stream_pair(A, B) :- assertz(pool_stream_pair(A, B)).

check_out_stream_pair(A, B) :- retract(pool_stream_pair(A, B)), !.
check_out_stream_pair(A, B) :- tcp_connect(A, B, [nodelay(true)]).
