from abc import ABC, abstractmethod
import numpy as np


class ECGQuality(ABC):

    @abstractmethod
    def evaluate_ecg_quality(self, sampling_rate: int, ecg_signal: np.ndarray) -> str:
        pass

    @abstractmethod
    def get_method(self) -> str:
        pass

    @abstractmethod
    def get_approach(self) -> str:
        pass
