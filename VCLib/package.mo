within ;
package VCLib "Vapor Compression Library"
extends Modelica.Icons.Package;













annotation (uses(
    AixLib(version="0.7.3"),
    Modelica(version="4.0.0"),
    ModelicaServices(version="4.0.0")),
                           version="1.0.4",
  conversion(from(version={"2","1"}, script=
          "modelica://VCLib/ConvertFromVCLib_2.mos")),Documentation(revisions="<html>
<ul>
  <li>
  May, 2021, by Christian Vering:<br/>
  First implementation
  <li>
    <li>
    May, 2021, by Fabian Wüllhorst:<br/>
    Heat pump flow sheet investigations
    </li>
       <li>
    May, 2021, by Philipp Mehrfeld:<br/>
    Library review
    </li>
       <li>
    May, 2021, by Christian Vering:<br/>
    Alignment of all simulation models
   </li>
</ul>
</html>", info="<html>
<p>
This package contains component models for compressors, expansion valves,
heat exchangers, refrigerants and additionals components to develop vapor 
compression cylce (VC) models, which are summarized in a modular and scalabe
library, called: VCLib
</p>
</html>"));
end VCLib;
