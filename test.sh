#!/bin/sh
set -e

if [ -n $RTL_SERIAL ]; then
    RTL_INDEX=$(rtl_tcp -d9999 2>&1 | grep -o "\d.*SN: $RTL_SERIAL" | cut -c1-1)
fi
echo $RTL_SERIAL
echo $RTL_INDEX

#exec /usr/local/bin/rtl_tcp \
#    -a ${RTL_ADDR-0.0.0.0} \
#   -p ${RTL_PORT-1234} \
#    -g ${RTL_GAIN-3} \
#    -d ${RTL_INDEX-0} \
#    -P ${RTL_PPM_ERROR-0} \
#    -f ${RTL_FREQUENCY-95500000}