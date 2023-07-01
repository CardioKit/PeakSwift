import numpy as np
import neurokit2 as nk

from qrsdetector.QRSDetector import QRSDetector


class NeuroKitQRSDetector(QRSDetector):

    def __init__(self, algorithm: str, should_clean_signal: bool = False):
        self.algorithm = algorithm
        self.clean = should_clean_signal

    def find_peaks(self, sampling_rate: int, ecg_signal: np.ndarray) -> np.ndarray:

        if self.clean:
            ecg_cleaned = nk.ecg_clean(ecg_signal, sampling_rate=sampling_rate, method=self.algorithm)
        else:
            ecg_cleaned = ecg_signal

        _, info = nk.ecg_peaks(ecg_cleaned=ecg_cleaned, sampling_rate=sampling_rate,
                               method=self.algorithm, correct_artifacts=False)
        return info['ECG_R_Peaks']

    def get_algorithm(self) -> str:
        return self.algorithm
