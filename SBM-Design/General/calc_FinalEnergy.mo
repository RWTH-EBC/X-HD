within Configurations.General;
model calc_FinalEnergy


  Modelica.Blocks.Interfaces.RealInput Q_flow_HP_DHW
    annotation (Placement(transformation(extent={{-124,70},{-84,110}})));
  Modelica.Blocks.Interfaces.RealInput COP_DHW
    annotation (Placement(transformation(extent={{-124,32},{-84,72}})));
  Modelica.Blocks.Interfaces.RealInput Q_flow_HP_Buffer
    annotation (Placement(transformation(extent={{-124,-6},{-84,34}})));
  Modelica.Blocks.Interfaces.RealInput COP_Buffer
    annotation (Placement(transformation(extent={{-124,-44},{-84,-4}})));
  Modelica.Blocks.Interfaces.RealInput Q_flow_HR_Buffer
    annotation (Placement(transformation(extent={{-124,-80},{-84,-40}})));
  Modelica.Blocks.Interfaces.RealInput Q_flow_HR_DHW
    annotation (Placement(transformation(extent={{-124,-116},{-84,-76}}),
        iconTransformation(extent={{-124,-116},{-84,-76}})));
  Modelica.Blocks.Interfaces.RealInput P_pump_HP_Buffer annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={-40,112})));
  Modelica.Blocks.Interfaces.RealInput P_pump_demand annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={82,112})));
  Modelica.Blocks.Interfaces.RealInput P_pump_HP_DHW annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={22,112})));
  Modelica.Blocks.Math.Division division
    annotation (Placement(transformation(extent={{-60,60},{-46,74}})));
  Modelica.Blocks.Interfaces.RealOutput P_el_HP_DHW
    annotation (Placement(transformation(extent={{98,70},{118,90}})));
  Modelica.Blocks.Interfaces.RealOutput P_el_HP_Buffer
    annotation (Placement(transformation(extent={{98,-10},{118,10}})));
  Modelica.Blocks.Math.Division division1
    annotation (Placement(transformation(extent={{-16,-4},{-2,10}})));
  Modelica.Blocks.Interfaces.RealOutput P_el_HR_DHW
    annotation (Placement(transformation(extent={{96,-90},{116,-70}})));
  Modelica.Blocks.Interfaces.RealOutput P_el_HR_Buffer
    annotation (Placement(transformation(extent={{98,-50},{118,-30}}),
        iconTransformation(extent={{98,-50},{118,-30}})));
  Modelica.Blocks.Sources.Constant const(k=eta_HR)
    annotation (Placement(transformation(extent={{-64,-80},{-48,-64}})));
  Modelica.Blocks.Math.Division division2
    annotation (Placement(transformation(extent={{-28,-66},{-14,-52}})));
  Modelica.Blocks.Math.Division division3
    annotation (Placement(transformation(extent={{-28,-92},{-14,-78}})));
  Modelica.Blocks.Logical.GreaterThreshold greaterThreshold
    annotation (Placement(transformation(extent={{-70,-28},{-58,-16}})));
  Modelica.Blocks.Logical.Switch switch1
    annotation (Placement(transformation(extent={{-40,-30},{-26,-16}})));
  Modelica.Blocks.Sources.Constant const1(k=1)
    annotation (Placement(transformation(extent={{-80,-50},{-64,-34}})));
  Modelica.Blocks.Logical.Switch switch2
    annotation (Placement(transformation(extent={{-62,28},{-48,42}})));
  Modelica.Blocks.Logical.GreaterThreshold greaterThreshold1
    annotation (Placement(transformation(extent={{-86,30},{-74,42}})));

  parameter Real eta_HR = 0.97;
  parameter Real Quality_Grade = 0.55;


  Modelica.Blocks.Sources.Constant const2(k=Quality_Grade)
    annotation (Placement(transformation(extent={{0,58},{14,44}})));
  Modelica.Blocks.Math.Division division4
    annotation (Placement(transformation(extent={{32,56},{46,70}})));
  Modelica.Blocks.Math.Division division5
    annotation (Placement(transformation(extent={{34,-4},{48,10}})));
