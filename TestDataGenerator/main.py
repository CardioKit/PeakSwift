import TestDataSetGenerator
from SyntheticNeuroKitTDGenerator import SyntheticNeuroKitTDGenerator

test_data_set_generators: [TestDataSetGenerator] = [
    SyntheticNeuroKitTDGenerator(algorithm="nabian", seed=2),
    SyntheticNeuroKitTDGenerator(algorithm="wqrs", seed=1),
    SyntheticNeuroKitTDGenerator(algorithm="christov", seed=1),
    SyntheticNeuroKitTDGenerator(algorithm="elgendi", seed=1),
    SyntheticNeuroKitTDGenerator(algorithm="hamilton", seed=1),
    SyntheticNeuroKitTDGenerator(algorithm="panTompkins", seed=1, clean_signal=True),
    SyntheticNeuroKitTDGenerator(algorithm="nk", duration=10, seed=15, clean_signal=True, noise_frequency=0.3),
    SyntheticNeuroKitTDGenerator(algorithm="engzee", seed=1, clean_signal=True, noise_frequency=50),
]


def generate_test_data():
    for test_data_set_generator in test_data_set_generators:
        test_data_set_generator.generate_test_dataset()


# Press the green button in the gutter to run the script.
if __name__ == '__main__':
    generate_test_data()
