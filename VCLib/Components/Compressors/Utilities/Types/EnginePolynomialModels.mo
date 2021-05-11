within VCLib.Components.Compressors.Utilities.Types;
type EnginePolynomialModels = enumeration(
    JahningEtAl2000
    "JahningEtAl2000 - Function of inlet pressure",
    KinarbEtAl2010
    "KinarbEtAl2010 - Function of pressure ratio",
    DurprezEtAl2007
    "DurprezEtAl2007 - Function of pressure ratio",
    Engelpracht2017
    "Engelpracht2017 - Function of pressure ratio and rotational speed")
  "Enumeration to define polynomial models for calculating engine efficiency"
  annotation (Evaluate=true);
