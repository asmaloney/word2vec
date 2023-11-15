#!/bin/sh

dir=${0%/*}
if [ -d "$dir" ]; then
  cd "$dir/.." || exit
fi

BIN_DIR=./bin
DATA_DIR=./data


# Get the data if we don't have it
if [ ! -e ${DATA_DIR}/news.2012.en.shuffled ]; then
  wget https://www.statmt.org/wmt14/training-monolingual-news-crawl/news.2012.en.shuffled.gz -O ${DATA_DIR}/news.2012.en.shuffled.gz
  gzip -f -k -d ${DATA_DIR}/news.2012.en.shuffled.gz

  sed -e "s/’/'/g" -e "s/′/'/g" -e "s/''/ /g" < ${DATA_DIR}/news.2012.en.shuffled | tr -c "A-Za-z'_ \n" " " > ${DATA_DIR}/news.2012.en.shuffled-norm0
fi

if [ ! -e ${DATA_DIR}/vectors-phrase.bin ]; then
  time ${BIN_DIR}/word2phrase \
    -train ${DATA_DIR}/news.2012.en.shuffled-norm0 \
    -output ${DATA_DIR}/news.2012.en.shuffled-norm0-phrase0 \
    -threshold 200 \
    -debug 2

  time ${BIN_DIR}/word2phrase \
    -train ${DATA_DIR}/news.2012.en.shuffled-norm0-phrase0 \
    -output ${DATA_DIR}/news.2012.en.shuffled-norm0-phrase1 \
    -threshold 100 \
    -debug 2

  tr A-Z a-z < ${DATA_DIR}/news.2012.en.shuffled-norm0-phrase1 > ${DATA_DIR}/news.2012.en.shuffled-norm1-phrase1

  time ${BIN_DIR}/word2vec \
    -train ${DATA_DIR}/news.2012.en.shuffled-norm1-phrase1 \
    -output ${DATA_DIR}/vectors-phrase.bin \
    -cbow 1 \
    -size 200 \
    -window 10 \
    -negative 25 \
    -hs 0 \
    -sample 1e-5 \
    -threads 20 \
    -binary 1 \
    -iter 15
fi

${BIN_DIR}/compute-accuracy ${DATA_DIR}/vectors-phrase.bin < ${DATA_DIR}/questions-phrases.txt
