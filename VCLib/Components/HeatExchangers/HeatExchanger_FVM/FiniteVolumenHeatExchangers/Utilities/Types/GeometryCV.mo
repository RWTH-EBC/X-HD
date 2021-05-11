within VCLib.Components.HeatExchangers.HeatExchanger_FVM.FiniteVolumenHeatExchangers.Utilities.Types;
type GeometryCV = enumeration(
    Circular
    "Cross-sectional geometry - Circular heat exchanger",
    Plate
    "Cross-sectional geometry - Plate heat exchanger")
  "Enumeration to define the heat exchanger's cross-sectional geometry"
  annotation (Evaluate=true);
