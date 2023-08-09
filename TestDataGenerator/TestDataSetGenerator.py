from abc import ABC, abstractmethod

from utils.FileWriter import FileWriter


class TestDataSetGenerator(ABC):

    def generate_test_dataset(self):
        test_data = self.get_test_dataset()
        file_name = self.get_file_name()

        writer = FileWriter()
        writer.store_in_file(file_name=file_name, data=test_data)

    @abstractmethod
    def get_test_dataset(self) -> str:
        pass

    @abstractmethod
    def get_file_name(self) -> str:
        pass
