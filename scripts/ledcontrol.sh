#!/bin/bash 

status=/tmp/keyboard_led_status

if [[ ${1} == "on" ]] || [[ ! -e ${status} ]]; then
    xset led named 'Scroll Lock' && echo "on" > ${status}
else
    xset -led named 'Scroll Lock' && rm -f ${status}
fi

