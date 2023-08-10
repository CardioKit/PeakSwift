class FileWriter:

    PATH = "../Tests/PeakSwiftTests/Resources/"

    def store_in_file(self, file_name: str, data: str):
        f = open(f"{self.PATH}{file_name}", "w")
        f.write(data)
        f.close()