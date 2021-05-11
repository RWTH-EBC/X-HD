within VCLib.Components.HeatExchangers.HeatExchanger_FVM.FiniteVolumenHeatExchangers.Utilities.Types;
type CalculationCoefficientOfHeatTransfer = enumeration(
    Constant
    "Constant - Simple model of a constant heat transfer coefficient",
    Kandlikar                                                                    "heat transfer coefficient depends on characteristics of flow and phase")
  "Enumeration to define methods of calculating coefficient of heat transfer"
  annotation (Evaluate=true);
