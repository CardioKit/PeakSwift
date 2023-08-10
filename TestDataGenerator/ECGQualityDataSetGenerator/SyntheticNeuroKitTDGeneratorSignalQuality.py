from ECGQualityDataSetGenerator.ECGQualityTestDataSetGenerator import ECGQualityTestDataSetGenerator
from ecgquality.ECGQuality import ECGQuality
from ecgquality.NeuroKitECGQuality import NeuroKitECGQuality
from ecgsource.ECGSource import ECGSource
from ecgsource.NeuroKitSyntheticECGSource import NeuroKitSyntheticECGSource


class SyntheticNeuroKitTDGeneratorSignalQuality(ECGQualityTestDataSetGenerator):

    def __init__(self, ecg_quality_assessment_method: str, expected_quality: str,
                 ecg_quality_assessment_approach: str = None, duration: int = 15, sampling_rate: int = 1000,
                 heart_rate: int = 80, seed: int = None):
        super().__init__(expected_quality)
        self.ecg_quality_assessment_method = ecg_quality_assessment_method
        self.ecg_quality_assessment_approach = ecg_quality_assessment_approach
        self.duration = duration
        self.sampling_rate = sampling_rate
        self.heart_rate = heart_rate
        self.seed = seed

    def _create_ecg_quality_evaluator(self) -> ECGQuality:
        return NeuroKitECGQuality(ecg_quality_assessment_approach=self.ecg_quality_assessment_approach,
                                  ecg_quality_assessment_method=self.ecg_quality_assessment_method)

    def _create_ecg_source(self) -> ECGSource:
        return NeuroKitSyntheticECGSource(duration=self.duration, sampling_rate=self.sampling_rate,
                                          heart_rate=self.heart_rate, seed=self.seed)
