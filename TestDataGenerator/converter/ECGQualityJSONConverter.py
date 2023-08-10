import json
from abc import ABC, abstractmethod
import numpy as np

from converter.ECGQualityConverter import ECGQualityConverter
from utils.Formatter import to_camel_case


class ECGQualityJSONConverter(ECGQualityConverter):

    def serialize(self, sampling_rate: int, signal: np.ndarray, quality: str) -> str:
        test_data_set = {
            "quality": to_camel_case(quality, seperator=" "),
            "electrocardiogram": {
                "samplingRate": sampling_rate,
                "ecg": signal.tolist()
            }
        }
        return json.dumps(test_data_set)

    def get_file_extension(self) -> str:
        return ".json"
