import neurokit2 as nk
import pandas as pd
import numpy as np
import json
import decimal

def decimal_default(obj):
    return float(obj)

decimal.getcontext().prec = 32


def generate_test_data(algorithm, samplingRate, signal, rPeaks):
    f = open(f"../PeakSwift/Tests/PeakSwiftTests/Resources/Test{algorithm}.json", "w")
    #algorithm = f"<algorithm>{algorithm}</algorithm>"
    #sampling_rate = f"<sampling-rate>{samplingRate}</sampling-rate>"
    #signalXML = signal.to_xml(index=False, root_name="ecg-signal", row_name="ecg-signal-data-point",
    #                           xml_declaration=False, elem_cols=["ECG_Raw"])
    #rPeaksXML = rPeaks.to_xml(index=False, root_name="r-peaks-positions", row_name="r-peak-position",
    #                                 xml_declaration=False, elem_cols=["R_Peak_Position"])

    #signalJSON = signal.to_json(orient="columns")
    #rPeaksJSON = rPeaks.to_json(orient="index")

    #f.write(f"<test-dataset>{algorithm + sampling_rate + signalXML + rPeaksXML}</test-dataset>")

    number = signal[0]
    numberStr = str(number)

    ecgString = list(map(lambda amplitude: str("{:.64f}".format(amplitude)), signal))

    dataSet = {
        "algorithm": algorithm,
        "electrocardiogram": {
            "ecg": signal,
            "samplingRate":  samplingRate
        },
        "qrsComplexes": list(map(lambda rPeak: {'rPeak': rPeak}, rPeaks))
    }
    f.write(f"{json.dumps(dataSet, default=decimal_default)}")
    f.close()


# Press the green button in the gutter to run the script.
if __name__ == '__main__':
    # Simulate ECG signal
    ecg = nk.ecg_simulate(duration=15, sampling_rate=1000, heart_rate=80)

    algorithm = "nabian"

    # Preprocess ECG signal
    signals, info = nk.ecg_peaks(ecg, sampling_rate=1000, method=algorithm, correct_artifacts=False)
    ecgSignal = pd.DataFrame(ecg, columns=["ECG_Raw"])
    rPeaksPosition = pd.DataFrame(info['ECG_R_Peaks'], columns=["R_Peak_Position"])
    print("OK")
    number = ecg[0]
    equal = (number == ecg[0])
    numberStr = str("{:.64f}".format(number))
    generate_test_data(algorithm=algorithm, samplingRate=1000, signal=ecg.tolist(), rPeaks=info["ECG_R_Peaks"].tolist())

    print("OK")

