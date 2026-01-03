from PySide6.QtCore import QObject, Signal, Slot, Property, QTimer

class ReactorController(QObject):
    logChanged = Signal()

    def __init__(self):
        super().__init__()
        self._log = "Started Sabatier Reactor Control System\n"

    def getLog(self):
        return self._log

    logText = Property(str, getLog, notify=logChanged)

    @Slot()
    def connectSerial(self):
        self._log += "Connected to serial (stub)\n"
        self.logChanged.emit()
