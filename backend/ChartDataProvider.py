# import random
# from datetime import datetime
# from pathlib import Path
# from PySide6.QtCore import QObject, Signal, Slot, Property, QTimer, QPointF
# import xml.etree.ElementTree as ET
# from xml.dom import minidom

# class DataLogger:
#     """Handles logging data to XML file"""
#     def __init__(self, filename="data_log.xml"):
#         self.filename = Path(filename)
#         self.root = ET.Element("DataLog")
#         self.tree = ET.ElementTree(self.root)
#         self.batch = []
#         self.batch_size = 10  # Batch writes for performance
        
#     def log_data(self, timestamp, value, data_type="sensor"):
#         entry = ET.SubElement(self.root, "Entry")
#         ET.SubElement(entry, "Timestamp").text = str(timestamp)
#         ET.SubElement(entry, "Value").text = f"{value:.4f}"
#         ET.SubElement(entry, "Type").text = data_type
        
#         self.batch.append(entry)
#         if len(self.batch) >= self.batch_size:
#             self.save()
#             self.batch.clear()
        
#     def save(self):
#         """Pretty print and save XML"""
#         xml_str = minidom.parseString(ET.tostring(self.root)).toprettyxml(indent="  ")
#         with open(self.filename, "w", encoding="utf-8") as f:
#             f.write(xml_str)
#         print(f"✓ Data saved to {self.filename}")

# class ChartDataProvider(QObject):
#     """
#     Provides real-time data for Qt Graphs charts
#     Manages data generation, buffering, and logging
#     """
    
#     # Signals
#     dataUpdated = Signal()
#     seriesDataChanged = Signal(list)  # Emits list of QPointF
    
#     def __init__(self, parent=None):
#         super().__init__(parent)
        
#         # Configuration
#         self._max_points = 100
#         self._update_interval = 50  # milliseconds
#         self._is_paused = False
        
#         # Data storage
#         self._data_points = []  # List of QPointF
#         self._counter = 0
        
#         # Logger
#         self.logger = DataLogger("logs/chart_data.xml")
#         Path("logs").mkdir(exist_ok=True)
        
#         # Timer for real-time updates
#         self.timer = QTimer(self)
#         self.timer.timeout.connect(self._update_data)
        
#     def start(self):
#         """Start real-time data updates"""
#         if not self.timer.isActive():
#             self.timer.start(self._update_interval)
#             self._is_paused = False
#             print("📊 Chart updates started")
    
#     def stop(self):
#         """Stop real-time data updates"""
#         self.timer.stop()
#         self._is_paused = True
#         self.logger.save()  # Save remaining data
#         print("⏸ Chart updates paused")
    
#     def _update_data(self):
#         """Generate/acquire new data point"""
#         # Simulate real-time data (replace with actual sensor/API data)
#         x = self._counter
#         y = 50 + 20 * random._sin(x * 0.1) + random.uniform(-5, 5)
        
#         # Create point
#         point = QPointF(x, y)
#         self._data_points.append(point)
        
#         # Log to XML
#         timestamp = datetime.now().isoformat()
#         self.logger.log_data(timestamp, y, "realtime_sensor")
        
#         # Maintain sliding window
#         if len(self._data_points) > self._max_points:
#             self._data_points.pop(0)
        
#         self._counter += 1
        
#         # Emit signals
#         self.dataUpdated.emit()
#         self.seriesDataChanged.emit(self._data_points.copy())
    
#     @Slot()
#     def togglePause(self):
#         """Toggle pause/resume"""
#         if self._is_paused:
#             self.start()
#         else:
#             self.stop()
    
#     @Slot()
#     def clearData(self):
#         """Clear all data points"""
#         self._data_points.clear()
#         self._counter = 0
#         self.dataUpdated.emit()
#         print("🗑 Data cleared")
    
#     # Properties
#     @Property(bool, notify=dataUpdated)
#     def isPaused(self):
#         return self._is_paused
    
#     @Property(int, notify=dataUpdated)
#     def pointCount(self):
#         return len(self._data_points)
    
#     @Property(int)
#     def maxPoints(self):
#         return self._max_points
    
#     @maxPoints.setter
#     def maxPoints(self, value):
#         self._max_points = value
    
#     @Property(list, notify=seriesDataChanged)
#     def dataPoints(self):
#         return self._data_points
# def _update_data(self):
#     """Generate/acquire new data point"""
#     # Simulate real-time data
#     x = self._counter
#     y = 50 + 20 * random._sin(x * 0.1) + random.uniform(-5, 5)
    
#     # Create point
#     point = QPointF(x, y)
#     self._data_points.append(point)
    
#     # DEBUG OUTPUT - Add this
#     if self._counter % 10 == 0:  # Print every 10 points
#         print(f"📊 Generated point {self._counter}: ({x:.1f}, {y:.1f}) | Total points: {len(self._data_points)}")
    
#     # Log to XML
#     timestamp = datetime.now().isoformat()
#     self.logger.log_data(timestamp, y, "realtime_sensor")
    
#     # Maintain sliding window
#     if len(self._data_points) > self._max_points:
#         self._data_points.pop(0)
    
#     self._counter += 1
    
#     # Emit signals
#     self.dataUpdated.emit()
#     self.seriesDataChanged.emit(self._data_points.copy())
