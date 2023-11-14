# word2vec

This is a fork of [the original word2vec](https://github.com/tmikolov/word2vec) by Tomas Mikolov.

The main changes are as follows:

- fix compilation on macOS
- fix several memory leaks
- apply [a fix](https://github.com/tmikolov/word2vec/pull/39) from the main repo PRs
- reorganize the repo into directories
- clean up the scripts & don't automatically retrain data
- clang-format the code

## Building

I've only built it on macOS, but it should work on Linux as well.

```
% make
gcc ./src/word2vec.c -o ./bin/word2vec -lm -pthread -O3 -march=native -Wall -funroll-loops -Wno-unused-result
gcc ./src/word2phrase.c -o ./bin/word2phrase -lm -pthread -O3 -march=native -Wall -funroll-loops -Wno-unused-result
gcc ./src/distance.c -o ./bin/distance -lm -pthread -O3 -march=native -Wall -funroll-loops -Wno-unused-result
gcc ./src/word-analogy.c -o ./bin/word-analogy -lm -pthread -O3 -march=native -Wall -funroll-loops -Wno-unused-result
gcc ./src/compute-accuracy.c -o ./bin/compute-accuracy -lm -pthread -O3 -march=native -Wall -funroll-loops -Wno-unused-result
```

It will put the executables in the `bin` directory.

## Running

There are several demos in the scripts directory. Each of them will download the data they need to the `data` directory and run an example. Take a look at the scripts to see how they work. (The "big model" one hasn't been fixed for the new file layout yet.)

Example:

```
% ./scripts/demo-phrases.sh

<...data downloading progress...>

Starting training using file ./data/news.2012.en.shuffled-norm0
Words processed: 296M     Vocab size: 33133K
Vocab size (unigrams + bigrams): 18838711
Words in train file: 296901342
Words written: 296M
real	3m11.759s
user	3m0.623s
sys	0m5.546s
Starting training using file ./data/news.2012.en.shuffled-norm0-phrase0
Words processed: 280M     Vocab size: 38715K
Vocab size (unigrams + bigrams): 21728781
Words in train file: 280513979
Words written: 280M
real	3m0.606s
user	2m48.924s
sys	0m5.841s
Starting training using file ./data/news.2012.en.shuffled-norm1-phrase1
Vocab size: 681320
Words in train file: 283545447
Alpha: 0.002334  Progress: 95.33%  Words/thread/sec: 150.82k
real	30m45.654s
user	446m15.739s
sys	2m14.087s
Enter word or sentence (EXIT to break): phrase

Word: phrase  Position in vocabulary: 4437

                                              Word       Cosine distance
------------------------------------------------------------------------
                                              word		0.801410
                                             words		0.755938
                                           phrases		0.738470
                                         adjective		0.656568
                                             quote		0.612604
                                            adverb		0.611929
                                      common_usage		0.600758
                                          aphorism		0.598873
                                        pejorative		0.591596
                                             slang		0.586171
                                     prepositional		0.586160
                                            mantra		0.579630
                                           lexicon		0.577740
                                            slogan		0.576222
                                           epithet		0.575722
                                        adjectives		0.572316
                                       catchphrase		0.572061
                                           uttered		0.570064
                                          metaphor		0.566445
                                              verb		0.557801
                                       terminology		0.555637
                                         quotation		0.549663
                                          syllable		0.548051
                                      catch_phrase		0.546580
                                     term_romnesia		0.545465
                                        neologisms		0.541982
                                         utterance		0.540865
                                        dictionary		0.535510
                                         shorthand		0.535362
                                      yiddish_word		0.532841
                                 rhetorical_device		0.532453
                                          language		0.531050
                         oxford_english_dictionary		0.531029
                                             clich		0.526269
                                  memorable_phrase		0.525383
                                         reference		0.524749
                                             verse		0.524645
                                           refrain		0.523493
                                        swear_word		0.522884
                                           pronoun		0.521555
Enter word or sentence (EXIT to break): computer

Word: computer  Position in vocabulary: 1922

                                              Word       Cosine distance
------------------------------------------------------------------------
                                         computers		0.817271
                                          software		0.712940
                                            laptop		0.680752
                                        computer's		0.654755
                                        keystrokes		0.636880
                                        electronic		0.618771
                                            server		0.613043
                                     mobile_device		0.607748
                                            device		0.607426
                                           spyware		0.605617
                                    malicious_code		0.604674
                                       thumb_drive		0.597072
                                 tracking_software		0.594464
                                              user		0.590326
                                         automated		0.590318
                                           desktop		0.587996
                                        computers'		0.585649
                                  desktop_computer		0.584500
                                               web		0.582986
                                           malware		0.582174
                                        usb_drives		0.580727
                                  computer_servers		0.580529
                                         usb_drive		0.580131
                                           servers		0.578256
                                   word_processing		0.575762
                                  take_screenshots		0.572279
                                      mobile_phone		0.571906
                                       flash_drive		0.571705
                                           devices		0.569640
                                   laptop_computer		0.569629
                                         pdf_files		0.567755
                                        encryption		0.565766
                                           encrypt		0.562853
                                       web_servers		0.561529
                                           via_usb		0.561428
                                     remote_server		0.560288
                               internet_connection		0.559574
                                  machine_learning		0.559485
                                  handheld_devices		0.558564
                                         cellphone		0.558308
Enter word or sentence (EXIT to break): EXIT
```

## Original README

### Tools for computing distributed representation of words

We provide an implementation of the Continuous Bag-of-Words (CBOW) and the Skip-gram model (SG), as well as several demo scripts.

Given a text corpus, the word2vec tool learns a vector for every word in the vocabulary using the Continuous Bag-of-Words or the Skip-Gram neural network architectures. The user should to specify the following:

- desired vector dimensionality
- the size of the context window for either the Skip-Gram or the Continuous Bag-of-Words model
- training algorithm: hierarchical softmax and / or negative sampling
- threshold for downsampling the frequent words
- number of threads to use
- the format of the output word vector file (text or binary)

Usually, the other hyper-parameters such as the learning rate do not need to be tuned for different training sets.

The script demo-word.sh downloads a small (100MB) text corpus from the web, and trains a small word vector model. After the training is finished, the user can interactively explore the similarity of the words.

More information about the scripts is provided at https://code.google.com/p/word2vec/
