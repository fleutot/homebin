# bash completion for nrfjprog                             -*- shell-script -*-

# Copyright (C) 2022 Mikael Agren
#
# This program is free software: you can redistribute it and/or modify it 
# under the terms of the GNU General Public License as published by the Free
# Software Foundation, either version 2 of the License, or (at your option)
# any later version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
# details.
#
# You should have received a copy of the GNU General Public License along with
# this program. If not, see <https://www.gnu.org/licenses/>. 

_ids()
{
    nrfjprog --ids | sed 's/\n/ /'
}

_nrfjprog()
{
    local cur prev pprev ppprev words cword
    local single_cmds multi_cmds
    local onchip_erase_opts qspi_erase_opts
    single_cmds='-h --help -v --version'
    multi_cmds='-q --quiet --log --jdll --ini --qspiini --qspicustominit -i --ids --com --deviceversion -f --family -s --snr -c --clockspeed --recover --rbp --pinresetenable -p --pinreset -r --reset -d --debugreset -e --eraseall --qspieraseall --eraseuicr --erasepage --program --memwr --ramwr --verify --memrd --halt --run --readuicr --readcode --readram --readqspi --readregs --coprocessor'
    onchip_erase_opts='--sectorerase --chiperase --sectoranduicrerase'
    qspi_erase_opts='--qspisectorerase --qspichiperase'
    _init_completion || return
    ((cword >= 2)) && pprev=${words[cword - 2]} || pprev=""
    ((cword >= 3)) && ppprev=${words[cword - 3]} || ppprev=""

    # Looking at the last word
    case $prev in
        -h | --help | -v | --version | -i | --ids)
            COMPREPLY=()
            return
            ;;
        --log | --jdll | --init | --qspiini | --readuicr | --readcode \
        | --readram | --readqspi)
            _filedir
            return
            ;;
        --com | --deviceversion)
            COMPREPLY=($(compgen -W '-s --snr' -- "$cur"))
            return
            ;;
        -f | --family)
            COMPREPLY=($(compgen -W 'NRF51 NRF52 NRF53 NRF91 UNKNOWN' -- "$cur"))
            return
            ;;
        -s | --snr)
            COMPREPLY=($(compgen -W "$(_ids)" -- "$cur"))
            return
            ;;
        -c | --clockspeed)
            COMPREPLY=()
            return
            ;;
        --program)
            _filedir
            return
            ;;
        --rbp)
            COMPREPLY=()
            return
            ;;
        --erasepage)
            COMPREPLY=()
            return
            ;;
        --memwr)
            COMPREPLY=()
            return
            ;;
        --ramwr)
            COMPREPLY=()
            return
            ;;
        --verify)
            COMPREPLY=($(compgen -W "--fast $multi_cmds" -- "$cur"))
            return
            ;;
        --val)
            COMPREPLY=()
            return
            ;;
        --memrd)
            COMPREPLY=()
            return
            ;;
        --run)
            COMPREPLY=($(compgen -W '--pc' -- "$cur"))
            return
            ;;
        --pc)
            COMPREPLY=()
            return
            ;;
        --sp)
            COMPREPLY=()
            return
            ;;
        --coprocessor)
            COMPREPLY=($(compgen -W 'CP_APPLICATION CP_MODEM CP_NETWORK' -- "$cur"))
            return
            ;;
    esac

    # Looking at the second from last word and forward
    if [[ $pprev == --program ]]; then
        COMPREPLY=($(compgen -W "$onchip_erase_opts $qspi_erase_opts $multi_cmds" -- "$cur"))
        return
    elif [[ $pprev == --memwr ]]; then
        COMPREPLY=($(compgen -W "--val $multi_cmds" -- "$cur"))
        return
    elif [[ $pprev == --ramwr ]]; then
        COMPREPLY=($(compgen -W "--val $multi_cmds" -- "$cur"))
        return
    elif [[ $pprev == --verify ]]; then
        COMPREPLY=($(compgen -W "--fast $multi_cmds" -- "$cur"))
        return
    elif [[ $pprev == --memrd ]]; then
        COMPREPLY=($(compgen -W "--w --n $multi_cmds" -- "$cur"))
        return
    fi

    # Looking at the third from last word and forward
    if [[ $ppprev == --program ]] && [[ " $onchip_erase_opts " == *" $prev "* ]]; then
        COMPREPLY=($(compgen -W "$qspi_erase_opts $multi_cmds" -- "$cur"))
        return
    elif [[ $ppprev == --program ]] && [[ " $qspi_erase_opts " == *" $prev "* ]]; then
        COMPREPLY=($(compgen -W "$onchip_erase_opts $multi_cmds" -- "$cur"))
        return
    elif [[ $ppprev == --memrd ]] && [[ $pprev == --w ]]; then
        COMPREPLY=($(compgen -W "--n $multi_cmds" -- "$cur"))
        return
    elif [[ $ppprev == --memrd ]] && [[ $pprev == --n ]]; then
        COMPREPLY=($(compgen -W "--w $multi_cmds" -- "$cur"))
        return
    elif [[ $ppprev == --run ]] && [[ $pprev == --pc ]]; then
        COMPREPLY=($(compgen -W "--sp" -- "$cur"))
        return
    fi

    COMPREPLY=($(compgen -W "$single_cmds $multi_cmds" -- "$cur"))
} &&
    complete -F _nrfjprog nrfjprog

# ex: filetype=sh
