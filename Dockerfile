# Original credit: https://github.com/kylemanna/docker-openvpn

# Leaner build then Ubunutu
FROM debian:jessie

MAINTAINER Akash Goswami <akashgoswami@gmail.com>

RUN apt-get update && \
    apt-get install -y openvpn iptables git-core curl python \
    python-dev python-pip libffi-dev libssl-dev curl python \
    python-dev python-pip libffi-dev libssl-dev && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN pip install dispy gevent python-etcd

# Update checkout to use tags when v3.0 is finally released
RUN git clone --depth 1 --branch v3.0.0-rc2 https://github.com/OpenVPN/easy-rsa.git /usr/local/share/easy-rsa && \
    ln -s /usr/local/share/easy-rsa/easyrsa3/easyrsa /usr/local/bin

# Needed by scripts
ENV OPENVPN /etc/openvpn
ENV EASYRSA /usr/local/share/easy-rsa/easyrsa3
ENV EASYRSA_PKI $OPENVPN/pki
ENV EASYRSA_VARS_FILE $OPENVPN/vars

VOLUME ["/etc/openvpn"]

# Internally uses port 51348 for dispy, remap using docker
EXPOSE 51348/udp
EXPOSE 51348

WORKDIR /etc/openvpn
CMD ["ovpn_run"]

ADD ./bin /usr/local/bin
RUN chmod a+x /usr/local/bin/*
