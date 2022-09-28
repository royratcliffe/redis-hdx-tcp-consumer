# Redis Half-Duplex TCP Consumer

This Git repository provides a containerised Redis consumer that multiplexes half-duplex and simplex TCP communication via event streams. 'Simplex' refers to communication in one direction only. 'Duplex' comprises two simplex channels for two-way communication; the _full_ variant operates both simplex channels simultaneously. Half-duplex (HDX for short) runs two simplex channels but only one at a time.
