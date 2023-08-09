from ECGQualityDataSetGenerator.ECGQualityTestDataSetGenerator import ECGQualityTestDataSetGenerator
from ecgquality.ECGQuality import ECGQuality
from ecgquality.NeuroKitECGQuality import NeuroKitECGQuality
from ecgsource.ECGSource import ECGSource
from ecgsource.NeuroKitRealECGSource import NeuroKitRealECGSource
from ecgsource.NeuroKitSyntheticECGSource import NeuroKitSyntheticECGSource


class RealNeuroKitTDGeneratorSignalQuality(ECGQualityTestDataSetGenerator):

    def __init__(self, source_name: str, sampling_rate: int, ecg_quality_assessment_method: str, expected_quality: str,
                 ecg_quality_assessment_approach: str = None):
        super().__init__(expected_quality)
        self.ecg_quality_assessment_method = ecg_quality_assessment_method
        self.ecg_quality_assessment_approach = ecg_quality_assessment_approach
        self.sampling_rate = sampling_rate
        self.source_name = source_name
        self.sampling_rate = sampling_rate

    def _create_ecg_quality_evaluator(self) -> ECGQuality:
        return NeuroKitECGQuality(ecg_quality_assessment_approach=self.ecg_quality_assessment_approach,
                                  ecg_quality_assessment_method=self.ecg_quality_assessment_method)

    def _create_ecg_source(self) -> ECGSource:
        return NeuroKitRealECGSource(source_name=self.source_name, sampling_rate=self.sampling_rate)
