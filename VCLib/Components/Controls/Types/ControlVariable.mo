within VCLib.Components.Controls.Types;
type ControlVariable = enumeration(
    pEva
    "Pressure of evaporation",
    pCon
    "Pressure of condensation",
    TEva
    "Temperature of evaporation",
    TCon
    "Temperature of condensation",
    TSupHea
    "Degree of superheating at evaporator's outlet",
    TSupCol
    "Degree of supercooling at condenser's outlet",
    TCol
    "Temperature at source-sided evaporator's outlet (Cooling temperature)",
    THea
    "Temperature at sink-sided condenser's outlet (Heating temperature)",
    QFloCol
    "Cooling capacity if system works as chiller",
    QFloHea
    "Heating capacity if system works as heat pump")
  "Enumeration to control variables of expansion valves"
  annotation (Evaluate=true);
