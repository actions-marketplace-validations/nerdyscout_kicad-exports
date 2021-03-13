#!/bin/sh

CONFIG="config/$(basename ${1%.sh})"
SCHEMATIC="$(find $TESTDATA -name *.sch)"
BOARD="$(find $TESTDATA -name *.kicad_pcb)"
DIR="test_data/out"

oneTimeSetUp() {
  ./kicad-exports -v -c $CONFIG -d $DIR -e $SCHEMATIC -b $BOARD
}

oneTimeTearDown() {
  if [ $CI ]; then
    sudo rm -r $DIR
  else
    rm -r $DIR
  fi
}

#########################

FILE="$DIR/docs/bom/test-bom.xlsx"

# file exists
testFileGenerated() {
  assertTrue "file does not exist" "[ -r $FILE ]"
}

# file updated
testFileUpdated() {
  SYSTEM_DATE=$(date +%y%m%d)
  FILE_DATE=$(date -r $FILE +%y%m%d)
  assertEquals "file has not been updated" "$SYSTEM_DATE" "$FILE_DATE"
}
