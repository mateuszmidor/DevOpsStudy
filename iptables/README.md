# iptables

1. list rules in table "filter" (numeric, verbose) -  chain INPUT should be empty
    ```sh
    sudo iptables -L -t filter -n -v 

    Chain INPUT (policy ACCEPT 6432 packets, 7546K bytes) # default policy of this chain is to ACCEPT packets
     pkts bytes target     prot opt in     out     source               destination         

    <other chains>
    ```

1. block www.wp.pl
    ```sh
    sudo iptables -A INPUT -t filter -s www.wp.pl -j DROP # Append in "INPUT" chain of "filter" table a rule to DROP packets with source "www.wp.pl"
    sudo iptables -L -n -v -t filter

    Chain INPUT (policy ACCEPT 32 packets, 2881 bytes)
     pkts bytes target     prot opt in     out     source               destination         
        0     0 DROP       all  --  *      *       212.77.98.9          0.0.0.0/0   # www.wp.pl resolved to 212.77.98.9 

    <other chains>
    ```

1. try request www.wp.pl with - should timeout
    ```sh
    curl www.wp.pl --connect-timeout 5 --location
    curl: (28) Connection timeout after 5000 ms
    ```

1. unblock www.wp.pl
    ```sh
    sudo iptables -D INPUT 1 -t filter # delete rule number 1 in "INPUT" chain of "filter" table which happens to be blocking www.wp.pl
    sudo iptables -L -n -v -t filter

    Chain INPUT (policy ACCEPT 6432 packets, 7546K bytes)
        pkts bytes target     prot opt in     out     source               destination         

    <other chains>
    ```