from abc import ABC, abstractmethod
import numpy as np

class ECGQualityConverter(ABC):

    @abstractmethod
    def serialize(self, sampling_rate: int, signal: np.ndarray, quality: str) -> str:
        pass

    @abstractmethod
    def get_file_extension(self) -> str:
        pass