within Configurations.Controls;
model Control_HPBuffer
  parameter Real Hysteresis = 10;
  parameter Real TSet = 323.15;
  parameter Real T_Min_Storage = 313.15 "K";
  parameter Real T_Max_Storage = 333.15 "K";
  parameter Real HeatingRod_Max = HR_QMax.k "W";

  Modelica.Blocks.Interfaces.RealInput Q_HP_actual1
    annotation (Placement(transformation(extent={{-120,-50},{-80,-10}})));
  Modelica.Blocks.Interfaces.RealInput T_Top1
    annotation (Placement(transformation(extent={{-120,-108},{-80,-68}})));
  Modelica.Blocks.Interfaces.RealInput Q_demand1
    annotation (Placement(transformation(extent={{-120,70},{-80,110}})));
  Modelica.Blocks.Interfaces.RealOutput switch_HeatPump_OnOff
    "Connector of Real output signal"
    annotation (Placement(transformation(extent={{98,-70},{118,-50}})));
  Modelica.Blocks.Interfaces.RealOutput Q_HeatingRod_OnOff
    "Connector of Real output signal"
    annotation (Placement(transformation(extent={{96,50},{116,70}})));
  Modelica.Blocks.Logical.Switch switch1
    annotation (Placement(transformation(extent={{56,-66},{68,-54}})));
  Modelica.Blocks.Sources.Constant Q_HeatPump_rel_max(k=1)
    annotation (Placement(transformation(extent={{-36,-40},{-24,-28}})));
  Modelica.Blocks.Sources.Constant Q_HeatPump_rel_min(k=0)
    annotation (Placement(transformation(extent={{-28,-96},{-8,-76}})));
  Modelica.Blocks.Sources.Constant Q_HeatingRod_rel(k=0)
    annotation (Placement(transformation(extent={{24,-22},{40,-6}})));
  Modelica.Blocks.Logical.Switch switch2
    annotation (Placement(transformation(extent={{54,82},{66,94}})));
  Modelica.Blocks.Logical.Greater greater
    annotation (Placement(transformation(extent={{-32,0},{-12,20}})));
  Modelica.Blocks.Logical.And and1
    annotation (Placement(transformation(extent={{4,34},{14,44}})));
  Modelica.Blocks.Math.Add add(k1=-1, k2=-1)
    annotation (Placement(transformation(extent={{-18,74},{2,94}})));
  Modelica.Blocks.Math.Gain gain(k=-1)
    annotation (Placement(transformation(extent={{-68,6},{-60,14}})));
  Hysteresis_control hysteresis_control(T_Min=T_Min_Storage, T_Max=
        T_Max_Storage)
    annotation (Placement(transformation(extent={{-38,-64},{-10,-52}})));
  Modelica.Blocks.Logical.And and2
    annotation (Placement(transformation(extent={{26,34},{36,44}})));
  Modelica.Blocks.Logical.Less less
    annotation (Placement(transformation(extent={{10,6},{18,16}})));
  Modelica.Blocks.Sources.Constant HR_QMax(k=6000)
    annotation (Placement(transformation(extent={{-6,-6},{6,6}},
        rotation=90,
        origin={84,24})));
  Modelica.Blocks.Math.Division division
    annotation (Placement(transformation(extent={{78,80},{88,90}})));
  Modelica.Blocks.Interfaces.RealInput DHW_OnOff
    annotation (Placement(transformation(extent={{-120,10},{-80,50}})));
  Modelica.Blocks.Logical.And and3
    annotation (Placement(transformation(extent={{36,-46},{48,-34}})));
  Modelica.Blocks.Logical.And and4
    annotation (Placement(transformation(extent={{44,16},{54,26}})));
  Modelica.Blocks.Logical.LessEqualThreshold lessEqualThreshold
    annotation (Placement(transformation(extent={{-64,26},{-52,38}})));
