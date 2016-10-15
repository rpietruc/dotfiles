export HISTSIZE=10000
export HISTFILESIZE=${HISTSIZE}
export HISTCONTROL=ignoreboth
export PATH=~/build/bin:$PATH

alias ls='ls --group-directories-first --time-style=+"%d.%m.%Y %H:%M" --color=auto -F'
alias ll='ls -l --group-directories-first --time-style=+"%d.%m.%Y %H:%M" --color=auto -F'
alias la='ls -la --group-directories-first --time-style=+"%d.%m.%Y %H:%M" --color=auto -F'
alias grep='grep --color=tty -d skip'
alias cp="cp -i"                          # confirm before overwriting something
alias df='df -h'                          # human-readable sizes
alias free='free -m'                      # show sizes in MB

# prompt
PS1='[\u@\h \W]\$ '

# ex - archive extractor
# usage: ex <file>
ex ()
{
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1   ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *.iso)       bsdtar xzf $1;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# pacman
function mirrorlist_update {
	sudo perl -0777 -i.original -pe 's/Poland\n#Server/Poland\nServer/igs' /etc/pacman.d/mirrorlist.pacnew
	sudo mv /etc/pacman.d/mirrorlist.pacnew /etc/pacman.d/mirrorlist
}

# pacman
alias yu='yaourt -Syu'
function yr { pacman -Qqdt | sed ':a;N;$!ba;s/\n/ /g'; }
function yc { yaourt -R $(echo $(yr)); }
function pkg_ver { yaourt -Q "$1" | sed "s/\(.*\) \(1\?:\?\)\(.*\)-1/\3/"; }

# vim
function vim_make_cproj {
  # Create a file which contains the list of files you wish cscope to index
  # (cscope can handle many languages but this example finds .c, .cpp and .h files, specific for C/C++ project): 
  find . -type f -print | grep -E '\.(c(pp)?|h)$' > cscope.files
  # Create database files that cscope will read:
  cscope -bq
}

# activator
function act_new { activator new "$1" "$1"; }
export -f act_new
act_lst () { activator list-templates | grep "$@"; }

# sbt
function sbt_new {
    PROJECT_NAME=$(basename $(readlink -f .))
    PROJECT_VER="1.0-SNAPSHOT"
    SCALA_VER=$(pkg_ver scala)
    SBT_VER=$(pkg_ver sbt)
    echo -e "name := \"${PROJECT_NAME}\"\n" > build.sbt
    echo -e "version := \"${PROJECT_VER}\"\n" >> build.sbt
    echo -e "scalaVersion := \"${SCALA_VER}\"" >> build.sbt
    mkdir -p project
    echo -e "sbt.version=${SBT_VER}" > project/build.properties
}
function sbt_add {
    echo -e "\n" >> build.sbt
    lynx -dump "$1" | grep "libraryDependencies +=" >> build.sbt
}
alias sbt_add_scalaz='sbt_add https://github.com/scalaz/scalaz'

