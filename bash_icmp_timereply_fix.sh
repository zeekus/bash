#!/bin/bash
#create_icmptypes for firewalld
#filename: bash_icmp_timereply_fix.sh
#goal Disable ICMP timestamp responses on Linux
#why we need this ? - The easiest and most effective solution is to configure your firewall to block incoming and outgoing ICMP packets with ICMP types 13 (timestamp request) and 14 (timestamp response).

# Create directory /etc/firewalld/icmptypes if missing
if [[ ! -d /etc/firewalld/icmptypes ]]; then
   echo "Creating /etc/firewalld/icmptypes directory"
   mkdir -p /etc/firewalld/icmptypes
else
  echo "Directory /etc/firewalld/icmptypes already exists"
fi

# Create file: /etc/firewalld/icmptypes/timestamp-request.xml if missing
if [[ ! -e /etc/firewalld/icmptypes/timestamp-request.xml ]]; then
    echo "Creating /etc/firewalld/icmptypes/timestamp-request.xml"
    cat <<EOF > /etc/firewalld/icmptypes/timestamp-request.xml
<?xml version="1.0" encoding="utf-8"?>
<icmptype>
  <short>Timestamp Request</short>
  <description>This message is used for time synchronization.</description>
  <destination ipv4="yes"/>
  <destination ipv6="no"/>
</icmptype>
EOF
    firewall-cmd --reload
    firewall-cmd --add-icmp-block=timestamp-request
else
    echo "File /etc/firewalld/icmptypes/timestamp-request.xml already exists"
fi

# Create file: /etc/firewalld/icmptypes/timestamp-reply.xml if missing
if [[ ! -e /etc/firewalld/icmptypes/timestamp-reply.xml ]]; then
    echo "Creating /etc/firewalld/icmptypes/timestamp-reply.xml"
    cat <<EOF > /etc/firewalld/icmptypes/timestamp-reply.xml
<?xml version="1.0" encoding="utf-8"?>
<icmptype>
  <short>Timestamp Reply</short>
  <description>This message is used to reply to a timestamp message.</description>
  <destination ipv4="yes"/>
  <destination ipv6="no"/>
</icmptype>
EOF
    firewall-cmd --reload
    firewall-cmd --add-icmp-block=timestamp-reply
else
    echo "File /etc/firewalld/icmptypes/timestamp-reply.xml already exists"
fi