equation


  connect(Q_flow_HP_DHW, division.u1) annotation (Line(points={{-104,90},{-84,
          90},{-84,71.2},{-61.4,71.2}},
                              color={0,0,127}));
  connect(Q_flow_HP_Buffer, division1.u1) annotation (Line(points={{-104,14},{
          -86,14},{-86,7.2},{-17.4,7.2}},
                                color={0,0,127}));
  connect(Q_flow_HR_Buffer, division2.u1) annotation (Line(points={{-104,-60},{
          -68,-60},{-68,-54.8},{-29.4,-54.8}}, color={0,0,127}));
  connect(const.y, division2.u2) annotation (Line(points={{-47.2,-72},{-38.6,
          -72},{-38.6,-63.2},{-29.4,-63.2}}, color={0,0,127}));
  connect(Q_flow_HR_DHW, division3.u1) annotation (Line(points={{-104,-96},{-70,
          -96},{-70,-80.8},{-29.4,-80.8}}, color={0,0,127}));
  connect(const.y, division3.u2) annotation (Line(points={{-47.2,-72},{-38,-72},
          {-38,-89.2},{-29.4,-89.2}}, color={0,0,127}));
  connect(division2.y, P_el_HR_Buffer) annotation (Line(points={{-13.3,-59},{
          41.35,-59},{41.35,-40},{108,-40}}, color={0,0,127}));
  connect(division3.y, P_el_HR_DHW) annotation (Line(points={{-13.3,-85},{42.35,
          -85},{42.35,-80},{106,-80}}, color={0,0,127}));
  connect(greaterThreshold.y, switch1.u2) annotation (Line(points={{-57.4,-22},
          {-50,-22},{-50,-23},{-41.4,-23}}, color={255,0,255}));
  connect(COP_Buffer, greaterThreshold.u) annotation (Line(points={{-104,-24},{
          -88,-24},{-88,-22},{-71.2,-22}}, color={0,0,127}));
  connect(COP_Buffer, switch1.u1) annotation (Line(points={{-104,-24},{-74,-24},
          {-74,-17.4},{-41.4,-17.4}}, color={0,0,127}));
  connect(const1.y, switch1.u3) annotation (Line(points={{-63.2,-42},{-48,-42},
          {-48,-28.6},{-41.4,-28.6}}, color={0,0,127}));
  connect(switch1.y, division1.u2) annotation (Line(points={{-25.3,-23},{-25.3,
          -12.5},{-17.4,-12.5},{-17.4,-1.2}}, color={0,0,127}));
  connect(COP_DHW, greaterThreshold1.u) annotation (Line(points={{-104,52},{-96,
          52},{-96,36},{-87.2,36}}, color={0,0,127}));
  connect(greaterThreshold1.y, switch2.u2) annotation (Line(points={{-73.4,36},
          {-68,36},{-68,35},{-63.4,35}}, color={255,0,255}));
  connect(COP_DHW, switch2.u1) annotation (Line(points={{-104,52},{-68,52},{-68,
          40.6},{-63.4,40.6}}, color={0,0,127}));
  connect(const1.y, switch2.u3) annotation (Line(points={{-63.2,-42},{-60,-42},
          {-60,29.4},{-63.4,29.4}}, color={0,0,127}));
  connect(switch2.y, division.u2) annotation (Line(points={{-47.3,35},{-47.3,
          48.5},{-61.4,48.5},{-61.4,62.8}}, color={0,0,127}));
  connect(const2.y, division4.u2) annotation (Line(points={{14.7,51},{22.35,51},
          {22.35,58.8},{30.6,58.8}}, color={0,0,127}));
  connect(division.y, division4.u1) annotation (Line(points={{-45.3,67},{-7.65,67},
          {-7.65,67.2},{30.6,67.2}}, color={0,0,127}));
  connect(division4.y, P_el_HP_DHW) annotation (Line(points={{46.7,63},{71.35,63},
          {71.35,80},{108,80}}, color={0,0,127}));
  connect(const2.y, division5.u2) annotation (Line(points={{14.7,51},{14.7,-1.5},
          {32.6,-1.5},{32.6,-1.2}}, color={0,0,127}));
  connect(division1.y, division5.u1) annotation (Line(points={{-1.3,3},{15.35,3},
          {15.35,7.2},{32.6,7.2}}, color={0,0,127}));
  connect(division5.y, P_el_HP_Buffer) annotation (Line(points={{48.7,3},{73.35,
          3},{73.35,0},{108,0}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={28,108,200},
          fillColor={255,128,0},
          fillPattern=FillPattern.Solid), Text(
          extent={{-54,26},{54,-26}},
          lineColor={28,108,200},
          fillColor={255,128,0},
          fillPattern=FillPattern.Solid,
          textString="Final energy calculation")}),              Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end calc_FinalEnergy;
