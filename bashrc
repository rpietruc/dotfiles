HISTSIZE=10000
HISTFILESIZE=20000

alias cp="cp -i"                          # confirm before overwriting something
alias df='df -h'                          # human-readable sizes
alias free='free -m'                      # show sizes in MB

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
alias yu='sudo apt-get update'
alias yc='sudo apt-get autoremove'
function yf {
  apt-cache search "$@"
}
function yr {
  sudo apt-get remove "$@"
}
function yi {
  sudo apt-get install "$@"
}

# vim
function vim_make_cproj {
  # Create a file which contains the list of files you wish cscope to index
  # (cscope can handle many languages but this example finds .c, .cpp and .h files, specific for C/C++ project): 
  find . -type f -print | grep -E '\.(c(pp)?|h)$' > cscope.files
  # Create database files that cscope will read:
  cscope -bq
}

