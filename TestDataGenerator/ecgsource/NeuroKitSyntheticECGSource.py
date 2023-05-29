import numpy as np
import neurokit2 as nk

from ecgsource.ECGSource import ECGSource


class NeuroKitSyntheticECGSource(ECGSource):

    def __init__(self, duration: int, sampling_rate: int, heart_rate: int, seed: int = None):
        self.duration = duration
        self.sampling_rate = sampling_rate
        self.heart_rate = heart_rate
        self.seed = seed

    def create_ecg_signal(self) -> (np.ndarray, int):
        return nk.ecg_simulate(duration=self.duration, sampling_rate=self.sampling_rate,
                               heart_rate=self.heart_rate, random_state=self.seed), self.sampling_rate
