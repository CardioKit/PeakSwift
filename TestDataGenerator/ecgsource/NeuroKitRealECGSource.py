import numpy as np
import neurokit2 as nk

from ecgsource.ECGSource import ECGSource


class NeuroKitRealECGSource(ECGSource):

    def __init__(self, source_name: str, sampling_rate: int):
        self.source_name = source_name
        self.sampling_rate = sampling_rate

    def create_ecg_signal(self) -> (np.ndarray, int):
        return nk.data(self.source_name)["ECG"], self.sampling_rate
