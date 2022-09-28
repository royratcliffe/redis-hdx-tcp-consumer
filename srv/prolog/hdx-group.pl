:- setting(group, atom, env('HDX_GROUP', tcp), '').
:- setting(consumer, atom, env('HOSTNAME'), '').
:- setting(key, atom, env('HDX_KEY', hdx), '').

:- initialization(up, program).

up :-
    setting(group, Group),
    catch(setting(consumer, Consumer),
          error(existence_error(setting, _), _),
          gethostname(Consumer)),
    setting(key, Key),
    atomic_concat(Key, ':command', CommandKey),
    atomic_concat(Key, ':query', QueryKey),
    xgroup_create(CommandKey, Group),
    xgroup_create(QueryKey, Group),
    thread_create(xlisten_group(r, Group, Consumer, [CommandKey, QueryKey],
                                [ block(0.1)
                                ]),
                  _, [alias(Consumer), detached(true)]).

xgroup_create(Key, Group) :-
    catch(redis(r, xgroup(create, Key, Group, $, mkstream), status(ok)),
          error(redis_error(busygroup, _), _), true).
