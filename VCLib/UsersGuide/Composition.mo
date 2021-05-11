within VCLib.UsersGuide;
class Composition "Composition of the vapor compression cycle library"
  extends Modelica.Icons.Information;

  annotation (Documentation(info="<html>
<p>
The library of vapor compression cycles consists mainly of four packages.
</p>
<ol>
<li>
<a href=\"modelica://VCLib.Components\">
Components:</a> 
Contains component models of vapor compression cycles. These models are used, 
for example, in modular heat pump models. The level of detail differs from 
black-box, to gray-box and white-box models.</li>
<li>
<a href=\"modelica://VCLib.DataBase\">
DataBase:</a> 
Contains DataBase models such as for heat pump performance maps, which are not
implemented, yet. In addition, the coefficients of refrigerants for the media 
models are implemented there.</li>
<li>
<a href=\"modelica://VCLib.Media\">
Media:</a> 
Contains fluid property models to compute the behaviour of the fluid.</li>
<li>
<a href=\"modelica://VCLib.HeatPumpFlowSheets\">
HeatPumpFlowSheets:</a> 
Contains example models to test vapor compression cycles for heating purposes
implemented in the library.</li>
</ol>
</html>", revisions="<html>
<ul>
  <li>
  October, 2017, by Mirko Engelpracht and Christian Vering:<br/>
  First implementation
  (see <a href=\"https://github.com/RWTH-EBC/AixLib/issues/457\">issue 457</a>).
  </li>
</ul>
<ul>
  <li>
  August 28, 2018, by Sven Hinrichs, Christian Vering:<br/>
  First implementation
  (see <a href=\"https://github.com/RWTH-EBC/AixLib/issues/590\">issue 590</a>).
  </li>
    <li>
    May 9, 2021, by Christian Vering:<br/>
  Alignments
   </li>
</ul>
</html>"));
end Composition;
