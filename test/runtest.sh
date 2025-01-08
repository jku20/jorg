#!/bin/sh

set -eu

COMMAND=$1
BASE=$2
INP=$BASE.inp
OUT=$BASE.out
EXP=$BASE.exp
DIFF=${DIFF:-diff -u}

if ! test -f "$INP" ; then
  INP=/dev/null
fi

testcmd() {
  ./"$BASE" < "$INP" > "$OUT" && 
    $DIFF "$OUT" "$EXP" && 
    rm -f "$OUT"
}

gencmd() {
  ./"$BASE" < "$INP" > "$OUT" && 
    cat $OUT > $EXP && 
    rm -f "$OUT"
}

case $COMMAND in 
  test) testcmd ;;
  gen) gencmd ;;
esac
