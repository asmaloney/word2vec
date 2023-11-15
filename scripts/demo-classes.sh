#!/bin/sh

dir=${0%/*}
if [ -d "$dir" ]; then
  cd "$dir/.." || exit
fi

BIN_DIR=./bin
DATA_DIR=./data


# Get the data if we don't have it
if [ ! -e ${DATA_DIR}/text8 ]; then
  wget https://mattmahoney.net/dc/text8.zip -O ${DATA_DIR}/text8.zip
  unzip ${DATA_DIR}/text8.zip -d ${DATA_DIR}
fi

# Train the data and output classes if we haven't already
if [ ! -e ${DATA_DIR}/classes.txt ]; then
  time ${BIN_DIR}/word2vec \
      -train ${DATA_DIR}/text8 \
      -output ${DATA_DIR}/classes.txt \
      -cbow 1 \
      -size 200 \
      -window 8 \
      -negative 25 \
      -hs 0 \
      -sample 1e-4 \
      -threads 20 \
      -classes 500 \
      -iter 15

  sort ${DATA_DIR}/classes.txt -k 2 -n > ${DATA_DIR}/classes.sorted.txt
fi

echo The word classes were saved to file ${DATA_DIR}/classes.sorted.txt
