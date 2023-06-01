from abc import ABC, abstractmethod
import numpy as np


class ECGSource(ABC):

    @abstractmethod
    def create_ecg_signal(self) -> np.ndarray:
        pass
