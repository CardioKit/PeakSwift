from abc import ABC, abstractmethod

from converter import QRSConverter
from converter.QRSJSONConverter import QRSJSONConverter
from ecgsource import ECGSource
from qrsdetector import QRSDetector


class TestDataSetGenerator(ABC):

    def generate_test_dataset(self):
        file_name_prefix = "Test"
        converter = self._create_converter()
        ecg_source = self._create_ecg_source()
        qrs_detector = self._create_qrs_detector()

        ecg_signal, sampling_rate = ecg_source.create_ecg_signal()
        r_peaks_positions = qrs_detector.find_peaks(sampling_rate=sampling_rate, ecg_signal=ecg_signal)
        algorithm = qrs_detector.get_algorithm()

        converter.store_in_file(file_name=f"{file_name_prefix}{algorithm}", sampling_rate=sampling_rate,
                                signal=ecg_signal, r_peaks=r_peaks_positions)

    def _create_converter(self) -> QRSConverter:
        return QRSJSONConverter()

    @abstractmethod
    def _create_ecg_source(self) -> ECGSource:
        pass

    @abstractmethod
    def _create_qrs_detector(self) -> QRSDetector:
        pass
