within VCLib.Components.Compressors.Utilities.Types;
type SimpleCompressor = enumeration(
    Default
    "Default value used for partial compressor",
    RotaryCompressor
    "Simple rotary compressor",
    RotaryCompressorPressureLosses
    "Simple rotary compressor with pressure losses",
    RotaryCompressorPressureHeatLosses
    "Simple rotary compressor with pressure and heat losses")
  "Enumeration to define simple compressor model"
  annotation (Evaluate=true);
