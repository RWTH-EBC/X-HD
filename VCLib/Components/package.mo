within VCLib;
package Components "Package with models for fluid flow systems"
  extends Modelica.Icons.Package;









  annotation (Icon(graphics={
        Rectangle(
          extent={{-18,50},{22,42}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Line(points={{2,42},{2,-10}}),
        Polygon(points={{-70,26},{68,-44},{68,26},{2,-10},{-70,-42},{-70,26}},
            lineColor={0,0,0})}),Documentation(revisions="<html>
<ul>
  <li>
  May, 2021, by Christian Vering:<br/>
  First implementation
  <li>
    May, 2021, by Christian Vering:<br/>
    Alignment of all simulation models
   </li>
</ul>
</html>", info="<html>
<p>
This package contains component models for compressors, expansion valves,
heat exchangers and additionals components to develop vapor compression cylce
models.
</p>
</html>"));



end Components;
