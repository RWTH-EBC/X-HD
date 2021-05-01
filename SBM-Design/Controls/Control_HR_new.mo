within Configurations.Controls;
model Control_HR_new
  parameter Real Hysteresis = 10;
  parameter Real TSet = 323.15;
  parameter Real T_Min_Sto = 313.15 "K";
  parameter Real T_Max_Sto = 333.15 "K";
  parameter Real HeatingRod_Max = HR_QMax.k "W";

  Modelica.Blocks.Interfaces.RealInput Q_HP_actual1
    annotation (Placement(transformation(extent={{-120,-60},{-80,-20}})));
  Modelica.Blocks.Interfaces.RealInput Q_demand1
    annotation (Placement(transformation(extent={{-120,70},{-80,110}})));
  Modelica.Blocks.Interfaces.RealOutput Q_HeatingRod_OnOff
    "Connector of Real output signal"
    annotation (Placement(transformation(extent={{96,50},{116,70}})));
  Modelica.Blocks.Sources.Constant Q_HeatingRod_rel(k=0)
    annotation (Placement(transformation(extent={{4,-34},{20,-18}})));
  Modelica.Blocks.Logical.Switch switch2
    annotation (Placement(transformation(extent={{54,82},{66,94}})));
  Modelica.Blocks.Logical.Greater greater
    annotation (Placement(transformation(extent={{-16,52},{-2,68}})));
  Modelica.Blocks.Math.Add add(k1=-1, k2=-1)
    annotation (Placement(transformation(extent={{-18,74},{2,94}})));
  Modelica.Blocks.Math.Gain gain(k=-1)
    annotation (Placement(transformation(extent={{-68,58},{-60,66}})));
  Modelica.Blocks.Sources.Constant HR_QMax(k=6000)
    annotation (Placement(transformation(extent={{-6,-6},{6,6}},
        rotation=90,
        origin={84,24})));
  Modelica.Blocks.Math.Division division
    annotation (Placement(transformation(extent={{78,80},{88,90}})));
  Modelica.Blocks.Interfaces.BooleanInput HP_on
    annotation (Placement(transformation(extent={{-120,-110},{-80,-70}})));
  Modelica.Blocks.Logical.Switch switch1
    annotation (Placement(transformation(extent={{-38,-86},{-26,-74}})));
  Modelica.Blocks.Interfaces.RealOutput HP_onoff
    annotation (Placement(transformation(extent={{96,-90},{116,-70}})));
  Modelica.Blocks.Sources.Constant Q_HeatingRod_rel1(k=1)
    annotation (Placement(transformation(extent={{-80,-66},{-64,-50}})));
  Modelica.Blocks.Interfaces.RealInput T_Top
    annotation (Placement(transformation(extent={{-120,20},{-80,60}})));
  Modelica.Blocks.Logical.And and1
    annotation (Placement(transformation(extent={{24,52},{38,66}})));
  Modelica.Blocks.Sources.Constant T_min_hysteresis(k=T_Min_Sto)
    annotation (Placement(transformation(extent={{-36,28},{-20,44}})));
  Modelica.Blocks.Logical.Greater greater1
    annotation (Placement(transformation(extent={{-2,22},{12,38}})));
equation
  connect(greater.u2, Q_HP_actual1) annotation (Line(points={{-17.4,53.6},{-58,53.6},
          {-58,-40},{-100,-40}},
                            color={0,0,127}));
  connect(Q_HeatingRod_rel.y, switch2.u3) annotation (Line(points={{20.8,-26},{70,
          -26},{70,83.2},{52.8,83.2}},
                                color={0,0,127}));
  connect(add.u1, Q_demand1)
    annotation (Line(points={{-20,90},{-38,90},{-100,90}}, color={0,0,127}));
  connect(add.u2, Q_HP_actual1) annotation (Line(points={{-20,78},{-42,78},{-42,
          -40},{-100,-40}},
                        color={0,0,127}));
  connect(gain.u, Q_demand1) annotation (Line(points={{-68.8,62},{-84,62},{-84,90},
          {-100,90}},     color={0,0,127}));
  connect(gain.y, greater.u1)
    annotation (Line(points={{-59.6,62},{-17.4,62},{-17.4,60}},
                                                            color={0,0,127}));
  connect(switch2.u1, add.y) annotation (Line(points={{52.8,92.8},{34,92.8},{34,
          84},{3,84}},
                  color={0,0,127}));
  connect(switch2.y, division.u1) annotation (Line(points={{66.6,88},{70,88},{77,
          88}},         color={0,0,127}));
  connect(HR_QMax.y, division.u2) annotation (Line(points={{84,30.6},{84,30.6},{
          84,82},{77,82}},
                        color={0,0,127}));
  connect(division.y, Q_HeatingRod_OnOff) annotation (Line(points={{88.5,85},{91.25,
          85},{91.25,60},{106,60}}, color={0,0,127}));
  connect(HP_on, switch1.u2) annotation (Line(points={{-100,-90},{-39.2,-90},{-39.2,
          -80}},       color={255,0,255}));
  connect(Q_HeatingRod_rel.y, switch1.u3) annotation (Line(points={{20.8,-26},{-50,
          -26},{-50,-84.8},{-39.2,-84.8}},     color={0,0,127}));
  connect(Q_HeatingRod_rel1.y, switch1.u1) annotation (Line(points={{-63.2,-58},
          {-52,-58},{-52,-75.2},{-39.2,-75.2}}, color={0,0,127}));
  connect(switch1.y, HP_onoff)
    annotation (Line(points={{-25.4,-80},{106,-80}}, color={0,0,127}));
  connect(greater.y, and1.u1) annotation (Line(points={{-1.3,60},{10,60},{10,59},
          {22.6,59}}, color={255,0,255}));
  connect(and1.y, switch2.u2) annotation (Line(points={{38.7,59},{38.7,88},{52.8,
          88}}, color={255,0,255}));
  connect(T_min_hysteresis.y, greater1.u1) annotation (Line(points={{-19.2,36},{
          -12,36},{-12,30},{-3.4,30}}, color={0,0,127}));
  connect(T_Top, greater1.u2) annotation (Line(points={{-100,40},{-52,40},{-52,23.6},
          {-3.4,23.6}}, color={0,0,127}));
  connect(greater1.y, and1.u2) annotation (Line(points={{12.7,30},{18,30},{18,53.4},
          {22.6,53.4}}, color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Control_HR_new;
