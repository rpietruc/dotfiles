HISTSIZE=10000
HISTFILESIZE=20000

alias ls='ls --group-directories-first --time-style=+"%d.%m.%Y %H:%M" --color=auto -F'
alias ll='ls -l --group-directories-first --time-style=+"%d.%m.%Y %H:%M" --color=auto -F'
alias la='ls -la --group-directories-first --time-style=+"%d.%m.%Y %H:%M" --color=auto -F'
alias grep='grep --color=tty -d skip'
alias cp="cp -i"                          # confirm before overwriting something
alias df='df -h'                          # human-readable sizes
alias free='free -m'                      # show sizes in MB
alias prettyjson='python -m json.tool'
alias git-aliases='git config --get-regexp alias'
alias scala-project='sbt new scala/hello-world.g8'
alias java-project='gradle init --type java-application' 
alias spring-project='curl https://start.spring.io/starter.tgz -d dependencies=web,actuator -d language=java -d type=gradle-project -d baseDir=spring-project | tar -xzvf -'
alias mvn-project='mvn archetype:generate'
alias emacs='emacs -nw'
alias vertx-project='mvn io.fabric8:vertx-maven-plugin:1.0.13:setup -DvertxVersion=3.5.2'

# ex - archive extractor
# usage: ex <file>
ex ()
{
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.tar.xz)    tar xJf $1   ;;
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

function yu {
  if $(which apt-get >/dev/null 2>&1); then sudo apt-get update && sudo apt-get upgrade;
  elif $(which yaourt >/dev/null 2>&1); then yaourt -Syu; fi
}
function ya { pacman -Qqdt | sed ':a;N;$!ba;s/\n/ /g'; }
function yc {
  if $(which apt-get >/dev/null 2>&1); then sudo apt-get autoremove;
  elif $(which yaourt >/dev/null 2>&1); then yaourt -R $(echo $(ya)); fi
}
function ys {
  if $(which apt-cache >/dev/null 2>&1); then apt-cache search "$@";
  elif $(which yaourt >/dev/null 2>&1); then yaourt "$@"; fi
}
function yr {
  if $(which apt-get >/dev/null 2>&1); then sudo apt-get remove "$@";
  elif $(which yaourt >/dev/null 2>&1); then yaourt -R "$@"; fi
}
function yi {
  if $(which apt-get >/dev/null 2>&1); then sudo apt-get install "$@";
  elif $(which yaourt >/dev/null 2>&1); then yaourt -S "$@"; fi
}
function yf {
    if [[ "$1" =~ \.rpm$ ]]; then
        rpm -Uvh "$1"; # --nodeps to force dependency conflict
    elif [[ "$1" =~ \.pkg.tar.xz$ ]]; then
        yaourt -U "$1";
    fi
}
function yl {
  if [[ "$1" =~ \.rpm$ ]]; then rpm -qlp "$1";
  elif $(which dpkg-query >/dev/null 2>&1); then dpkg-query -L "$@";
  elif $(which yaourt >/dev/null 2>&1); then yaourt -Ql "$@";
  else rpm -ql "$1";
  fi
}
function yo {
  if $(which dpkg >/dev/null 2>&1); then dpkg -S "$1";
  elif $(which yaourt >/dev/null 2>&1); then yaourt -Qo "$1";
  else rpm -qf "$1";
  fi
}
function yg {
  if $(which apt-get >/dev/null 2>&1); then apt-get source "$1";
  elif $(which yaourt >/dev/null 2>&1); then yaourt -G "$1"; fi
}
function pkg_ver { yaourt -Q "$1" | sed "s/\(.*\) \(1\?:\?\)\(.*\)-1/\3/"; }

