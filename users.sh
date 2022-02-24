#!/bin/bash
useradd -m -s /bin/bash dennis
echo "dennis:1234" | chpasswd
useradd -m -s /bin/bash rayo
echo "rayo:1234" | chpasswd 
