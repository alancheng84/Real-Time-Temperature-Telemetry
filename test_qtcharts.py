import sys
from pathlib import Path
from PySide6.QtWidgets import QApplication
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtCore import QUrl

app = QApplication(sys.argv)
engine = QQmlApplicationEngine()

# Point to the existing test_chart.qml in qml folder
qml_file = Path(__file__).parent / "qml" / "test_chart.qml"
print(f"Loading: {qml_file}")
print(f"File exists: {qml_file.exists()}")

engine.load(QUrl.fromLocalFile(str(qml_file)))

if not engine.rootObjects():
    print("FAILED TO LOAD QML")
    sys.exit(-1)

print("SUCCESS!")
sys.exit(app.exec())
