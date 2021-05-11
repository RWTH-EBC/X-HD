within VCLib.Components.Controls.Types;
type heatPumpMode = enumeration(
    heatPump
    "Heat pump is used as heat pump",
    chiller
    "Heat pump is used as chiller")
  "Enumeration to define mode of heat pump"
  annotation (Evaluate=true);
