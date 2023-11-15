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

# Train the data if we haven't already
if [ ! -e ${DATA_DIR}/vectors.bin ]; then
  time ${BIN_DIR}/word2vec \
      -train ${DATA_DIR}/text8 \
      -output ${DATA_DIR}/vectors.bin \
      -cbow 1 \
      -size 200 \
      -window 8 \
      -negative 25 \
      -hs 0 \
      -sample 1e-4 \
      -threads 20 \
      -binary 1 \
      -iter 15
fi

echo ---------------------------------------------------------------------------------------------------
echo Note that for the word analogy to perform well, the model should be trained on much larger data set
echo Example input: paris france berlin
echo ---------------------------------------------------------------------------------------------------

${BIN_DIR}/word-analogy ${DATA_DIR}/vectors.bin
