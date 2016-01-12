#!/bin/bash
# $Id$
#
# sCRiPTz-TEAM -- Fixed sleep and awk paths for UBUNTU 15.10, added chainlist and logpath


# Variablen

LOGPATH="/home/rrd_traffic"
# Example:
#  CHAINLIST="HTTP SSH DNS"
CHAINLIST="all-traffic"

SLEEP_BIN="/bin/sleep"
IPTABLES_BIN="/sbin/iptables"
GREP_BIN="/bin/grep"
TAIL_BIN="/usr/bin/tail"
AWK_BIN="/usr/bin/awk"

# Programm

${SLEEP_BIN} 5
${IPTABLES_BIN} -nvxL > ${LOGPATH}/tmpfile

for CHAIN in ${CHAINLIST}
do
        TRAFFIC=`${GREP_BIN} -A 2 "Chain ${CHAIN} " ${LOGPATH}/tmpfile | ${TAIL_BIN} -n 1 | ${AWK_BIN} '{print $2}'`
        echo -n "${TRAFFIC}" > ${LOGPATH}/${CHAIN}
done
