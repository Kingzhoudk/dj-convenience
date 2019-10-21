#!/bin/bash
sleep 5

source ~/.bashrc


dj_convenience_path="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

source $dj_convenience_path/funcs.bash

_dj_keyremap_enable
_dj_touchpad_thinkpad_control 0