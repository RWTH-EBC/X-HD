within VCLib.HeatPumpFlowSheets.HPS_model.Components.Controls;
model HeatCurve
  "Defines T_supply of buffer storage tank (in dependency of ambient temperature)"

  Modelica.Blocks.Interfaces.RealInput T_Amb
    annotation (Placement(transformation(extent={{-140,30},{-100,70}})));
  Modelica.Blocks.Interfaces.RealOutput T_Set
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

parameter Modelica.SIunits.Temperature T_Buffer_Thres = 295.15 "Expected room temperature (22°C)";

  Modelica.Blocks.Interfaces.RealInput T_Thres "Heating threshold temperature (15°C)" annotation (Placement(transformation(extent={{-140,-70},{-100,-30}})));

  Modelica.Blocks.Interfaces.RealInput m "Slope of heat curve"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
equation
  T_Set = m*(T_Buffer_Thres-T_Amb) + T_Buffer_Thres;

  annotation (Icon(graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
                             Text(
          extent={{-100,230},{100,30}},
          lineColor={0,0,0},
          textString="%name")}));
end HeatCurve;
