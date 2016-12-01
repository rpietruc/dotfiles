HISTSIZE=10000
HISTFILESIZE=20000

PATH="~/build/cling_2016-11-24_ubuntu16/bin:$PATH"

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
alias yu='sudo apt-get update && sudo apt-get upgrade'
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
function yl {
  dpkg-query -L "$1"
}

# cscope
function cscope_add {
  if [ -z "$1" ]; then
    echo "usage: cscope_add <include path>"
  else
    # Create a file which contains the list of files you wish cscope to index
    # (cscope can handle many languages but this example finds .c, .cpp and .h files, specific for C/C++ project): 
    find "$1" -type f -print | grep -E '\.(c(pp)?|h)$' >> cscope.files
    # Create database files that cscope will read:
    cscope -bq
  fi
}

function makefile_template {
  echo '# makefile template
CC=g++
CPPFLAGS=-std=c++11
LDFLAGS=
DEPS = main.h
OBJS = main.o
EXE = main

%.o: %.cpp $(DEPS)
	$(CC) -c -o $@ $< $(CPPFLAGS)

$(EXE): $(OBJS)
	$(CC) $(LDFLAGS) -o $@ $^ $(CPPFLAGS)

clean:
	rm -f $(EXE) $(OBJS)
  '
}

