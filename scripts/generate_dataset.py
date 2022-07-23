import itertools
import os

import numpy as np
from scipy.io import loadmat
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler

np.random.seed(23333)
productions = np.array(
    [
        "18.00",
        "18.01",
        "18.02",
        "18.03",
        "18.04",
        "18.05",
        "18.06",
        "18.07",
        "18.08",
        "18.09",
    ]
)

dirs = {
    0: "0-Normal",
    1: "1-IndependentFaults",
    2: "2-TwoSimultaneousFaults",
    3: "3-ThreeSimultaneousFaults",
    4: "4-FourSimultaneousFaults",
}

invalid_combinations = [
    (1, 2),
    (1, 8),
    (2, 6),
    (2, 7),
    (2, 8),
    (3, 9),
    (4, 11),
    (5, 12),
]

sample_rate = 0.1


def load_data(idvs):
    this_fault_data = []
    for production in productions[production_idx]:
        raw_data = loadmat(
            f"../raws/{dirs[len(idvs) if idvs != (0,) else 0]}/{'_'.join(str(idv) for idv in idvs)}_{production}.mat"
        )["result"]
        if raw_data.shape[0] % 50 != 0:
            raw_data = raw_data[: (raw_data.shape[0] - raw_data.shape[0] % 50)]
        raw_data = raw_data.reshape((-1, 50, 51))
        this_fault_data.append(raw_data)
    this_fault_data = np.concatenate(this_fault_data)

    if len(idvs) > 1:
        # Simultaneous Fault
        this_fault_data = this_fault_data[
            np.random.choice(
                this_fault_data.shape[0],
                int(this_fault_data.shape[0] * sample_rate),
                replace=False,
            )
        ]

    print(idvs, this_fault_data.shape)
    # 随机分割
    return train_test_split(
        this_fault_data,
        np.sum([np.eye(21)[[idv] * this_fault_data.shape[0]] for idv in idvs], axis=0),
        test_size=0.2,
    )


if __name__ == "__main__":
    production_idx = np.random.permutation(len(productions))

    for i in range(5):
        total_train_data, total_train_label = [], []
        total_test_data, total_test_label = [], []
        if i:
            for idvs in itertools.combinations(range(1, 21), i):
                skip = False
                for ex in invalid_combinations:
                    if ex[0] in idvs and ex[1] in idvs:
                        skip = True
                        break
                if skip:
                    continue

                # X_train, X_test, y_train, y_test
                train_data, test_data, train_label, test_label = load_data(idvs)
                total_train_data.append(train_data)
                total_train_label.append(train_label)
                total_test_data.append(test_data)
                total_test_label.append(test_label)
        else:
            train_data, test_data, train_label, test_label = load_data((0,))
            total_train_data.append(train_data)
            total_train_label.append(train_label)
            total_test_data.append(test_data)
            total_test_label.append(test_label)

        total_train_data = np.concatenate(total_train_data)
        total_train_label = np.concatenate(total_train_label)
        total_test_data = np.concatenate(total_test_data)
        total_test_label = np.concatenate(total_test_label)
        print(
            i,
            total_train_data.shape,
            total_train_label.shape,
            total_test_data.shape,
            total_test_label.shape,
        )

        if not os.path.exists(f"../datasets/{dirs[i]}"):
            os.mkdir(f"../datasets/{dirs[i]}")
        idx = np.random.permutation(total_train_data.shape[0])
        np.save(f"../datasets/{dirs[i]}/train_data.npy", total_train_data[idx])
        np.save(f"../datasets/{dirs[i]}/train_label.npy", total_train_label[idx])
        np.save(f"../datasets/{dirs[i]}/test_data.npy", total_test_data)
        np.save(f"../datasets/{dirs[i]}/test_label.npy", total_test_label)
