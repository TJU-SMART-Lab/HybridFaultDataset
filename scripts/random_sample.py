import numpy as np

if __name__ == '__main__':
    for dir_name in ["2-TwoSimultaneousFaults", "3-ThreeSimultaneousFaults", "4-FourSimultaneousFaults"]:
        X_train = np.load(f"../datasets/{dir_name}/train_data.npy")
        y_train = np.load(f"../datasets/{dir_name}/train_label.npy")
        print(X_train.shape, y_train.shape)
