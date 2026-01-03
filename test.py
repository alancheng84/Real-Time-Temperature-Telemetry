import sys
import os

from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine

from backend.Reactor import ReactorController


if __name__ == "__main__":
    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()

    base_dir = os.path.dirname(os.path.abspath(__file__))
    qml_dir = os.path.join(base_dir, "qml")

    # Backend (can be empty for now)
    backend = ReactorController()
    engine.rootContext().setContextProperty("backend", backend)

    engine.load(os.path.join(qml_dir, "test_chart.qml"))

    if not engine.rootObjects():
        sys.exit(-1)

    sys.exit(app.exec())
