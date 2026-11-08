#!/usr/bin/env bash

mission() { #donne les intruction de la mission en cours
    if [[ "$etape" == 1 ]]; then
        echo '1. Retrouve le compte rendu caché dans campus.'
        echo 'Il contient le code du casier du BDE, où sont les clés du département.'
        echo 'Écris seulement ce code dans resultat/reponse.txt.'
    elif [[ "$etape" == 2 ]]; then
        echo '2. La porte est ouverte, mais le hall est encombré.'
        echo 'Déplace les trois chaises de hall vers reserve ; laisse le routeur dans hall.'
    elif [[ "$etape" == 3 ]]; then
        echo '3. Internet a été désactivé dans les salles pendant le blocage.'
        echo 'Dans journaux/reseau.log, trouve la ligne contenant REACTIVATION_TC.'
        echo 'Copie cette ligne entière dans resultat/reseau.txt pour réactiver le réseau.'
        echo 'Indice : grep permet de rechercher un texte dans un fichier.'
    elif [[ "$etape" == 4 ]]; then
        echo '4. Le réseau fonctionne, mais la page du département annonce encore le blocage.'
        echo 'Dans resultat/tc.html, remplace BLOQUEE par DEBLOQUEE sans modifier le reste.'
        echo 'Copie ensuite cette page dans site_local pour publier la mise à jour.'
        echo 'Tu peux ouvrir site_local/tc.html dans ton navigateur pour voir le résultat.'
    elif [[ "$etape" == 5 ]]; then
        echo 'VICTOIRE ! Hedy Lamarr est débloqué et la page locale est à jour.'
        echo 'Le TD de 8 h est maintenu. La machine à café sera livrée entre 8 h et 18 h.'
    fi
}

initialiser() {
    partie=$(mktemp -d "$PWD/partie_XXXXXX") #  Crée dossier avec un nom unique
    echo "$partie" > .partie_active
    cd "$partie"
    mkdir -p campus/bde campus/scolarite hall reserve journaux resultat site_local
    echo 1 > etape.txt
    code=$((1000 + RANDOM % 9000))
    printf 'COMPTE RENDU : accord de réouverture du département TC.\nUne nouvelle machine à café sera installée.\nLes clés de la porte sont dans le casier du BDE.\nCode du casier : %s\nAvant la reprise : ranger le hall, réactiver Internet et actualiser la page du département.\n' "$code" > campus/bde/.compte_rendu.txt #meme chose que echo mais permet de le faire ne une seule ligne
    echo 'Le compte rendu est un fichier caché. La transparence a ses limites.' > campus/bde/lisez_moi.txt
    echo 'Réouverture après rangement, réactivation du réseau et mise à jour du site.' > campus/scolarite/annonce.txt
    touch hall/chaise_1.txt hall/chaise_2.txt hall/chaise_3.txt #Creer des fichiers vides
    echo 'Laisser le routeur dans le hall.' > hall/routeur.txt
    touch resultat/reponse.txt resultat/reseau.txt
    echo 'DESACTIVE' > journaux/etat_reseau.txt
    code_reseau=$((1000 + RANDOM % 9000))
    # Une seule ligne utile, placée au milieu des messages.
    for numero in {1..40}; do
        if [[ "$numero" == 23 ]]; then
            echo "REACTIVATION_TC code=$code_reseau action=ACTIVER"
        else
            echo "evenement=$numero controle=OK message=maintenance"
        fi
    done > journaux/reseau.log #affiche les lignes directement dans le doc sans passer par le terminal
    printf '<!DOCTYPE html>\n<html lang="fr">\n<head><meta charset="UTF-8"><title>Département TC - jeu</title></head>\n<body>\n<h1>Département TC - Hedy Lamarr</h1>\n<p>Situation : BLOQUEE</p>\n</body>\n</html>\n' > resultat/tc.html
    cp resultat/tc.html site_local/tc.html
    echo 'OPÉRATION HEDY LAMARR'
    echo 'Depuis plusieurs semaines, le bâtiment du département TC est bloqué par des étudiants qui demandent une machine à café fonctionnelle.'
    echo 'Après de longs débats, un accord de réouverture a été trouvé : une nouvelle machine à café sera installée !'
    echo 'Mais avant la réouverture, plusieurs problèmes restent à régler.'
    echo 'Les chaises encombrent le hall. Les clés de la porte sont dans un casier au BDE.'
    echo 'Internet a été désactivé et la page du département annonce encore le blocage.'
    echo 'Tu es volontaire pour tout remettre en ordre.'
    echo 'Les fichiers de réponse sont déjà disponibles dans le dossier resultat.'
    printf 'Entre dans le dossier de partie : %s\n' "$partie"
    echo 'Rappel du défi : bash jeu.sh mission'
    echo 'Vérification : bash jeu.sh verifier'
    etape=1
    mission
}

verifier() {
    reussi=non
    if [[ "$etape" == 1 ]]; then
        code=$(grep 'Code du casier' campus/bde/.compte_rendu.txt)
        code=${code##* } #enlève tout jusqu’au dernier espace inclus
        if [[ $(cat resultat/reponse.txt) == "$code" ]]; then
            reussi=oui
            echo 'Le casier est ouvert : tu récupères les clés du département.'
        fi
    elif [[ "$etape" == 2 ]]; then
        reussi=oui
        for numero in 1 2 3; do
            if [[ -e hall/chaise_$numero.txt ]]; then # chemin existe
                reussi=non
            fi
            if [[ ! -f reserve/chaise_$numero.txt ]]; then #fichier normal existe 
                reussi=non
            fi
        done
        if [[ ! -f hall/routeur.txt ]]; then
            reussi=non
        fi
    elif [[ "$etape" == 3 ]]; then
        attendu=$(grep 'REACTIVATION_TC' journaux/reseau.log)
        if [[ $(cat resultat/reseau.txt) == "$attendu" ]]; then
            reussi=oui
            echo 'ACTIF' > journaux/etat_reseau.txt
            echo 'Internet est réactivé dans les salles (simulation).'
        fi
    elif [[ "$etape" == 4 ]]; then
        if grep -qx '<p>Situation : DEBLOQUEE</p>' resultat/tc.html; then #q -> bool -x correspondance complete
            if cmp -s resultat/tc.html site_local/tc.html; then #compare octet par octet
                reussi=oui
            fi
        fi
    fi
    if [[ "$etape" != 5 ]]; then
        if [[ "$reussi" == oui ]]; then
            etape=$((etape + 1))
            echo "$etape" > etape.txt
            echo 'Étape validée.'
        else
            echo 'Pas encore. Vérifie le résultat demandé et réessaie.'
        fi
    fi
    mission
}

cd "$(dirname "$0")" #place le programme dans le dossier contenant jeu.sh
action=${1:-aide} # Mets le premier argument dans action. S’il est absent ou vide, mets aide, aide par defaut
if [[ "$action" == nouveau ]]; then
    initialiser
elif [[ "$action" == mission ]]; then
    partie=$(cat .partie_active)
    cd "$partie"
    etape=$(cat etape.txt)
    mission
elif [[ "$action" == verifier ]]; then
    partie=$(cat .partie_active)
    cd "$partie"
    etape=$(cat etape.txt)
    verifier
else
    echo 'Usage : bash jeu.sh nouveau | mission | verifier'
fi
