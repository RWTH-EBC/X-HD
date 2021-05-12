within VCLib.HeatPumpFlowSheets.HPS_model.Components.Controls;
model TSupplySetControl
  "Controller to switch between set supply temperatures that are need for each demand"

  /******************************* Parameters *******************************/

  parameter Modelica.SIunits.TemperatureDifference dT_loading = 10 "Temperature difference between generation and storage loading";

  /******************************* Components *******************************/
  Modelica.Blocks.Interfaces.BooleanInput buffer_on
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,112})));
  Modelica.Blocks.Interfaces.BooleanInput dhw_on
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={-40,112})));
  Modelica.Blocks.Interfaces.RealInput T_buf_set "Set temperature of buffer storage in K "
    annotation (Placement(transformation(extent={{-134,30},{-94,70}})));
  Modelica.Blocks.Interfaces.RealInput T_dhw_set "Dhw storage set temperature in K"
    annotation (Placement(transformation(extent={{-134,-56},{-94,-16}})));
  Modelica.Blocks.Interfaces.RealOutput y annotation (Placement(transformation(extent={{96,-10},{116,10}})));
  Modelica.Blocks.Logical.Switch switch1
    annotation (Placement(transformation(extent={{-12,10},{8,-10}})));
  Modelica.Blocks.Math.Add add(u2=dT_loading)
    annotation (Placement(transformation(extent={{36,-16},{56,4}})));
equation
  connect(dhw_on, switch1.u2)
    annotation (Line(points={{-40,112},{-40,0},{-14,0}}, color={255,0,255}));
  connect(T_buf_set, switch1.u3) annotation (Line(points={{-114,50},{-68,50},{
          -68,8},{-14,8}}, color={0,0,127}));
  connect(T_dhw_set, switch1.u1) annotation (Line(points={{-114,-36},{-68,-36},
          {-68,-8},{-14,-8}}, color={0,0,127}));
  connect(switch1.y, add.u1)
    annotation (Line(points={{9,0},{34,0}}, color={0,0,127}));
  connect(add.y, y) annotation (Line(points={{57,-6},{72,-6},{72,0},{106,0}},
        color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          lineThickness=1,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid), Text(
          extent={{-116,-110},{118,-190}},
          lineColor={0,0,0},
          lineThickness=1,
          fillColor={255,255,255},
          fillPattern=FillPattern.None,
          textString="%name")}),                                 Diagram(coordinateSystem(preserveAspectRatio=false)));
end TSupplySetControl;
