within VCLib.Components.Compressors.Utilities.Types;
type IsentropicPolynomialModels = enumeration(
    DarrAndCrawford1992
    "DarrAndCrawford1992 - Function of rotational speed and densities",
    Karlsson2007
    "Karlsson2007 - Function of pressure ratio and rotational speed",
    Engelpracht2017
    "Engelpracht2017 - Function of pressure ratio and rotational speed")
  "Enumeration to define polynomial models for calculating isentropic efficiency"
  annotation (Evaluate=true);