equation
  connect(switch1.y, switch_HeatPump_OnOff)
    annotation (Line(points={{68.6,-60},{68.6,-60},{108,-60}},
                                                           color={0,0,127}));
  connect(switch1.u1, Q_HeatPump_rel_max.y) annotation (Line(points={{54.8,-55.2},
          {22,-55.2},{22,-34},{-23.4,-34}},
                                      color={0,0,127}));
  connect(Q_HeatPump_rel_min.y, switch1.u3) annotation (Line(points={{-7,-86},{-2,
          -86},{-2,-64.8},{54.8,-64.8}},
                                      color={0,0,127}));
  connect(greater.u2, Q_HP_actual1) annotation (Line(points={{-34,2},{-86,2},{-86,
          -30},{-100,-30}}, color={0,0,127}));
  connect(Q_HeatingRod_rel.y, switch2.u3) annotation (Line(points={{40.8,-14},{70,
          -14},{70,83.2},{52.8,83.2}},
                                color={0,0,127}));
  connect(and1.u1, greater.y) annotation (Line(points={{3,39},{-12,39},{-12,10},
          {-11,10}},     color={255,0,255}));
  connect(add.u1, Q_demand1)
    annotation (Line(points={{-20,90},{-38,90},{-100,90}}, color={0,0,127}));
  connect(add.u2, Q_HP_actual1) annotation (Line(points={{-20,78},{-42,78},{-42,
          -30},{-100,-30}},
                        color={0,0,127}));
  connect(gain.u, Q_demand1) annotation (Line(points={{-68.8,10},{-84,10},{-84,
          90},{-100,90}}, color={0,0,127}));
  connect(gain.y, greater.u1)
    annotation (Line(points={{-59.6,10},{-44,10},{-34,10}}, color={0,0,127}));
  connect(switch2.u1, add.y) annotation (Line(points={{52.8,92.8},{34,92.8},{34,
          84},{3,84}},
                  color={0,0,127}));
  connect(hysteresis_control.WP_an, and1.u2) annotation (Line(points={{-8.04,-58},
          {0,-58},{0,35},{3,35}},             color={255,0,255}));
  connect(T_Top1, hysteresis_control.T_Top) annotation (Line(points={{-100,-88},
          {-70,-88},{-70,-52},{-39.12,-52}}, color={0,0,127}));
  connect(and1.y, and2.u1) annotation (Line(points={{14.5,39},{20,39},{25,39}},
                color={255,0,255}));
  connect(less.y, and2.u2) annotation (Line(points={{18.4,11},{28,11},{28,35},{25,
          35}},         color={255,0,255}));
  connect(T_Top1, less.u1) annotation (Line(points={{-100,-88},{-46,-88},{-46,11},
          {9.2,11}}, color={0,0,127}));
  connect(hysteresis_control.T_Min_out, less.u2) annotation (Line(points={{-8.6,
          -61.2},{-8.6,-26.6},{9.2,-26.6},{9.2,7}},   color={0,0,127}));
  connect(switch2.y, division.u1) annotation (Line(points={{66.6,88},{70,88},{77,
          88}},         color={0,0,127}));
  connect(HR_QMax.y, division.u2) annotation (Line(points={{84,30.6},{84,30.6},{
          84,82},{77,82}},
                        color={0,0,127}));
  connect(division.y, Q_HeatingRod_OnOff) annotation (Line(points={{88.5,85},{91.25,
          85},{91.25,60},{106,60}}, color={0,0,127}));
  connect(hysteresis_control.WP_an, and3.u1) annotation (Line(points={{-8.04,-58},
          {14,-58},{14,-40},{34.8,-40}}, color={255,0,255}));
  connect(and3.y, switch1.u2) annotation (Line(points={{48.6,-40},{54.8,-40},{54.8,
          -60}}, color={255,0,255}));
  connect(and2.y, and4.u1) annotation (Line(points={{36.5,39},{36.5,22.5},{43,22.5},
          {43,21}}, color={255,0,255}));
  connect(and4.y, switch2.u2) annotation (Line(points={{54.5,21},{54.5,38.5},{52.8,
          38.5},{52.8,88}}, color={255,0,255}));
  connect(DHW_OnOff, lessEqualThreshold.u) annotation (Line(points={{-100,30},{
          -84,30},{-84,32},{-65.2,32}}, color={0,0,127}));
  connect(lessEqualThreshold.y, and4.u2) annotation (Line(points={{-51.4,32},{
          -4,32},{-4,17},{43,17}}, color={255,0,255}));
  connect(lessEqualThreshold.y, and3.u2) annotation (Line(points={{-51.4,32},{
          -8,32},{-8,-44.8},{34.8,-44.8}}, color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Control_HPBuffer;
