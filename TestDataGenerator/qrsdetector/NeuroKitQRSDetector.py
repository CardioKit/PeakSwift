import numpy as np
import neurokit2 as nk

from qrsdetector.QRSDetector import QRSDetector


class NeuroKitQRSDetector(QRSDetector):

    def __init__(self, algorithm: str):
        self.algorithm = algorithm

    def find_peaks(self, sampling_rate: int, ecg_signal: np.ndarray) -> np.ndarray:
        _, info = nk.ecg_peaks(ecg_cleaned=ecg_signal, sampling_rate=sampling_rate,
                               method=self.algorithm, correct_artifacts=False)
        return info['ECG_R_Peaks']

    def get_algorithm(self) -> str:
        return self.algorithm
