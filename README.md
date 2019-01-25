# nnhs

Yet another transcription of [dennybritz/nn-from-scratch](https://github.com/dennybritz/nn-from-scratch/blob/master/nn_from_scratch.py), but this time with [Haskell](https://stackoverflow.com/questions/775726/whats-the-fuss-about-haskell)!

Needed things
---
 - [Nix](https://nixos.org/nix/)

What to do
---
```bash
$ nix-shell
[nix-shell:~/nnhs]$ sh main.sh
```

Take the wheel
---
Data generation is handled by `input/data.py` by way of [sklearn.datasets.make_classication](https://scikit-learn.org/stable/modules/generated/sklearn.datasets.make_classification.html).

```python
params = \
    { "n_samples": 1000
    , "n_features": 20
    , "n_informative": 5
    , "n_redundant": 2
    , "n_repeated": 1
    , "n_classes": 2
    , "n_clusters_per_class": 2
    , "random_state": 2
    }
```

Model parameters are controlled over at `input/params.txt`.
```
10      number of hidden layers
0.01    lambda regularization
0.01    epsilon (...?)
1000    number of training iterations
50      number of observations in training dataset
2       random seed
```
