from abc import ABC, abstractmethod
import numpy as np


class QRSConverter(ABC):

    @abstractmethod
    def serialize(self, sampling_rate: int, signal: np.ndarray, r_peaks: np.ndarray) -> str:
        pass

    @abstractmethod
    def get_file_extension(self) -> str:
        pass
