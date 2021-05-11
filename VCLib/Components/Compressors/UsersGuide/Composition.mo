within VCLib.Components.Compressors.UsersGuide;
class Composition "Composition of the compressors library"
  extends Modelica.Icons.Information;

  annotation (Documentation(info="<html>
<p>
The library of the compressors consists mainly of six packages.
</p>
<ol>
<li>
<a href=\"modelica://VCLib.Components.Compressors.ModularCompressors\">
ModularCompressors:</a> 
Contains models of modular compressors. These models are used, for
example, in modular heat pump models.</li>
<li>
<a href=\"modelica://VCLib.Components.Compressors.SimpleCompressors\">
SimpleCompressors:</a> 
Contains models of simple compressors. These models are used, for
example, in simple heat pump models.</li>
<li>
<a href=\"modelica://VCLib.Components.Compressors.ModularPhysicalCompressors\">
ModularPhysicalCompressors:</a> 
Contains models of quasi white-box compressors. These models are used, for
example, in detailed heat pump models. The VCLib covers to initial models, one
reciprocating compressor model and one rolling type piston compressor.</li>
<li>
<a href=\"modelica://VCLib.Components.Compressors.Utilities\">
Utilities:</a> 
Contains utility models such as for efficiency calculation 
that are used throughout the library.</li>
<li>
<a href=\"modelica://VCLib.Components.Compressors.BaseClasses\">
BaseClasses:</a> 
Contains base models such as partial models for simple or modular
compressors that are used throughout the library.</li>
<li>
<a href=\"modelica://VCLib.Components.Compressors.Examples\">
Examples:</a> 
Contains example models to test the compressors
implemented in the library.</li>
<li>
<a href=\"modelica://VCLib.Components.Compressors.Validation\">
Validation:</a> 
Contains validation models to test the compressor's
modelling approaches.</li>
</ol>
</html>", revisions="<html>
<ul>
  <li>
  October 19, 2017, by Mirko Engelpracht:<br/>
  First implementation
  (see <a href=\"https://github.com/RWTH-EBC/AixLib/issues/467\">issue 467</a>).
  </li>
      <li>
    May 9, 2021, by Christian Vering:<br/>
  Alignments
    </li>
</ul>
</html>"));
end Composition;
