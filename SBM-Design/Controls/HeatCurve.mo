within Configurations.Controls;
model HeatCurve

  Modelica.Blocks.Interfaces.RealInput T_Amb
    annotation (Placement(transformation(extent={{-140,30},{-100,70}})));
  Modelica.Blocks.Interfaces.RealOutput T_Set
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

parameter Modelica.SIunits.Temperature T_Buffer_Thres = 293.15;

  Modelica.Blocks.Interfaces.RealInput T_Thres annotation (Placement(transformation(extent={{-140,-70},{-100,-30}})));

  Modelica.Blocks.Interfaces.RealInput m
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
equation
  T_Set = m*(T_Thres-T_Amb) + T_Buffer_Thres;

  annotation (Icon(graphics={Text(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          textString="HeatCurve")}));
end HeatCurve;
