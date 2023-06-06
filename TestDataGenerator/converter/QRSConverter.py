from abc import ABC, abstractmethod
import numpy as np


class QRSConverter(ABC):

    PATH = "./Tests/PeakSwiftTests/Resources/"

    @abstractmethod
    def serialize(self, sampling_rate: int, signal: np.ndarray, r_peaks: np.ndarray) -> str:
        pass

    @abstractmethod
    def get_file_extension(self) -> str:
        pass

    def store_in_file(self, file_name: str, sampling_rate: int, signal: np.ndarray, r_peaks: np.ndarray):
        f = open(f"{self.PATH}{file_name}{self.get_file_extension()}", "w")
        serialized_data = self.serialize(sampling_rate=sampling_rate, signal=signal, r_peaks=r_peaks)
        f.write(serialized_data)
        f.close()
