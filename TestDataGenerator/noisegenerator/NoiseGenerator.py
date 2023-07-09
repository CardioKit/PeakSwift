import neurokit2 as nk
import numpy as np

class NoiseGenerator:

    def __init__(self, duration: int, frequency: float, seed: int = None):
        self.duration = duration
        self.frequency = frequency
        self.seed = seed

    def add_noise(self, signal: np.ndarray) -> np.ndarray:
        noise = nk.signal_simulate(duration=self.duration, frequency=self.frequency, random_state=self.seed)
        return signal + noise