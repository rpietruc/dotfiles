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
function yu {
  if $(which apt-get >/dev/null); then sudo apt-get update && sudo apt-get upgrade;
  elif $(which yaourt >/dev/null);  then yaourt -Syu; fi
}
function ya { pacman -Qqdt | sed ':a;N;$!ba;s/\n/ /g'; }
function yc {
  if $(which apt-get >/dev/null); then sudo apt-get autoremove;
  elif $(which yaourt >/dev/null);  then yaourt -R $(echo $(ya)); fi
}
alias yc='sudo apt-get autoremove'
function yf {
  if $(which apt-cache >/dev/null); then apt-cache search "$@";
  elif $(which yaourt >/dev/null);  then yaourt "$@"; fi
}
function yr {
  if $(which apt-get >/dev/null); then sudo apt-get remove "$@";
  elif $(which yaourt >/dev/null);  then yaourt -R "$@"; fi
}
function yi {
  if $(which apt-get >/dev/null); then sudo apt-get install "$@";
  elif $(which yaourt >/dev/null);  then yaourt -S "$@"; fi
}
function yl {
  if $(which dpkg-query >/dev/null); then dpkg-query -L "$@";
  elif $(which yaourt >/dev/null);  then yaourt -Ql "$@"; fi
}
function yo { yaourt -Qo "$1"; }
function pkg_ver { yaourt -Q "$1" | sed "s/\(.*\) \(1\?:\?\)\(.*\)-1/\3/"; }

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

