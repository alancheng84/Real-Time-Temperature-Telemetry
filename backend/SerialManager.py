from PySide6.QtCore import QObject, Signal, Slot, Property
from PySide6.QtSerialPort import QSerialPort, QSerialPortInfo
from datetime import datetime

class SerialManager(QObject):
    # -------- Signals --------
    connected = Signal()
    disconnected = Signal()
    connectionChanged = Signal()
    dataReceived = Signal(str, str)
    connectionError = Signal(str)

    def __init__(self):
        super().__init__()

        self._is_connected = False

        self.serial = QSerialPort()
        self.serial.readyRead.connect(self._on_ready_read)
        self.serial.errorOccurred.connect(self._on_error)

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
        if not self._is_connected:
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
            
            # Append to text file
            with open("serial_log.csv", "a", encoding="utf-8") as f:
                f.write(f"{timestamp},{line}\n")

            # Optional: still emit to QML / UI
            self.dataReceived.emit(timestamp, line)

    def _on_error(self, error):
        if error == QSerialPort.NoError:
            return

        self.connectionError.emit(self.serial.errorString())
