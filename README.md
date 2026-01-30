# Telemetry on N76E003 MCU, Real-Time Exponential Moving Average (EMA) Filter, GUI in PySide6 + QML

## Learning Goals
An Educational Project Started for ELEC 291 at UBC:
- Real-time logging with sliding strip charts
- Interface with hardware 12-bit ADC

# Hardware
- N76E003 MCU
- LM4040 (4.096 V) as reference voltage
- LM335
- Various Resistors

# Bonus Features
- Logging in Qt, offering faster and smoother updates
- MCU-side real-time filtering using the EMA algorithm:
$$
y_k = \alpha\,x_k + (1 - \alpha)\,y_{k-1}
$$
- choose alpha = 1/n, substitute and manipulate
$$
y_k = \frac{1}{n}x_k + \left(1 - \frac{1}{n}\right)y_{k-1}
$$
- This is the form that is seen in asm processing
- Interrupt-based UART recieve on MCU, allows for dynamic, GUI-controlled choice of n
- GUI displays all of: raw ADC voltage, raw temperature reading, filtered temperature
- Overlapped raw and filtered temperature data representation to highlight effects of data processing 


# Architecture
- 80C51 Assembly for MCU Firmware
- PySide6 + QML for front end, native Python backend

# To use: 
- Create a virtual environment in Python 3.11 (do NOT use latest version, it might not be supported by current PySide6)
```powershell
# to make:
py -3.11 -m venv .venv

# to activate venv:
.\.venv\Scripts\Activate.ps1

# install required python modules
pip install -r "requirements.txt"
```
- Flash N76E003
- Run main.py !!
