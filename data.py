#!/usr/bin/env python3

import pandas as pd
import sklearn.datasets


if __name__ == "__main__":
    params = \
        { "n_samples": 1000
        , "n_features": 6
        , "n_informative": 2
        , "n_redundant": 2
        , "n_repeated": 1
        , "n_classes": 2
        , "n_clusters_per_class": 2
        , "random_state": 1
        }
    fn = "input/data.txt"

    data = sklearn.datasets.make_classification(**params)
    data = list(map(pd.DataFrame, reversed(list(data))))

    pd.concat(data, axis=1).to_csv(fn, index=False, sep=" ", header=False)