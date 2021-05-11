within VCLib.Components.Compressors.Utilities.Types;
type VolumetricPolynomialModels = enumeration(
    DarrAndCrawford1992
    "DarrAndCrawford1992 - Function of rotational speed and densities",
    Karlsson2007
    "Karlsson2007 - Function of pressure ratio and rotational speed",
    KinarbEtAl2010
    "KinarbEtAl2010 - Function of pressure ratio",
    ZhouEtAl2010
    "ZhouEtAl2010 - Function of pressure ratio and isentropic exponent",
    Li2013
    "Li2013 - Function of rotational speed and reference rotational speed",
    HongtaoLaughmannEtAl2017
    "HongtaoLaughmannEtAl2017 - Function of pressures and rotational speed",
    Koerner2017
    "Koerner2017 - Function of pressure ratio",
    Engelpracht2017
    "Engelpracht2017 - Function of pressure ratio and rotational speed")
  "Enumeration to define polynomial models for calculating volumetric efficiency"
  annotation (Evaluate=true);
