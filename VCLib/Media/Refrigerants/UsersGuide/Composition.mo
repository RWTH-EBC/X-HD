within VCLib.Media.Refrigerants.UsersGuide;
class Composition "Composition of the regrigerant library"
  extends Modelica.Icons.Information;

  annotation (Documentation(info="<html>
<p>
The refrigerants' library consists mainly of five packages.
</p>
<ol>
<li>
<a href=\"modelica://VCLib.Media.Refrigerants.Interfaces\">Interfaces:</a> 
Contains both templates to create new refrigerant models and partial models 
of the modeling approaches implemented in the library.</li>
<li>
<a href=\"modelica://VCLib.DataBase.Media.Refrigerants\">DataBases:</a> 
Contains records with fitting coefficients used for, for example, different 
modeling approaches implemented in the library.</li>
<li>
<a href=\"modelica://VCLib.Media.Refrigerants.R134a\">Refrigerants:</a> 
Packages of different refrigerants which contain refrigerant models ready 
to use.</li>
<li>
<a href=\"modelica://VCLib.Media.Refrigerants.Examples\">Examples:</a> 
Contains example models to show the functionality of the 
refrigerant models.</li>
<li>
<a href=\"modelica://VCLib.Media.Refrigerants.Validation\">Validation:</a> 
Contains validation models to validate the modeling approaches 
implemented in the library.</li>
</ol>
<p>
The ready to use models are provided in the following packages:
</p>
<ul>
<li><a href=\"modelica://VCLib.Media.Refrigerants.R134a\">R134a</a></li>
<li><a href=\"modelica://VCLib.Media.Refrigerants.R290\">R290</a></li>
<li><a href=\"modelica://VCLib.Media.Refrigerants.R410A\">R410A</a></li>
<li><a href=\"modelica://VCLib.Media.Refrigerants.R32\">R32</a></li>
<li><a href=\"modelica://VCLib.Media.Refrigerants.R744\">R744</a></li>
</ul>
</html>", revisions="<html>
<ul>
  <li>
  October 14, 2017, by Mirko Engelpracht and Christian Vering:<br/>
  First implementation
  (see <a href=\"https://github.com/RWTH-EBC/AixLib/issues/408\">issue 408</a>).
  </li>
</ul>
</html>"));
end Composition;
