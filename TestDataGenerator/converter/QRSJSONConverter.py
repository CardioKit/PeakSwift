import json

import numpy as np

from converter.QRSConverter import QRSConverter


class QRSJSONConverter(QRSConverter):

    def get_file_extension(self) -> str:
        return ".json"

    def serialize(self, sampling_rate: int, signal: np.ndarray, r_peaks: np.ndarray) -> str:
        test_data_set = {
            "qrsComplexes": list(map(lambda rPeak: {'rPeak': rPeak}, r_peaks.tolist())),
            "electrocardiogram": {
                "samplingRate": sampling_rate,
                "ecg": signal.tolist()
            }
        }
        return json.dumps(test_data_set)