import neurokit2 as nk
import numpy as np

class NoiseGenerator:

    def __init__(self, duration: int, frequency: float, seed: int = None):
        self.duration = duration
        self.frequency = frequency
        self.seed = seed

    def add_noise(self, signal: np.ndarray) -> np.ndarray:
        duration = self.duration
        if self.duration is None:
            # automatic infer the duration in seconds
            duration = len(signal) / self.frequency
        noise = nk.signal_simulate(duration=duration, frequency=self.frequency, random_state=self.seed)
        return signal + noise