# *🎉 Welcome to my terminal profile settings🎉*

---

 Here I have set many commands used across applications to my preference to make my workflow easier

---

### Files which I have included are:

* `bash_aliases` file, which includes:
    * `gitprompt` -  Alias for enabling gitprompt to check the status of my local **git** repository
    * `sync-system` -  Alias for updating my system's snap and apt repositories and cleaning up temporary files by running a single command
    * `bye` - Alias to update my system and turn it off. Useful for routine updates and updating before poweroff
    * `cleanup` - Alias for cleaning up my system's cache and unused apt packages
    * `env` - Aliases for activating conda environments
    * Aliases for entering psql as different users
* `system-sync` file, which includes the set of commands for the routine update
* `vimrc` file, which includes many `set` commands and **colortheme** to give a good experience of coding in **vim**
* `.tmux.conf` file, which enables one-based indexing and mouse usage in **tmux** 

---
## Setting Up Your Terminal

1. Clone the git repo to your computer in your home directory
```bash
cd ~
git clone git@github.com:ComputerExp/Terminal_Profile_Settings.git
```
2. Rename the folder as dotfiles using the command
```bash
mv /Terminal_Profile_Settings /dotfiles
```
3. cd into dotfiles and run the command
```bash
cd ~/dotfiles
chmod +x setup.sh
```
4. Before running the next command, if you already have certain aliases which you would like to move later on to the files save them in this same folder by running
```bash
mkdir -p ~/dotfiles/backup
cp ~/.bash_aliases ~/dotfiles/backup/bash_aliases
cp ~/.bashrc ~/dotfiles/backup/bashrc
cp ~/.vimrc ~/dotfiles/backup/vimrc
cp ~/.tmux.conf ~/dotfiles/backup/tmux.conf
```
5. Run
```bash
./setup.sh
```
You will receive a success message

6. If you have any additional commands which were present in the previous files copy them from the backup directory 

7. Create a file named **my_updates** (or any other name) in the **/etc/sudoers.d** directory
```bash
sudo touch /etc/sudoers.d/my_updates
```

8. Copy the file contents of [my_updates_sudoers](./my_updates_sudoers) in the current directory into the _my_updates_ file through visudo
```bash
sudo visudo /etc/sudoers.d/my_updates
```

9. Enjoy password-less updates in your system 😀



