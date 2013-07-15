#!/usr/bin/env python2

import scipy.io
import warnings

from nltk.corpus import wordnet
from collections import defaultdict

TARGET_INDEX_FILE = 'vectors/tTest/targetIndex.txt'

indices = {}
test_pairs = set()
train_dist_pairs = []

with open(TARGET_INDEX_FILE) as index_file:
  for line in index_file:
    idx, string = line.strip().split('\t', 1)
    indices[string] = int(idx) + 1

scores = []
nouns1 = []
adjs1 = []
nouns2 = []
adjs2 = []

with open('eval/sim10') as pair_file:
  for line in pair_file:
    user, kind, unk, w11, w12, w21, w22, score = line.split()
    if kind != 'adjectivenouns':
      continue

    assert w11 in indices and w12 in indices and w21 in indices and \
        w22 in indices

    i11 = indices[w11]
    i12 = indices[w12]
    i21 = indices[w21]
    i22 = indices[w22]

    score = float(score)
    scores.append(score)
    adjs1.append(i11)
    nouns1.append(i12)
    adjs2.append(i21)
    nouns2.append(i22)

    test_pairs.add((i11, i12))
    test_pairs.add((i21, i22))

with open(TARGET_INDEX_FILE) as index_file:
  for line in index_file:
    pair = line.strip().split('\t')[1]
    if ' ' not in pair:
      continue
    w1, w2 = pair.split()
    i1 = indices[w1]
    i2 = indices[w2]
    if (i1, i2) in test_pairs:
      continue
    train_dist_pairs.append([i1, i2, indices[pair]])

synset_groups = defaultdict(list)
selected_pairs = set()
train_syn_pairs = []
with open(TARGET_INDEX_FILE) as index_file:
  for line in index_file:
    parts = line.split()
    if len(parts) != 3:
      continue
    adj, noun = line.split()[1:3]

    for adj_synset in wordnet.synsets(adj, pos=wordnet.ADJ):
      for noun_synset in wordnet.synsets(noun, pos=wordnet.NOUN):
        synset_groups[adj_synset, noun_synset].append((adj, noun))

  provisional_pairs = set()
  for key, word_pairs in synset_groups.items():
    if len(word_pairs) == 1:
      continue
    provisional_pairs.add(frozenset(word_pairs))

  for group in provisional_pairs:
    if not any(group != other and group <= other for other in provisional_pairs):
      selected_pairs.add(group)

  for group in selected_pairs:
    synset = []
    for adj, noun in group:
      synset.append([indices[adj], indices[noun]])
    train_syn_pairs.append(synset)
    #print ', '.join([' '.join(words) for words in sorted(group)])

with warnings.catch_warnings():
  warnings.simplefilter('ignore')
  scipy.io.savemat('eval/sim10.mat', mdict={'adjs1': adjs1,
                                            'nouns1': nouns1,
                                            'adjs2': adjs2,
                                            'nouns2': nouns2,
                                            'scores': scores})
  scipy.io.savemat('eval/train_dist_pairs.mat', mdict={'dist_pairs': train_dist_pairs})
  scipy.io.savemat('eval/train_sim_pairs.mat', mdict={'sim_pairs': train_syn_pairs})
