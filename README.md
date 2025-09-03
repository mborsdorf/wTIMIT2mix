wTIMIT2mix: A Cocktail Party Mixtures Database to Study Target Speaker Extraction for Normal and Whispered Speech
---
wTIMIT2mix is a new cocktail party mixtures speech database for the purpose of developing speech separation models. It can be used for the blind source separation algorithm and the target speaker extraction algorithm. 
wTIMIT2mix provides cocktail party mixture signals of two overlapping voices, the respective single sources (ground truth signals), and reference signals of the target speakers. Both speakers in the cocktail party mixture signal always speak in the same speech mode, i.e. either normal speech or whispered speech. They change the speech mode simultaneously. Since the target speaker reference signal relies on the past-extracted speech signal of the target speaker in real-world application scenarions, the speech mode given in the target reference signal may or may not the speech mode given in the speech mixture signal (depending on whether or not both speakers have changed the speech mode since the last time frame). This leads to four TSE scenarios as follows:

1) $Normal$: Both the target reference signal and the mixture signal are given in normal speech mode.
2) $Whispered$: Both the target reference signal and the mixture signal are given in whispered speech mode.
3) $Mix_W-Ref_N$: While the target reference signal is given in normal speech, the voices in the mixture signal are given in whispered speech.
4) $Mix_N-Ref_W$: While the target reference signal is given in whispered speech, the voices in the mixture signal are given in normal speech.

The database consists of a training set, a validation set, a speaker-dependent (closed-set) test set, and a speaker-independent (open-set) test set.

## Procedure for the construction of wTIMIT2Mix

1) Please get the original wTIMIT speech database. You can request it by contacting B. P. Lim:
   > B. P. Lim, “Computational Differences Between Whispered and Non-whispered Speech,” PhD Thesis, UIUC, 2010.
2) 



## Our Paper
If you enjoyed working with our solution, please cite us:
```
@inproceedings{borsdorf24_interspeech,
  title     = {{wTIMIT2mix: A Cocktail Party Mixtures Database to Study Target Speaker Extraction for Normal and Whispered Speech}},
  author    = {Marvin Borsdorf and Zexu Pan and Haizhou Li and Tanja Schultz},
  year      = {2024},
  booktitle = {{Interspeech 2024}},
  pages     = {5038--5042},
  doi       = {10.21437/Interspeech.2024-1172},
  issn      = {2958-1796}}
```
