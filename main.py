import sys
from pathlib import Path
from PySide6.QtWidgets import QApplication
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtCore import QUrl
import time 

from backend.SerialManager import SerialManager

t0 = time.perf_counter()
print("t0 start")


if __name__ == "__main__":
    app = QApplication(sys.argv)
    engine = QQmlApplicationEngine()
    
    # THIS IS THE FIX - CREATE AND EXPOSE BEFORE LOADING QML
    serial_manager = SerialManager()
    engine.rootContext().setContextProperty("serialManager", serial_manager)
    
    # NOW LOAD QML
    qml_file = Path(__file__).parent / "qml" / "main.qml"
    print("t1 before load:", time.perf_counter() - t0) # to delete
    engine.load(QUrl.fromLocalFile(str(qml_file)))
    print("t2 after load:", time.perf_counter() - t0) # to delete


    if not engine.rootObjects():
        sys.exit(-1)
    
    sys.exit(app.exec())
