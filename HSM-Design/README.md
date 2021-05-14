# normativ HPS design

Design HPS according to normative standards with a simple GUI

This GUI supports the design of heat pump systems containing: heat pump, heating rod, space heating storage tank and domestic hot water storage tank.
The calculation procedure is according to DIN EN 15450 or VDI 4645.

The heat demand is calculated with building performance simulations. Models are automatically created and simulated within the Teaser environment.
Therefore, nominal outdoor temperatures are estimated according to the standard.

With respect to annual heat demands, weather data is taken from DWD according to the location of the building.

# Get started
To get started clone this Repository with `git clone --recurse-submodules`.
Then install the Python packages listed in requirements.txt.
Also the Modelica Library [AixLib](https://github.com/RWTH-EBC/AixLib) (which is one of the submodules) needs to be available .

In the file Functions_GUI/Functions.py you have to update the paths to Dymola (l. 12), and the compiler (l.13).

There are two different GUIs implemented. One is a local GUI generated with PyQt5, the other is a WebApp created with Dash. To run these, change to the directory where `GUI_NormativeDesign.py` and `app.py` are located. To start the local GUI run `python GUI_NormativeDesign.py`. For the WebApp run `python app.py` and press the link in the output.

Currently, the final design is printed to command line.
Since this repository is still in development, minor bugs may occur. If errors occur, please consider restarting the app.


