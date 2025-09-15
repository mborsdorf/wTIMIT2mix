UNDER CONSTRUCTION

wTIMIT2mix: A Cocktail Party Mixtures Database to Study Target Speaker Extraction for Normal and Whispered Speech
---
wTIMIT2mix is a new cocktail party mixtures speech database for the purpose of developing speech separation models. It can be used for the blind source separation algorithm and the target speaker extraction algorithm. 
wTIMIT2mix provides cocktail party mixture signals of two overlapping voices, the respective single sources (ground truth signals), and reference signals of the target speakers. Both speakers in the cocktail party mixture signal always speak in the same speech mode, i.e. either normal speech or whispered speech. They change the speech mode simultaneously. Since the target speaker reference signal relies on the past-extracted speech signal of the target speaker in real-world application scenarions, the speech mode given in the target reference signal may or may not the speech mode given in the speech mixture signal (depending on whether or not both speakers have changed the speech mode since the last time frame). This leads to four TSE scenarios as follows:

1) $Normal$: Both the target reference signal and the mixture signal are given in normal speech mode.
2) $Whispered$: Both the target reference signal and the mixture signal are given in whispered speech mode.
3) $Mix_W-Ref_N$: While the target reference signal is given in normal speech, the voices in the mixture signal are given in whispered speech.
4) $Mix_N-Ref_W$: While the target reference signal is given in whispered speech, the voices in the mixture signal are given in normal speech.

The database consists of a training set, a validation set, a speaker-dependent (closed-set) test set, and a speaker-independent (open-set) test set. All the utterances for each speaker are given in both normal speech and whispered speech.
The training and the validation set share the same speakers but with different utterances. The utterances in both test sets are the same and different to the training and valdiation utterances. The speakers in the closed-set test set are the same as in the training and validation sets. The speakers in the open-set test set are different to the speakers in the training and validation sets.

## Procedure for the construction of wTIMIT2Mix

1) Please get the original wTIMIT speech database. You can request it by contacting B. P. Lim:
   > B. P. Lim, “Computational Differences Between Whispered and Non-whispered Speech,” PhD Thesis, UIUC, 2010.
2) Merge all speaker folders from both normal and whispered speech as well as from both Singaporean English and American English into one strucutre according to:
3) 
   /data/000/s000u036n.WAV
   
   /data/000/s000u036w.WAV
   
   ...
   
   /data/131/s131u447n.WAV
   
   /data/131/s131u447w.WAV
   
4) Clone this repository
5) A few samples from wTMIT are sorted out. The exact speaker and utterance information including the SNR values between speakers to simulate the wTIMIT2mix database are given in the folder **mixture_infos**.
6) The matlab scripts to simulate the actual cocktail party mixtures data and the contributing ground truth data are given in the folder **simulation_scripts**.
7) The data lists for training, validation, and testing are given in the folder **data_lists**. Please adjust the paths given in the files according to your system.
8) The file **wTIMIT2mix_extr_targets.spk** contains the speaker identities required for training and validation.

The wTIMIT2mix database is simulated as a "max version". That means, when mixing two utterances, the shorter one is padded with zeros to match the length of the longer one.


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
