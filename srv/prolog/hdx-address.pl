r_address(Address) :-
    setting(redis_url, URL),
    url_address(URL, redis, Address).

url_address(URL, Protocol, Host:Port) :-
    parse_url(URL, Attributes),
    memberchk(protocol(Protocol), Attributes),
    memberchk(host(Host), Attributes),
    memberchk(port(Port), Attributes).

key_address(Key, Address) :-
    redis(r, hget(hdx:tcp, Key), URL),
    url_address(URL, tcp, Address).
