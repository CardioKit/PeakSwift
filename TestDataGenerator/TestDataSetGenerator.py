from abc import ABC, abstractmethod

from converter import QRSConverter
from converter.QRSJSONConverter import QRSJSONConverter
from ecgsource import ECGSource
from noisegenerator.NoiseGenerator import NoiseGenerator
from qrsdetector import QRSDetector


class TestDataSetGenerator(ABC):

    def __init__(self, noise_frequency: int = None):
        self.noise_frequency = noise_frequency


    def generate_test_dataset(self):
        file_name_prefix = "Test"
        converter = self._create_converter()
        ecg_source = self._create_ecg_source()
        qrs_detector = self._create_qrs_detector()

        ecg_signal, sampling_rate = ecg_source.create_ecg_signal()

        if self.noise_frequency:
            ecg_signal = self._create_ecg_noise_generator().add_noise(signal=ecg_signal)

        r_peaks_positions = qrs_detector.find_peaks(sampling_rate=sampling_rate, ecg_signal=ecg_signal)
        algorithm = qrs_detector.get_algorithm()

        # Capitalize the first letter to ensure camel case. (e.g. TestPanTompkins)
        algorithm_file_name = algorithm[:1].upper() + algorithm[1:]

        converter.store_in_file(file_name=f"{file_name_prefix}{algorithm_file_name}", sampling_rate=sampling_rate,
                                signal=ecg_signal, r_peaks=r_peaks_positions)

    def _create_converter(self) -> QRSConverter:
        return QRSJSONConverter()

    @abstractmethod
    def _create_ecg_source(self) -> ECGSource:
        pass

    @abstractmethod
    def _create_qrs_detector(self) -> QRSDetector:
        pass

    @abstractmethod
    def _create_ecg_noise_generator(self) -> NoiseGenerator:
        pass
