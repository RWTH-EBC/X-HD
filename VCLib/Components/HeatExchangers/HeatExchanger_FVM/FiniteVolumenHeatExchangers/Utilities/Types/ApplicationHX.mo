within VCLib.Components.HeatExchangers.HeatExchanger_FVM.FiniteVolumenHeatExchangers.Utilities.Types;
type ApplicationHX = enumeration(
    Evaporator
    "Evaporator",
    Condenser
    "Condenser")
  "Enumeration to define the application of the heat exchanger"
  annotation (Evaluate=true);
