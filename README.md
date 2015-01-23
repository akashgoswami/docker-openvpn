# OpenVPN for Docker

OpenVPN server in a Docker container complete with an EasyRSA PKI CA.


## Quick Start

* Create the `$OVPN_DATA` volume container, i.e. `OVPN_DATA="ovpn-data"`

        docker run --name $OVPN_DATA -v /etc/openvpn busybox

* Initialize the `$OVPN_DATA` container that will hold the configuration files and certificates

        docker run --volumes-from $OVPN_DATA --rm akashgoswami/openvpn ovpn_genconfig -u udp://VPN.SERVERNAME.COM
        docker run --volumes-from $OVPN_DATA --rm -it akashgoswami/openvpn ovpn_initpki

* Start OpenVPN server process
    - On Docker older than version 1.2

            docker run --volumes-from $OVPN_DATA -d -p 1194:1194/udp --privileged akashgoswami/openvpn

* Generate a client certificate without a passphrase

        docker run --volumes-from $OVPN_DATA --rm -it akashgoswami/openvpn easyrsa build-client-full CLIENTNAME nopass

* Retrieve the client configuration with embedded certificates

        docker run --volumes-from $OVPN_DATA --rm akashgoswami/openvpn ovpn_getclient CLIENTNAME > CLIENTNAME.ovpn
