# Telemetry on N76E003 MCU, Real-Time Exponential Moving Average (EMA) Filter, GUI in PySide6 + QML

## Learning Goals
An Educational Project for ELEC 291 at UBC:
- Real-time logging with sliding strip charts
- Interface with hardware 12-bit ADC

## Hardware
- N76E003 MCU
- LM4040 (4.096 V) as reference voltage
- LM335
- Various Resistors

## Architecture/Code
- 80C51 Assembly for MCU Firmware
- PySide6 + QML for front end, native Python backend
- Python built in VSCode
- Assembly built in CrossIDE
- Control flow:
  -   Read ADC values
  -   Converted raw ADC LM335 channel to Voltage readings by performing: $V_{channel} = \frac{ADC_{channel}\cdot V_{ref}}{ADC_{ref}}$, where $V_{ref}$ is the reference voltage measured across the LM4040 voltage reference.
  -   Voltage reads the temperature in Kelvin / 100, so temperature conversion is trivial; eg., (2.96-2.73)*100=23 deg C. 

## Bonus Features
- Logging in Qt, offering faster and smoother updates
- MCU-side real-time filtering using the EMA algorithm:

$$
y_k = \alpha\cdot x_k + (1 - \alpha)\ y_{k-1}
$$

- choose alpha = 1/n, substitute and manipulate

$$
y_k = \frac{1}{n}x_k + \left(1 - \frac{1}{n}\right)y_{k-1} = \frac{(x_k + (n-1)*y_{k-1})}{n}
$$

- This is the form that is seen in asm processing. This algorithm was chosen due to simplicity (one stored value to keep track of), and relevance to ELEC 221 - Signals and Systems (note that taking the z-transform of the filter, and solving for the transfer function shows that the filter is a linear, single-poled, stable LTI system given |1-alpha| < 1). 
- Interrupt-based UART recieve on MCU, allows for dynamic, GUI-controlled choice of n. 
- GUI displays all of: raw ADC voltage, raw temperature reading, filtered temperature
- Overlapped raw and filtered temperature data representation to highlight effects of data processing 




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
