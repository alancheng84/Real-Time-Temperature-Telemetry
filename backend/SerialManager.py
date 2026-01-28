from PySide6.QtCore import QObject, Signal, Slot, Property
from PySide6.QtSerialPort import QSerialPort, QSerialPortInfo
from datetime import datetime
from collections import deque
import re

class SerialManager(QObject):
    # -------- Parsing Formats --------
    TEMP_RE = re.compile(
        r"t6:\s*(-?\d+)\s*"
        r"t7:\s*(-?\d+)\s*"
        r"t8:\s*(-?\d+)\s*"
        r"t9:\s*(-?\d+)"
    )

    # -------- Signals --------
    connected = Signal()
    disconnected = Signal()
    connectionChanged = Signal()
    dataReceived = Signal(str, str)
    connectionError = Signal(str)
    telemetryUpdated = Signal()

    def __init__(self):
        super().__init__()

        self._is_connected = False

        self.serial = QSerialPort()
        self.serial.readyRead.connect(self._on_ready_read)
        self.serial.errorOccurred.connect(self._on_error)

        self.ph1 = deque(maxlen=1000)       # pre-heater 1
        self.ph2 = deque(maxlen=1000)       # pre-heater 2
        self.rs = deque(maxlen=1000)        # reactor surface
        self.rg = deque(maxlen=1000)        # reactor gas
        self.pwr = deque(maxlen=1000)       # power
        self.avg = deque(maxlen=1000)       # average
        self.time = deque(maxlen=1000)      # time
        self.h2_flow = deque(maxlen=1000)   # h2_flow
        self.co2_flow = deque(maxlen=1000)  # co2_flow
        self.ar_flow = deque(maxlen=1000)   # ar_flow

    # -------- QML-visible property --------
    def getIsConnected(self):
        return self._is_connected

    isConnected = Property(bool, getIsConnected, notify=connectionChanged)

    # -------- Port discovery --------
    @Slot(result=list)
    def getAvailablePorts(self):
        return [
            {
                "name": port.portName(),
                "description": port.description()
            }
            for port in QSerialPortInfo.availablePorts()
        ]

    # -------- Connect / Disconnect --------
    @Slot(str, int, result=bool)
    def connectToPort(self, port_name, baud_rate=9600):
        if self.serial.isOpen():
            self.serial.close()

        self.serial.setPortName(port_name)
        self.serial.setBaudRate(baud_rate)

        if not self.serial.open(QSerialPort.ReadWrite):
            self.connectionError.emit("Failed to open serial port")
            return False

        self._is_connected = True
        self.connectionChanged.emit()
        self.connected.emit()

        print(f"✓ Connected to {port_name}")
        return True

    @Slot()
    def disconnect(self):
        if self.serial.isOpen():
            self.serial.close()

        self._is_connected = False
        self.connectionChanged.emit()
        self.disconnected.emit()

        print("✗ Disconnected")

    # -------- Send / Receive --------
    @Slot(str)
    def sendData(self, data):
        timestamp = datetime.now().strftime("%H:%M:%S.%f")[:-3]
        if not self._is_connected:
            self.dataReceived.emit(timestamp, "Error sending message: serial not connected!")
            return

        if not data.endswith("\n"):
            data += "\n"

        self.serial.write(data.encode("utf-8"))

    def _on_ready_read(self):
        while self.serial.canReadLine():
            line = (
                self.serial.readLine()
                .data()
                .decode("utf-8", errors="ignore")
                .strip()
            )
            timestamp = datetime.now().strftime("%H:%M:%S.%f")[:-3]
            
            parsed = self._parse_telemetry_block(line)
            if parsed:
                self._store_parsed_data(parsed, timestamp)

            # Append to text file
            with open("serial_log.csv", "a", encoding="utf-8") as f:
                f.write(f"{timestamp},{line}\n")

            # Optional: still emit to QML / UI
            self.dataReceived.emit(timestamp, line)

    def _on_error(self, error):
        if error == QSerialPort.NoError:
            return

        self.connectionError.emit(self.serial.errorString())

    def _parse_telemetry_block(self, line: str):
        """
        Parses lines like:
        t6: 310 t7: 295 t8: 120 t9: 130
        H:0.45, CO2:0.20, Ar:1.10
        """

        # Thermocouples
        tc = re.findall(r"t([6-9]):\s*(-?\d+)", line)  
            # raw string format:
            #   ()->dynamic parse
            #   \s*->whitespace eg " ", "\t"
            #   -? -> maybe negative
            #   \d+ -> multi digit decimal
        
        if tc:  # store data in data list
            data = {}
            for idx, val in tc:
                data[f"t{idx}"] = float(val)
            return data

        # Flow rates
        flow = re.findall(r"(H|CO2|Ar):([0-9.]+)", line)
        if flow:
            return {k: float(v) for k, v in flow}   # list with flow rates
        
        return None

    def _store_parsed_data(self, data: dict, timestamp):
        # TO-DO: append to csv?
        if "t8" in data:
            self.ph1.append(data["t8"])
        if "t9" in data:
            self.ph2.append(data["t9"])
        if "t6" in data:
            self.rs.append(data["t6"])
        if "t7" in data:
            self.rg.append(data["t7"])

        if "H" in data:
            self.h2_flow.append(data["H"])
        if "CO2" in data:
            self.co2_flow.append(data["CO2"])
        if "Ar" in data:
            self.ar_flow.append(data["Ar"])

        if "t6" in data and "t7" in data:
            self.avg.append((data["t6"] + data["t7"]) / 2.0)
        if "pwr" in data:
            self.pwr.append(data["pwr"])

        self.time.append(timestamp)
        self.telemetryUpdated.emit()

    def _build_points(self, series):
        return [{"x": float(idx), "y": float(val)} for idx, val in enumerate(series)]

    @Slot(result="QVariantMap")
    def getTelemetrySeries(self):
        return {
            "ph1": self._build_points(self.ph1),
            "ph2": self._build_points(self.ph2),
            "rs": self._build_points(self.rs),
            "rg": self._build_points(self.rg),
            "pwr": self._build_points(self.pwr),
            "avg": self._build_points(self.avg),
        }
