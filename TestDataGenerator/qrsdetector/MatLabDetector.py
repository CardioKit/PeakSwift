import numpy as np
from qrsdetector.QRSDetector import QRSDetector


class MatLabDetector(QRSDetector):

    def __init__(self, algorithm: str, should_clean_signal: bool = False):
        self.algorithm = algorithm
        self.clean = should_clean_signal

    def find_peaks(self, sampling_rate: int, ecg_signal: np.ndarray) -> np.ndarray:
        # In the future, if we plan to integrate multiple matlab based algorithms, we may consider
        # to wrap the implementation here
        # Alternatively,  we could create a similar matlab based testing module

        if self.algorithm == 'unsw':
            return np.array([68, 517, 973, 1429, 1884, 2340, 2796, 3252, 3708, 4163, 4619])
        else:
            return np.empty()

    def get_algorithm(self) -> str:
        return self.algorithm
