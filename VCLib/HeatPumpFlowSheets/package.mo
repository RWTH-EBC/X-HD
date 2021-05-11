within VCLib;
package HeatPumpFlowSheets "Package with examples for heat pummp flow sheets"


annotation (Icon(graphics={
        Rectangle(
          lineColor={200,200,200},
          fillColor={248,248,248},
          fillPattern=FillPattern.HorizontalCylinder,
          extent={{-100,-100},{100,100}},
          radius=25.0),
      Line(points={{-76,66},{74,66},{74,-76},{-76,-76},{-76,66}}, color={0,0,0}),
      Line(points={{-90,30},{-62,-36},{-90,-36},{-64,30},{-90,30}}, color={0,0,
            0}),
      Line(points={{-32,80},{-32,48},{32,48},{32,80},{8,80},{-32,80}}, color={0,
            0,0}),
      Line(points={{-16,92},{-16,54},{0,70},{16,54},{16,76},{16,92}}, color={0,
            0,0}),
      Line(points={{-18,-104},{-18,-66},{-2,-82},{14,-66},{14,-88},{14,-104}},
          color={0,0,0}),
      Line(points={{-34,-58},{-34,-90},{30,-90},{30,-58},{6,-58},{-34,-58}},
          color={0,0,0}),
      Ellipse(
        extent={{98,26},{54,-18}},
        lineColor={0,0,0},
        fillPattern=FillPattern.HorizontalCylinder,
        fillColor={248,248,248}),
      Line(points={{68,24},{60,-12}}, color={0,0,0}),
      Line(points={{82,24},{92,-12}}, color={0,0,0})}));
end HeatPumpFlowSheets;
