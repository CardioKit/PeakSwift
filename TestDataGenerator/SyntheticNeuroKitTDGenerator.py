from TestDataSetGenerator import TestDataSetGenerator
from ecgsource import ECGSource
from ecgsource.NeuroKitSyntheticECGSource import NeuroKitSyntheticECGSource
from qrsdetector import QRSDetector
from qrsdetector.NeuroKitQRSDetector import NeuroKitQRSDetector


class SyntheticNeuroKitTDGenerator(TestDataSetGenerator):

    def __init__(self, algorithm, clean_signal: bool = False, duration: int = 15, sampling_rate: int = 1000, heart_rate:int = 80, seed:int = None):
        self.algorithm = algorithm
        self.duration = duration
        self.sampling_rate = sampling_rate
        self.heart_rate = heart_rate
        self.seed = seed
        self.clean = clean_signal

    def _create_ecg_source(self) -> ECGSource:
        return NeuroKitSyntheticECGSource(duration= self.duration, sampling_rate= self.sampling_rate,
                                          heart_rate= self.heart_rate, seed=self.seed)

    def _create_qrs_detector(self) -> QRSDetector:
        return NeuroKitQRSDetector(algorithm=self.algorithm, should_clean_signal=self.clean)
