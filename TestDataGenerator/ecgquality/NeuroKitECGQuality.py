from abc import ABC

import numpy as np
import neurokit2 as nk

from ecgquality.ECGQuality import ECGQuality


class NeuroKitECGQuality(ECGQuality):

    def __init__(self, ecg_quality_assessment_method: str, ecg_quality_assessment_approach: str = None):
        self.ecg_quality_assessment_method = ecg_quality_assessment_method
        self.ecg_quality_assessment_approach = ecg_quality_assessment_approach

    def evaluate_ecg_quality(self, sampling_rate: int, ecg_signal: np.ndarray) -> str:
        return nk.ecg_quality(ecg_signal, sampling_rate=sampling_rate,
                              method=self.ecg_quality_assessment_method,
                              approach=self.ecg_quality_assessment_approach)

    def get_method(self) -> str:
        return self.ecg_quality_assessment_method

    def get_approach(self) -> str:
        # Approach might be none. In such case return empty string
        return self.ecg_quality_assessment_approach \
            if self.ecg_quality_assessment_approach is not None else ""
