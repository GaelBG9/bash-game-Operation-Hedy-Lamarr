# Opération Hedy Lamarr ☕

**Un mini-jeu d’énigmes en Bash pour découvrir les commandes UNIX**, réalisé dans le cadre du projet PIT à l’INSA Lyon.

Depuis plusieurs semaines, le bâtiment du département TC est bloqué : les étudiants réclament une machine à café fonctionnelle. Un accord est enfin trouvé, mais la réouverture demande encore quelques efforts. À toi de retrouver les clés, de dégager le hall, de réactiver Internet et de mettre à jour la page du département !

Les lieux sont des dossiers, les objets et les indices sont des fichiers. Tu joues directement dans le terminal avec de vraies commandes UNIX.

- **Langue :** français.
- **Durée indicative :** 10 à 20 minutes.
- **Niveau :** débutant, avec un manuel pour t’aider.
- **Fonctionnement :** entièrement local, sans connexion Internet pendant la partie.

> Il s’agit d’une fiction pédagogique : le réseau et le site web sont simulés. Le jeu ne modifie ni le réseau réel ni le site de l’INSA.

## 📥 Télécharger

### Sans Git — méthode la plus simple

1. [Télécharger le ZIP de la branche main](https://github.com/GaelBG9/bash-game-Op-ration-Hedy-Lamarr/archive/refs/heads/main.zip), ou cliquer sur **Code → Download ZIP**.
2. Extraire l’archive avec « Extraire tout » ou le gestionnaire d’archives.
3. Ouvrir le dossier extrait, puis le sous-dossier `hedy` contenant `jeu.sh`.
4. Ouvrir un terminal **Linux ou WSL** dans ce dossier. Ne pas exécuter le jeu directement dans l’archive.

### Avec Git

```bash
git clone https://github.com/GaelBG9/bash-game-Op-ration-Hedy-Lamarr.git
cd bash-game-Op-ration-Hedy-Lamarr/hedy
```

## 🧰 Prérequis

- Un environnement **GNU/Linux**, par exemple Debian ou Ubuntu, ou **Ubuntu sous WSL** sur Windows.
- **Bash** et les outils usuels : `mktemp`, `dirname`, `mkdir`, `touch`, `cat`, `ls`, `mv`, `cp`, `grep` et `cmp` (habituellement déjà présents).
- Un éditeur de texte : `nano`, `vi` ou un autre éditeur permettant de conserver les fichiers en UTF-8 avec des fins de ligne LF.
- Un navigateur est facultatif pour afficher la page HTML finale.

Aucune bibliothèque Python, aucun serveur web et aucun droit administrateur ne sont nécessaires pour jouer. Utiliser `bash`, pas `sh`. PowerShell et l’invite de commandes Windows ne sont pas des interpréteurs Bash.

**Sous Windows avec WSL déjà installé :** ouvre Ubuntu/WSL, puis rejoins le dossier extrait. Par exemple, en adaptant le nom d’utilisateur et le chemin :

```bash
cd "/mnt/c/Users/TON_NOM/Downloads/bash-game-Op-ration-Hedy-Lamarr-main/hedy"
```

Si tu n’as pas WSL, utilise l’environnement Linux du TP ou installe WSL/Ubuntu avant de jouer. Aucun paquet supplémentaire n’est téléchargé par le jeu.

## ▶️ Démarrer une partie

Depuis le dossier `hedy` :

```bash
bash jeu.sh nouveau
```

Le jeu crée un dossier `partie_XXXXXX`, prépare tous les fichiers et affiche le chemin de la partie. Entre dans **le chemin réellement affiché** :

```bash
cd "/chemin/affiche/partie_XXXXXX"
```

Tu peux maintenant explorer, lire les indices, déplacer les objets et remplir les fichiers de réponse déjà présents dans `resultat/`.

### Rappeler ou valider une mission

Depuis la **racine du dossier de partie** :

```bash
bash ../jeu.sh mission
bash ../jeu.sh verifier
```

Le script se trouve un dossier plus haut, d’où `../jeu.sh`. Les messages du script affichent la forme courte `bash jeu.sh ...`, qui s’utilise depuis `hedy` : adapte le chemin à ta position.

| Ta position | Rappeler la mission | Vérifier |
|---|---|---|
| `hedy/` | `bash jeu.sh mission` | `bash jeu.sh verifier` |
| `hedy/partie_XXXXXX/` | `bash ../jeu.sh mission` | `bash ../jeu.sh verifier` |
| `hedy/partie_XXXXXX/resultat/` | `bash ../../jeu.sh mission` | `bash ../../jeu.sh verifier` |

Pour suivre le manuel facilement, reste à la racine de la partie. `pwd` affiche ta position et `cd ..` remonte d’un dossier.

## 🎯 Les quatre épreuves

| Épreuve | Objectif | Notions travaillées |
|---|---|---|
| 1. Les clés du département | Retrouver un compte rendu caché et relever le code du casier | `ls -a`, `cat`, écriture dans un fichier |
| 2. Le hall encombré | Déplacer les trois chaises dans la réserve, en laissant le routeur en place | Chemins, `mv`, différence avec `cp` |
| 3. Le réseau | Extraire la ligne de réactivation du journal | `grep`, redirection `>` |
| 4. Le site du département | Modifier la situation dans la page HTML, puis la copier dans le site local | Éditeur de texte, `cp` |

La vérification contrôle le résultat dans les fichiers. Une mauvaise réponse ne fait pas perdre la partie : corrige-la puis relance `verifier`.

## 📖 Manuel

[**Consulter le manuel PDF — 4 pages**](docs/Guide_Operation_Hedy.pdf)

Il contient le scénario, les instructions de démarrage, les commandes expliquées et les solutions sur la dernière page. Pour le télécharger depuis GitHub, ouvre le PDF puis utilise le bouton de téléchargement du fichier.

## 🔄 Reprendre ou recommencer

Pour reprendre après avoir fermé le terminal, retourne dans `hedy` puis lance :

```bash
bash jeu.sh mission
```

Le fichier `.partie_active` conserve le chemin de la dernière partie créée et `etape.txt` sa progression. Entre de nouveau dans ce dossier pour effectuer les manipulations. Évite de déplacer le dossier du jeu en cours de partie : le chemin mémorisé est absolu.

Pour recommencer, depuis `hedy` :

```bash
bash jeu.sh nouveau
```

Un nouveau dossier est créé ; les anciennes parties sont conservées. Seule la dernière partie créée est utilisée par `mission` et `verifier`. Ne modifie pas `etape.txt` pour progresser : c’est le programme qui le met à jour.

## 🛠️ Dépannage

### « jeu.sh : aucun fichier ou dossier de ce nom »

Vérifie ta position avec `pwd`, puis utilise le chemin approprié dans le tableau ci-dessus.

### La dernière mission ne se valide pas

Le code vérifie exactement cette ligne, **sans espace avant ou après** :

```html
<p>Situation : DEBLOQUEE</p>
```

Conserve la balise `</p>`, enregistre le fichier et recopie-le dans `site_local/` après chaque modification. Les deux fichiers doivent être identiques. Une page qui semble correcte dans le navigateur peut tout de même contenir un espace supplémentaire refusé par la vérification.

### Erreurs contenant `^M` ou `$'\r'`

Enregistre le script et les fichiers de réponse avec des fins de ligne **LF (Unix)**, pas CRLF (Windows).

### Pas de partie ou fichiers manquants

Lance d’abord `nouveau`. La gestion d’erreur est volontairement minimale pour garder le code accessible. Si les fichiers de la partie ont été supprimés ou déplacés, crée une nouvelle partie.

## 📁 Organisation du dépôt

- `hedy/jeu.sh` : code du jeu.
- `docs/Guide_Operation_Hedy.pdf` : manuel du joueur et solutions.
- `README.md` : présentation et démarrage.
- `.gitignore` : exclut les dossiers de partie et le fichier de partie active des commits.

Les dossiers `campus`, `hall`, `reserve`, `journaux`, `resultat` et `site_local` sont générés automatiquement à chaque nouvelle partie. Les parties personnelles ne sont pas incluses dans ce dépôt.

## À propos

Projet pédagogique de Gaël Boënnec — Télécommunications, INSA Lyon. Le script conserve sa version finale fournie par l’auteur, y compris ses commentaires. Le jeu vise la compréhension des commandes UNIX et du fonctionnement d’un script Bash ; il ne cherche pas à empêcher la lecture des solutions ou la modification des fichiers de progression.
