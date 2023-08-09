from abc import abstractmethod

from TestDataSetGenerator import TestDataSetGenerator
from converter import ECGQualityConverter
from converter.ECGQualityJSONConverter import ECGQualityJSONConverter
from converter.QRSJSONConverter import QRSJSONConverter
from ecgquality.ECGQuality import ECGQuality
from ecgsource.ECGSource import ECGSource


def _create_converter() -> ECGQualityConverter:
    return QRSJSONConverter()


class ECGQualityTestDataSetGenerator(TestDataSetGenerator):
    def get_test_dataset(self) -> str:
        converter = self._create_converter()
        evaluator = self._create_ecg_quality_evaluator()
        ecg_source = self._create_ecg_source()

        ecg_signal, sampling_rate = ecg_source.create_ecg_signal()
        quality = evaluator.evaluate_ecg_quality(ecg_signal=ecg_signal, sampling_rate=sampling_rate)

        serialized_data = converter.serialize(sampling_rate=sampling_rate, signal=ecg_signal, quality=quality)

        return serialized_data

    def get_file_name(self) -> str:
        file_name_prefix = "TestECGQuality"
        evaluator = self._create_ecg_quality_evaluator()
        converter = _create_converter()

        # Capitalize the first letter to ensure camel case. (e.g. TestPanTompkins)
        approach = evaluator.get_approach()
        method = evaluator.get_method()

        file_name = method[:1].upper() + method[1:] + approach[:1].upper() + approach[1:] 
        file_extension = converter.get_file_extension()
        return file_name_prefix + file_name + file_extension

    @abstractmethod
    def _create_ecg_quality_evaluator(self) -> ECGQuality:
        pass

    @abstractmethod
    def _create_ecg_source(self) -> ECGSource:
        pass

    def _create_converter(self) -> ECGQualityConverter:
        return ECGQualityJSONConverter()