# pacman
function mirrorlist_update {
  if [ -f /etc/pacman.d/mirrorlist.pacnew ]; then
    sudo perl -0777 -i.original -pe 's/Poland\n#Server/Poland\nServer/igs' /etc/pacman.d/mirrorlist.pacnew
    sudo mv /etc/pacman.d/mirrorlist.pacnew /etc/pacman.d/mirrorlist
  fi
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

#
# makefile templates
#

function makemake {
  cat << "EOF"
CC=g++
LD=${CC}
INCLUDES=
CFLAGS=-g
LDFLAGS=-g
SRCS=
OBJS=$(SRCS:.cpp=.o)
TEST_SRCS=
TEST_OBJS=$(TEST_SRCS:.cpp=.o)
TESTS=

all: main $(TESTS)

test: $(TESTS)
	@for f in $(TESTS) ; do \
		echo Running $$f ; \
		./$$f ; \
		echo ; \
		done

%.o:%.cpp
	$(CC) $(CFLAGS) $(INCLUDES) -c $< -o $@

main: src/main.o ${OBJS}
	${LD} -o $@ src/main.o ${OBJS} ${LDFLAGS}

clean:
	rm -f ${OBJS} src/main.o main ${TEST_OBJS} test/test_main.o ${TESTS}
EOF
}

#
# main templates
#

function c_main {
  cat << EOF
#include <stdio.h>

int main(int argc, char *argv[])
{
    printf("\n");
    return 0;
}
EOF
}

function cpp_main {
  cat << EOF
#include <iostream>

auto main(int argc, char *argv[]) -> int
{
    using namespace std;
    cout << endl;
    return 0;
}
EOF
}

#
# c++ class templates
#

function cpp_header {
  if [ -z "$1" ]; then
    echo "usage: cpp_header <class_name>"
  else
    cat << EOF
#ifndef ${1^^}_H
#define ${1^^}_H

class $1
{
public:
    explicit $1();
    virtual ~$1();
};

#endif // ${1^^}_H
EOF
  fi
}

function cpp_source {
  if [ -z "$1" ]; then
    echo "usage: cpp_source <class_name>"
  else
    cat << EOF
#include "${1,,}.h"

$1::$1()
{
}

$1::~$1()
{
}
EOF
  fi
}

#
# c struct templates
#

function c_header {
  if [ -z "$1" ]; then
    echo "usage: c_header <struct_name>"
  else
    cat << EOF
#ifndef ${1^^}_H
#define ${1^^}_H

struct _$1;
typedef struct _$1 T$1;

#if defined(__cplusplus) || defined(__cplusplus__)
extern "C" {
#endif

  T$1* ${1,,}_create();
  void ${1,,}_free(T$1 *self);

#if defined(__cplusplus) || defined(__cplusplus__)
}
#endif

#endif /* ${1^^}_H */
EOF
  fi
}

function c_source {
  if [ -z "$1" ]; then
    echo "usage: c_source <struct_name>"
  else
    cat << EOF
#include "${1,,}.h"
#include <stdlib.h>

struct _$1 {
};

T$1* ${1,,}_create()
{
  T$1* self = (T$1*)malloc(sizeof(T$1));
  if (self) {
  }
  return self;
}

void ${1,,}_free(T$1 *self)
{
  free(self);
}
EOF
  fi
}

#
# test templates
#

function check_main {
  cat << EOF
#include <check.h>
#include <stdlib.h>

int main(void)
{
  Suite *suites[] = {
  };
  SRunner *sr = 0;
  for (int i = 0; i < sizeof(suites)/sizeof(suites[0]); ++i) {
    if (i == 0)
      sr = srunner_create(suites[0]);
    else
      srunner_add_suite(sr, suites[i]);
  }
  int n = 0;
  if (sr) {
    srunner_run_all(sr, CK_VERBOSE);
    n = srunner_ntests_failed(sr);
    srunner_free(sr);
  }
  return (n == 0) ? EXIT_SUCCESS : EXIT_FAILURE;
}
EOF
}

function check_header {
  if [ -z $1 ]; then
    echo "usage: check_header <struct_name>"
  else
    cat << EOF
#ifndef CHECK_${1^^}_H
#define CHECK_${1^^}_H

#include <check.h>

#if defined(__cplusplus) || defined(__cplusplus__)
extern "C" {
#endif

Suite *make_$1_suite(void);

#if defined(__cplusplus) || defined(__cplusplus__)
}
#endif

#endif /* ${1^^}_H */
EOF
  fi
}

function check_source {
  if [ "$#" -ne 2 ]; then
    echo "usage: check_source <struct_name> <test_name>"
  else
    cat << EOF
#include "check_${1,,}.h"
#include "${1,,}.h"
#include <assert.h>

START_TEST(test_$2)
{
  T$1 *self = ${1,,}_create();
  ck_assert_msg(0 == 1, "Test should be defined");
  ${1,,}_free(self);
}
END_TEST

Suite *make_$1_suite(void)
{
  Suite *s = suite_create("$1 Suite");
  TCase *tc = tcase_create("Core");

  suite_add_tcase(s, tc);
  tcase_add_test(tc, test_$2);

  return s;
}
EOF
  fi
}

function test_main {
  cat << EOF
#define BOOST_TEST_DYN_LINK
#define BOOST_TEST_MODULE Main
#include <boost/test/unit_test.hpp>
#include "${1,,}.h"

BOOST_AUTO_TEST_CASE(test_$1)
{
    BOOST_CHECK_MESSAGE(0 == 1, "Test should be defined");
}
EOF
}

#
# adding objects
#

function c_new {
  if [ -z $1 ]; then
    echo "usage: c_new <struct_name> [<test_name> [<header_dir> [<source_dir>]]]"
  else
    file_h=${1,,}.h
    if [ ! -z $3 ]; then
      mkdir $3 >/dev/null 2>&1 && sed -i "/^INCLUDES=/ s/\$/ -I$3/" Makefile
      file_h=$3/$file_h
    fi
    file_c=${1,,}.c
    if [ ! -z $4 ]; then
      mkdir -p $4
      file_c=$4/$file_c
    fi
    if [ ! -f $file_h ]; then c_header $1 > $file_h; fi
    if [ ! -f $file_c ]; then c_source $1 > $file_c; fi
    sed -i "s|\(^SRCS=.*\)|\1 $file_c|" Makefile
    if [ ! -z $2 ]; then
      mkdir -p test
      if [ ! -f test/check_${1,,}.h ]; then check_header $1 > test/check_${1,,}.h; fi
      if [ ! -f test/check_${1,,}.c ]; then check_source $1 $2 > test/check_${1,,}.c; fi
      sed -i "/^TEST_SRCS/ s/\$/ test\/check_${1,,}.c/" Makefile
      sed -i "/include.*stdlib.h/a #include \"check_${1,,}.h\"" test/test_main.c
      sed -i "/^.*Suite.*suites.*= { / s/\$/, make_$1_suite()/" test/test_main.c
      sed -i "/^.*Suite.*suites.*= {\$/ s/\$/ make_$1_suite()/" test/test_main.c
    fi
  fi
}

function test_new {
  if [ -z $1 ]; then
    echo "usage: test_new <class_name>"
  else
    sed -i "/^TESTS=/ s/\$/ test_${1,,}/" Makefile
    printf '\n%s: %s ${TEST_OBJS} ${OBJS}\n\t${LD} -o $@ %s ${TEST_OBJS} ${OBJS} ${LDFLAGS}\n' \
      test_${1,,} test/test_${1,,}.o test/test_${1,,}.o >> Makefile
  fi
}

function cpp_new {
  if [ -z $1 ]; then
    echo "usage: cpp_new <class_name> [<header_dir> [<source_dir>]]"
  else
    file_h=${1,,}.h
    if [ ! -z $2 ]; then
      mkdir $2 >/dev/null 2>&1 && sed -i "/^INCLUDES=/ s/\$/ -I$2/" Makefile
      file_h=$2/$file_h
    fi
    file_cpp=${1,,}.cpp
    if [ ! -z $3 ]; then
      mkdir -p $3
      file_cpp=$3/$file_cpp
    fi
    if [ ! -f "$file_h" ]; then cpp_header $1 > "$file_h"; fi
    if [ ! -f "$file_cpp" ]; then cpp_source $1 > $file_cpp; fi
    sed -i "s|\(^SRCS=.*\)|\1 $file_cpp|" Makefile
    mkdir -p test
    if [ ! -f test/test_${1,,}.cpp ]; then
      test_main $1 > test/test_${1,,}.cpp;
      echo "/test_${1,,}" >> .gitignore
    fi
    test_new $1
  fi
}

#
# project templates
#

function c_project {
  echo "*.o" >> .gitignore
  if [ ! -f Makefile ]; then makemake > Makefile; fi
  mkdir -p src
  if [ ! -f src/main.c ]; then c_main > src/main.c; fi
  echo "/main" >> .gitignore
  mkdir -p test
  if [ ! -f test/test_main.c ]; then
    check_main > test/test_main.c;
    echo "/test_main" >> .gitignore
  fi
  test_new main
  sed -i 's/CC=g++/CC=gcc/' Makefile
  sed -i "s/.cpp/.c/" Makefile
  sed -i '/^LDFLAGS=/ s/$/ $(shell pkg-config --libs check)/' Makefile
  if [ ! -z $1 ]; then
    c_new $1 create include src
  fi
}

function cpp_project {
  echo "*.o" >> .gitignore
  if [ ! -f Makefile ]; then makemake > Makefile; fi
  mkdir -p src
  if [ ! -f src/main.cpp ]; then cpp_main > src/main.cpp; fi
  echo "/main" >> .gitignore
  sed -i "/^LDFLAGS=/ s/\$/ -lboost_unit_test_framework/" Makefile
  sed -i "/^CFLAGS=/ s/\$/ -std=c++11/" Makefile
  if [ ! -z $1 ]; then
    cpp_new $1 include src
  fi
}
