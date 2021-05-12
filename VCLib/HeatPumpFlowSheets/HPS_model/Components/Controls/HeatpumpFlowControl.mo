within VCLib.HeatPumpFlowSheets.HPS_model.Components.Controls;
model HeatpumpFlowControl
  "Controlling unit for mass flow rate through heat pump (when de-/activated)"

  /******************************* Parameters *******************************/
  parameter Modelica.SIunits.MassFlowRate m_flowGen = 0.25 "Mass flow rate in heat generation";

  /******************************* Components *******************************/
  Modelica.Blocks.Interfaces.BooleanInput Hp_OnOff annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={-50,110})));
  Modelica.Blocks.Interfaces.BooleanInput Hr_OnOff annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={32,110}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={52,110})));
  Modelica.Blocks.Logical.Or or1 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,50})));
  Modelica.Blocks.Logical.Switch switch1 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,2})));
  Modelica.Blocks.Sources.RealExpression dummyZero annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-50,34})));
  Modelica.Blocks.Sources.RealExpression dummyMassFlow(y=m_flowGen)
    annotation (Placement(transformation(extent={{60,24},{40,44}})));
  Modelica.Blocks.Interfaces.RealOutput m_flowHp
    "Mass flow rate through heat pump condenser in kg/s" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,-66})));
equation
  connect(Hp_OnOff, or1.u2) annotation (Line(points={{-50,110},{-50,70},{-8,70},
          {-8,62}}, color={255,0,255}));
  connect(or1.u1, Hr_OnOff) annotation (Line(points={{0,62},{0,70},{32,70},{32,110}},
        color={255,0,255}));
  connect(or1.y, switch1.u2)
    annotation (Line(points={{0,39},{0,14}}, color={255,0,255}));
  connect(dummyZero.y, switch1.u3)
    annotation (Line(points={{-39,34},{-8,34},{-8,14}}, color={0,0,127}));
  connect(dummyMassFlow.y, switch1.u1)
    annotation (Line(points={{39,34},{8,34},{8,14}}, color={0,0,127}));
  connect(switch1.y, m_flowHp)
    annotation (Line(points={{0,-9},{0,-66}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-60},
            {100,100}}), graphics={Rectangle(
          extent={{-100,100},{100,-60}},
          lineColor={0,0,0},
          lineThickness=1,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid), Text(
          extent={{-136,-80},{146,-136}},
          lineColor={0,0,0},
          lineThickness=1,
          fillColor={255,255,255},
          fillPattern=FillPattern.None,
          textString="%name")}), Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-60},{100,100}})));
end HeatpumpFlowControl;
