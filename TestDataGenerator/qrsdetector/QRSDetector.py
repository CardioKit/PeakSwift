from abc import ABC, abstractmethod
import numpy as np


class QRSDetector(ABC):

    @abstractmethod
    def find_peaks(self, sampling_rate: int, ecg_signal: np.ndarray) -> np.ndarray:
        pass

    @abstractmethod
    def get_algorithm(self) -> str:
        pass
