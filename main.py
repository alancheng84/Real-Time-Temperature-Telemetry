# # This Python file uses the following encoding: utf-8
# import sys
# from pathlib import Path

# from PySide6.QtGui import QGuiApplication
# from PySide6.QtQml import QQmlApplicationEngine

# if __name__ == "__main__":
#     app = QGuiApplication(sys.argv)
#     engine = QQmlApplicationEngine()
#     qml_file = Path(__file__).resolve().parent / "main.qml"
#     engine.load(qml_file)
#     if not engine.rootObjects():
#         sys.exit(-1)
#     sys.exit(app.exec())


# import sys
# import os
# from PySide6.QtGui import QGuiApplication
# from PySide6.QtQml import QQmlApplicationEngine
# from backend.Reactor import ReactorController


# if __name__ == "__main__":
#     app = QGuiApplication(sys.argv)
#     engine = QQmlApplicationEngine()

#     base_dir = os.path.dirname(os.path.abspath(__file__))
#     qml_dir = os.path.join(base_dir,

#     # Create Backend
#     back = ReactorController()
#     engine.rootContext().setContextProperty("backend", back)

#     # Expose to QML
#     engine.addImportPath(qml_dir)
#     engine.load(os.path.join(qml_dir, "main.qml"))

#     if not engine.rootObjects():
#         sys.exit(-1)

#     sys.exit(app.exec())


import sys
import os
from pathlib import Path
from PySide6.QtWidgets import QApplication
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtCore import QUrl

from backend.Reactor import ReactorController

app = QApplication(sys.argv)
engine = QQmlApplicationEngine()

qml_file = Path(__file__).parent / "qml" / "main.qml"
print(f"Loading: {qml_file}")
print(f"File exists: {qml_file.exists()}")

# Create Backend
back = ReactorController()
engine.rootContext().setContextProperty("backend", back)

engine.load(QUrl.fromLocalFile(str(qml_file)))

if not engine.rootObjects():
    print("FAILED TO LOAD QML")
    sys.exit(-1)

print("SUCCESS!")
sys.exit(app.exec())


