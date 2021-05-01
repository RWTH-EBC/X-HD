# normativ HPS design

Design HPS according to normative standards in this GUI

This GUI supports the design of heat pump systems containing: heat pump, heating rod, space heating storage tank and domestic hot water storage tank.
The calculation procedure is according to DIN EN 15450 or VDI 4645.

The heat demand is calculated with building performance simulations. Models are automatically created and simulated within the Teaser environment.
Therefore, nominmal outdoor temperature are estimated according to the standard.

With respect to annual heat demands, weather data is taken from DWD according to the location of the building.

# Get started

To get started you need to install the following Python packages first:
* Teaser
* json
* openpyxl
* PyQt5
* Dash
* DyMat
* SciPy

Also the Modelica Library AixLib needs to be available.

In the file Functions_GUI/Functions.py you have to update the paths to Dymola (l. 11), AixLib (l. 12), output-folder for Teaser (l.13) and an compiler (l.14).

There are two different GUIs implemented. One is a local GUI generated with PyQt5, the other is a WebApp created with Dash. To run these, change to the directory where `GUI_NormativeDesign.py` and `app.py` are located. To start the local GUI run `python GUI_NormativeDesign.py`. For the WebApp run `python app.py` and press the link in the output.

This repository is still in developement, so minor bugs may occur.
