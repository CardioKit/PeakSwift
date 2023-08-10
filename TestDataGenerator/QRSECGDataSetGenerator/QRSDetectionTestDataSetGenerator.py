from abc import abstractmethod

from TestDataSetGenerator import TestDataSetGenerator
from converter import QRSConverter
from converter.QRSJSONConverter import QRSJSONConverter
from ecgsource import ECGSource
from noisegenerator.NoiseGenerator import NoiseGenerator
from qrsdetector import QRSDetector


class QRSDetectionTestDataSetGenerator(TestDataSetGenerator):

    def __init__(self, noise_frequency: int = None):
        self.noise_frequency = noise_frequency

    def get_test_dataset(self) -> str:
        converter = self._create_converter()
        ecg_source = self._create_ecg_source()
        qrs_detector = self._create_qrs_detector()

        ecg_signal, sampling_rate = ecg_source.create_ecg_signal()

        if self.noise_frequency:
            ecg_signal = self._create_ecg_noise_generator().add_noise(signal=ecg_signal)

        r_peaks_positions = qrs_detector.find_peaks(sampling_rate=sampling_rate, ecg_signal=ecg_signal)

        serialized_data = converter.serialize(sampling_rate=sampling_rate, signal=ecg_signal, r_peaks=r_peaks_positions)
        return serialized_data

    def get_file_name(self) -> str:
        file_name_prefix = "TestQRSDetection"
        qrs_detector = self._create_qrs_detector()
        converter = self._create_converter()

        # Capitalize the first letter to ensure camel case. (e.g. TestPanTompkins)
        algorithm = qrs_detector.get_algorithm()
        file_name = algorithm[:1].upper() + algorithm[1:]
        file_extension = converter.get_file_extension()
        return file_name_prefix + file_name + file_extension


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
