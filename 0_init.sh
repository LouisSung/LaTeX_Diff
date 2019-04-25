# These scripts have been run via bash on both Ubuntu 18.04 LTS and Raspbian 9.8
echo -e "\e[1;36mSet Up Environment\e[0m"

# === Parameters ===
ASK='>>>'
READ='>>>'
EXECUTE='   $'
INDENT='   '
WARNING_MSG="\
$INDENT| In order to avoid typing username & password each time you push
$INDENT| You could chose to add ACCOUNT and ACCESS_TOKEN to your remote url
$INDENT| E.g., https://\e[1;33mACCOUNT:TOKEN\e[0m@github.com/LouisSung/LaTeX_Diff
$INDENT| \e[1;31mNOTE!\e[0m These information are stored in \e[1;32mplaintext\e[0m, so \e[1;31mNEVER EVER use Password\e[0m
$INDENT| Use \"Personal access tokens\" instead"

# === Function ===
ask(){
    while true; do
        read -ep "$READ $1" yn
        if [[ -z $yn ]]; then yn=$2; fi
        case $yn in
            [Yy] ) echo "y"; break;;
            [Nn] ) echo "n"; break;;
            * ) echo -e "$INDENT\e[1;31mErr:\e[0m Please answer y/n." >&2;;    # echo to stderr
        esac
    done
}

# === For Git config ===
echo "=== Git ==="
if [ $(ask "Reset user config (name and email)? [Y/n] " "Y") = "y" ]; then
	while true; do
	    read -ep "$READ Enter user name for git: " name; [[ ! -z $name ]] && break; done
	echo -e "$EXECUTE git config user.name \"$name\""
	git config user.name "$name"

	while true; do
	    read -ep "$READ Enter user email for git: " email; [[ ! -z $email ]] && break; done
	echo -e "$EXECUTE git config user.email $email"
	git config user.email $email
fi
if [ $(ask "Reset (origin) remote? [Y/n] " "Y") = "y" ]; then
    echo -e "$WARNING_MSG"
    while true; do
        read -ep "$READ Enter remote url: " remote; [[ ! -z $remote ]] && break; done
    echo -e "$EXECUTE git remote remove origin"
    git remote remove origin
    echo -e "$EXECUTE git remote add origin $remote"
    git remote add origin $remote
    
    if [ $(ask "Add secondary push remote? [y/N] " "N") = "y" ]; then
        while true; do
            read -ep "$READ Enter secondary remote url: " remote_2; [[ ! -z $remote_2 ]] && break; done
        echo -e "$EXECUTE git remote set-url origin --add --push $remote"
        git remote set-url origin --add --push  $remote
        echo -e "$EXECUTE git remote set-url origin --add --push $remote_2"
	git remote set-url origin --add --push  $remote_2
    fi
fi
if [ $(ask "Set other configs (git graph and pull --rebase)? [Y/n] " "Y") = "y" ]; then
        echo -e "$EXECUTE git config alias.graph"   # add command "git graph" to draw commit history
	# ref: https://stackoverflow.com/questions/1057564/pretty-git-branch-graphs
	git config alias.graph "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all"
	echo -e "$EXECUTE git config pull.rebase true"    # use "git pull --rebase" by default
	git config pull.rebase true
fi
# === For LaTeX ===
echo "=== LaTeX ==="
if [ $(ask "Install TexLive-Science (SW distribution for TeX)? [Y/n] " "Y") = "y" ]; then
    echo -e "$EXECUTE sudo apt install texlive-science"
    sudo apt install texlive-science; fi
if [ $(ask "Install Latexdiff (To generate diff PDFs)? [Y/n] " "Y") = "y" ]; then
    echo -e "$EXECUTE sudo apt install latexdiff"
    sudo apt install latexdiff; fi
if [ $(ask "Install Texmaker (An open-source LaTeX editor)? [Y/n] " "Y") = "y" ]; then
    echo -e "$EXECUTE sudo apt install texmaker"
    sudo apt install texmaker; fi
if [ $(ask "Install JabRef (An open-source BibTeX editor)? [Y/n] " "Y") = "y" ]; then
    echo -e "$EXECUTE sudo apt install jabref"
    sudo apt install jabref; fi
# === For Python ===
echo "=== Diff ==="
if [ $(ask "Install pip3 (The Python package installer)? [y/N] " "N") = "y" ]; then
    echo -e "$EXECUTE sudo apt install python3-pip"
    sudo apt install python3-pip; fi
if [ $(ask "Install Pipenv (Virtual environment for Python)? [y/N] " "N") = "y" ]; then
    echo -e "$EXECUTE pip3 install pipenv"
    python3 -m pip install --user pipenv; fi
# === For Pipenv init ===
if [ $(ask "Init pipenv (For gen_diff.py)? [Y/n] " "Y") = "y" ]; then
    echo -e "$EXECUTE pipenv install"
    cd diff/; python3 -m pipenv install; cd ../; fi

echo -e "\e[1;36mDone\e[0m"
