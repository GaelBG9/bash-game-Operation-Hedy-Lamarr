# Operation Hedy Lamarr

**A Bash puzzle game for learning UNIX commands**, created as part of the PIT project at INSA Lyon.

The Telecommunications department building has been blocked for several weeks: students are demanding a working coffee machine. An agreement has finally been reached, but reopening the building still requires some work. Find the keys, clear the hallway, restore Internet access, and update the department's webpage!

Locations are directories, while objects and clues are files. You play directly in the terminal using real UNIX commands.

- **Game language:** French.
- **Estimated playtime:** 10–20 minutes.
- **Level:** beginner, with a manual to help you.
- **Operation:** entirely local; no Internet connection required during the game.

> This is an educational fictional scenario. The network and website are simulated. The game does not modify the actual network or the INSA website.

## Download

### Without Git — the simplest option

1. [Download the main branch as a ZIP](https://github.com/GaelBG9/bash-game-Operation-Hedy-Lamarr/archive/refs/heads/main.zip), or click **Code → Download ZIP**.
2. Extract the archive using “Extract All” or your archive manager.
3. Open the extracted directory, then the `hedy` subdirectory containing `jeu.sh`.
4. Open a **Linux or WSL terminal** in that directory. Do not run the game directly from inside the archive.

### With Git

```bash
git clone https://github.com/GaelBG9/bash-game-Operation-Hedy-Lamarr.git
cd bash-game-Operation-Hedy-Lamarr/hedy
```

## Requirements

- A **GNU/Linux** environment, such as Debian or Ubuntu, or **Ubuntu on WSL** for Windows.
- **Bash** and standard utilities: `mktemp`, `dirname`, `mkdir`, `touch`, `cat`, `ls`, `mv`, `cp`, `grep`, and `cmp` (usually already installed).
- A text editor: `nano`, `vi`, or another editor that preserves UTF-8 encoding and LF line endings.
- A browser is optional for viewing the final HTML page.

No Python libraries, web server, or administrator privileges are needed to play. Use `bash`, not `sh`. PowerShell and the Windows Command Prompt are not Bash interpreters.

**On Windows with WSL already installed:** open Ubuntu/WSL and navigate to the extracted directory. For example, replacing the username and path as needed:

```bash
cd "/mnt/c/Users/YOUR_NAME/Downloads/bash-game-Operation-Hedy-Lamarr-main/hedy"
```

If you do not have WSL, use your course's Linux environment or install WSL/Ubuntu before playing. The game does not download any additional packages.

## Start a game

From the `hedy` directory:

```bash
bash jeu.sh nouveau
```

The game creates a `partie_XXXXXX` directory, prepares all the files, and displays the session's path. Navigate to **the actual path displayed**:

```bash
cd "/displayed/path/partie_XXXXXX"
```

You can now explore, read clues, move objects, and fill in the answer files already provided in `resultat/`.

### Show or check a mission

From the **root of your session directory**:

```bash
bash ../jeu.sh mission
bash ../jeu.sh verifier
```

The script is one directory above, hence `../jeu.sh`. The script's messages display the shorter form `bash jeu.sh ...`, which works from `hedy`: adjust the path to your current location.

| Current directory | Show the mission | Check your answer |
|---|---|---|
| `hedy/` | `bash jeu.sh mission` | `bash jeu.sh verifier` |
| `hedy/partie_XXXXXX/` | `bash ../jeu.sh mission` | `bash ../jeu.sh verifier` |
| `hedy/partie_XXXXXX/resultat/` | `bash ../../jeu.sh mission` | `bash ../../jeu.sh verifier` |

To follow the manual easily, stay at the root of your session directory. `pwd` displays your location, and `cd ..` moves up one directory.

## The four challenges

| Challenge | Objective | Skills |
|---|---|---|
| 1. The department keys | Find hidden meeting minutes and retrieve the locker code | `ls -a`, `cat`, writing to a file |
| 2. The blocked hallway | Move the three chairs into storage while leaving the router in place | Paths, `mv`, differences from `cp` |
| 3. The network | Extract the reactivation line from the log | `grep`, `>` redirection |
| 4. The department website | Update the status in the HTML page, then copy it to the local site | Text editor, `cp` |

The checker examines the resulting files. An incorrect answer does not end the game: fix it and run `verifier` again.

## Manual

[**Read the PDF manual — 4 pages, in French**](docs/Guide_Operation_Hedy.pdf)

It includes the story, startup instructions, command explanations, and solutions on the last page. To download it from GitHub, open the PDF and use the file's download button.

## Resume or restart

To resume after closing the terminal, return to `hedy` and run:

```bash
bash jeu.sh mission
```

The `.partie_active` file stores the path to the most recently created session, and `etape.txt` stores its progress. Enter that session directory again to carry out the tasks. Avoid moving the game directory during a session: the saved path is absolute.

To restart, run this from `hedy`:

```bash
bash jeu.sh nouveau
```

A new directory is created, and previous sessions are kept. Only the most recently created session is used by `mission` and `verifier`. Do not edit `etape.txt` to advance: the program updates it.

## Troubleshooting

### “jeu.sh: No such file or directory”

Check your location with `pwd`, then use the appropriate path from the table above.

### The final mission will not validate

The code checks for this exact line, **with no leading or trailing spaces**:

```html
<p>Situation : DEBLOQUEE</p>
```

Keep the closing `</p>` tag, save the file, and copy it into `site_local/` after every change. Both files must be identical. A page that looks correct in a browser may still contain an extra space rejected by the checker.

### Errors containing `^M` or `$'\r'`

Save the script and answer files with **LF (Unix)** line endings, not CRLF (Windows).

### No session or missing files

Run `nouveau` first. Error handling is intentionally minimal to keep the code approachable. If session files have been deleted or moved, start a new game.

## Repository structure

- `hedy/jeu.sh`: game code.
- `docs/Guide_Operation_Hedy.pdf`: player manual and solutions.
- `README.md`: overview and getting started.
- `.gitignore`: excludes session directories and the active-session file from commits.

The `campus`, `hall`, `reserve`, `journaux`, `resultat`, and `site_local` directories are generated automatically for each new game. Personal game sessions are not included in this repository.

Author: Gaël Boënnec
