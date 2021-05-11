within VCLib.Components.Compressors.ModularPhysicalCompressors.Reciprocating.BaseClasses.Utilities;
function ReciprocatingMediumSelect
  input
    VCLib.Components.Compressors.ModularPhysicalCompressors.Reciprocating.BaseClasses.mediumtypes
    mediumtypes;

  output Modelica.Units.SI.Temperature Tevap;
  output Modelica.Units.SI.Pressure Pevap;
 output Integer nportsevap;
  output Modelica.Units.SI.Temperature Tcond;
  output Modelica.Units.SI.Pressure Pcond;
 output Integer nportscond;
  output Modelica.Units.SI.AngularVelocity speed;

algorithm
  if mediumtypes == VCLib.Components.Compressors.ModularPhysicalCompressors.Reciprocating.BaseClasses.mediumtypes.R32 then
     Tevap:=290.15;
     Pevap:=813100;
     nportsevap:=1;
     Tcond:=373.15;
     Pcond:=6293000;
     nportscond:=1;
     speed:=300;

     return;
  elseif mediumtypes == VCLib.Components.Compressors.ModularPhysicalCompressors.Reciprocating.BaseClasses.mediumtypes.R744 then
     Tevap:=290.15;
     Pevap:=813100;
     nportsevap:=1;
     Tcond:=373.15;
     Pcond:=6293000;
     nportscond:=1;
     speed:=300;
   return;
  elseif mediumtypes == VCLib.Components.Compressors.ModularPhysicalCompressors.Reciprocating.BaseClasses.mediumtypes.R410A then
    Tevap:=290.15;
     Pevap:=813100;
     nportsevap:=1;
     Tcond:=373.15;
     Pcond:=6293000;
     nportscond:=1;
     speed:=300;
     return;
  elseif mediumtypes == VCLib.Components.Compressors.ModularPhysicalCompressors.Reciprocating.BaseClasses.mediumtypes.R290 then
    Tevap:=290.15;
     Pevap:=813100;
     nportsevap:=1;
     Tcond:=373.15;
     Pcond:=6293000;
     nportscond:=1;
     speed:=300;
     return;

  elseif mediumtypes == VCLib.Components.Compressors.ModularPhysicalCompressors.Reciprocating.BaseClasses.mediumtypes.R134a then
     Tevap:=290.15;
     Pevap:=813100;
     nportsevap:=1;
     Tcond:=373.15;
     Pcond:=6293000;
     nportscond:=1;
     speed:=300;
     return;
   end if;

end ReciprocatingMediumSelect;
