within ;
package Configurations
extends Modelica.Icons.Package;

annotation (uses(
    Modelica(version="3.2.2"),
    SOvEMS(version="1"),
    MAkbr(version="1"),
    AixLib(version="0.7.3")),
  experiment,
  __Dymola_experimentSetupOutput(events=false),
  __Dymola_experimentFlags(
    Advanced(GenerateVariableDependencies=false, OutputModelicaCode=false),
    Evaluate=false,
    OutputCPUtime=false,
    OutputFlatModelica=false),
  version="1",
  conversion(noneFromVersion=""));
end Configurations;
