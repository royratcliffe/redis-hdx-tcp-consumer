:- setting(redis_url, atom, env('REDIS_URL', 'redis://localhost:6379'), '').

:- r_address(Address), redis_server(r, Address, []).
