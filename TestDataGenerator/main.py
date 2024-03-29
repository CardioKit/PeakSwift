from ECGQualityDataSetGenerator.RealNeuroKitTDGeneratorSignalQuality import RealNeuroKitTDGeneratorSignalQuality
from ECGQualityDataSetGenerator.SyntheticNeuroKitTDGeneratorSignalQuality import \
    SyntheticNeuroKitTDGeneratorSignalQuality
from QRSECGDataSetGenerator.SyntheticNeuroKitTDGenerator import SyntheticNeuroKitTDGenerator
from TestDataSetGenerator import TestDataSetGenerator

test_data_set_generators: [TestDataSetGenerator] = [
    SyntheticNeuroKitTDGenerator(algorithm="nabian", seed=2),
    SyntheticNeuroKitTDGenerator(algorithm="christov", seed=1),
    SyntheticNeuroKitTDGenerator(algorithm="elgendi", seed=1, clean_signal=True),
    SyntheticNeuroKitTDGenerator(algorithm="hamilton", seed=1, clean_signal=True),
    SyntheticNeuroKitTDGenerator(algorithm="panTompkins", seed=1, clean_signal=True),
    SyntheticNeuroKitTDGenerator(algorithm="nk", duration=10, seed=15, clean_signal=True, noise_frequency=0.3),
    SyntheticNeuroKitTDGenerator(algorithm="engzee", seed=1, clean_signal=True, noise_frequency=50),
    SyntheticNeuroKitTDGenerator(algorithm="kalidas", seed=1),
    SyntheticNeuroKitTDGeneratorSignalQuality(ecg_quality_assessment_method="zhao2018",
                                              ecg_quality_assessment_approach="simple",
                                              expected_quality="unacceptable",
                                              seed=1),
    RealNeuroKitTDGeneratorSignalQuality(ecg_quality_assessment_method="zhao2018",
                                         ecg_quality_assessment_approach="simple",
                                         expected_quality="excellent",
                                         source_name="bio_eventrelated_100hz", sampling_rate=100),
    SyntheticNeuroKitTDGeneratorSignalQuality(ecg_quality_assessment_method="zhao2018",
                                              ecg_quality_assessment_approach="fuzzy",
                                              expected_quality="barelyAcceptable",
                                              seed=1),
    RealNeuroKitTDGeneratorSignalQuality(ecg_quality_assessment_method="zhao2018",
                                         ecg_quality_assessment_approach="fuzzy",
                                         expected_quality="excellent",
                                         source_name="bio_eventrelated_100hz", sampling_rate=100),
    SyntheticNeuroKitTDGeneratorSignalQuality(ecg_quality_assessment_method="zhao2018",
                                              ecg_quality_assessment_approach="fuzzy",
                                              expected_quality="unacceptable",
                                              noise_frequency=20,
                                              seed=1)
]


def generate_test_data():
    for test_data_set_generator in test_data_set_generators:
        test_data_set_generator.generate_test_dataset()


# Press the green button in the gutter to run the script.
if __name__ == '__main__':
    generate_test_data()
