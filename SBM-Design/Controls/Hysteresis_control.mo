within Configurations.Controls;
model Hysteresis_control

  Modelica.Blocks.Interfaces.RealInput T_Top
    annotation (Placement(transformation(extent={{-136,32},{-100,68}}),
        iconTransformation(extent={{-116,52},{-100,68}})));
  Modelica.Blocks.Interfaces.BooleanOutput WP_an
    annotation (Placement(transformation(extent={{100,-10},{120,10}}),
        iconTransformation(extent={{100,-14},{128,14}})));

  discrete Integer zustand(start = 1);
  parameter Real dT = 2;
  parameter Real dTads = 2;
  parameter Real T_MaxAds = 333.15;
  parameter Real T_Min = 313.15 "K";
  parameter Real T_Max = 333.15 "K";

/*initial equation 
  pre(Lade_Speicher1) = true;
  pre(Lade_Speicher2) = false;
  pre(Entlade_Speicher1) = false;
  pre(Entlade_Speicher2) = false;
  pre(zustand) = 1; */

  Modelica.Blocks.Interfaces.RealOutput T_Min_out
    annotation (Placement(transformation(extent={{100,-42},{120,-22}})));

equation
  T_Min_out = T_Min;

  if (((pre(zustand) == 1) and (T_Top < (T_Max))) or ((pre(zustand) == 2) and (T_Top <= T_Min))) then
    WP_an = true;
    zustand            = 1;
  elseif (((pre(zustand) == 1) and (T_Top >= T_Max)) or ((pre(zustand) == 2) and (T_Top > T_Min))) then
    WP_an = false;
    zustand            = 2;
  else
    WP_an = true;
    zustand            = 1;
  end if;
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -80},{100,60}})),             Icon(coordinateSystem(extent={{-100,-60},
            {100,60}},  preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,60},{100,-60}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5),
        Text(
          extent={{-92,52},{-38,20}},
          lineColor={0,0,127},
          textString="T_Top"),
        Text(
          extent={{-94,14},{-42,-14}},
          lineColor={0,0,127},
          textString="T_Min"),
        Text(
          extent={{-92,-28},{-36,-54}},
          lineColor={0,0,127},
          textString="T_Max"),
        Text(
          extent={{26,16},{92,-10}},
          lineColor={255,0,255},
          textString="WP_an")}));
end Hysteresis_control;
