within Configurations.Controls;
package Archive
  model Control
    parameter Real Hysteresis = 10;
    parameter Real TSet = 323.15;
    parameter Real T_Min_Storage = 313.15 "K";
    parameter Real T_Max_Storage = 333.15 "K";
    parameter Real HeatingRod_Max = HR_QMax.k "W";

    Modelica.Blocks.Interfaces.RealInput Q_HP_actual1
      annotation (Placement(transformation(extent={{-120,-20},{-80,20}})));
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
      annotation (Placement(transformation(extent={{42,-68},{58,-52}})));
    Modelica.Blocks.Sources.Constant Q_HeatPump_rel_max(k=1)
      annotation (Placement(transformation(extent={{-44,-42},{-24,-22}})));
    Modelica.Blocks.Sources.Constant Q_HeatPump_rel_min(k=0)
      annotation (Placement(transformation(extent={{-28,-96},{-8,-76}})));
    Modelica.Blocks.Sources.Constant Q_HeatingRod_rel(k=0)
      annotation (Placement(transformation(extent={{26,-18},{40,-4}})));
    Modelica.Blocks.Logical.Switch switch2
      annotation (Placement(transformation(extent={{54,54},{66,66}})));
    Modelica.Blocks.Logical.Greater greater
      annotation (Placement(transformation(extent={{-32,0},{-12,20}})));
    Modelica.Blocks.Logical.And and1
      annotation (Placement(transformation(extent={{-4,52},{12,68}})));
    Modelica.Blocks.Math.Add add(k1=-1, k2=-1)
      annotation (Placement(transformation(extent={{-18,76},{-2,92}})));
    Modelica.Blocks.Math.Gain gain(k=-1)
      annotation (Placement(transformation(extent={{-68,6},{-60,14}})));
    Hysteresis_control hysteresis_control(T_Min=T_Min_Storage, T_Max=
          T_Max_Storage)
      annotation (Placement(transformation(extent={{-38,-64},{-10,-52}})));
    Modelica.Blocks.Logical.And and2
      annotation (Placement(transformation(extent={{32,18},{48,34}})));
    Modelica.Blocks.Logical.Less less
      annotation (Placement(transformation(extent={{10,6},{24,22}})));
    Modelica.Blocks.Sources.Constant HR_QMax(k=6000)
      annotation (Placement(transformation(extent={{74,20},{86,32}})));
    Modelica.Blocks.Math.Division division
      annotation (Placement(transformation(extent={{76,64},{86,74}})));
  equation
    connect(switch1.y, switch_HeatPump_OnOff)
      annotation (Line(points={{58.8,-60},{58.8,-60},{108,-60}},
                                                             color={0,0,127}));
    connect(switch1.u1, Q_HeatPump_rel_max.y) annotation (Line(points={{40.4,-53.6},
            {22,-53.6},{22,-32},{-23,-32}},
                                        color={0,0,127}));
    connect(Q_HeatPump_rel_min.y, switch1.u3) annotation (Line(points={{-7,-86},{-2,
            -86},{-2,-66.4},{40.4,-66.4}},
                                        color={0,0,127}));
    connect(greater.u2, Q_HP_actual1) annotation (Line(points={{-34,2},{-86,2},{
            -86,0},{-100,0}}, color={0,0,127}));
    connect(Q_HeatingRod_rel.y, switch2.u3) annotation (Line(points={{40.7,-11},{70,
            -11},{70,55.2},{52.8,55.2}},
                                  color={0,0,127}));
    connect(and1.u1, greater.y) annotation (Line(points={{-5.6,60},{-12,60},{-12,
            10},{-11,10}}, color={255,0,255}));
    connect(add.u1, Q_demand1)
      annotation (Line(points={{-19.6,88.8},{-38,90},{-100,90}},
                                                             color={0,0,127}));
    connect(add.u2, Q_HP_actual1) annotation (Line(points={{-19.6,79.2},{-42,79.2},
            {-42,0},{-100,0}},
                          color={0,0,127}));
    connect(gain.u, Q_demand1) annotation (Line(points={{-68.8,10},{-84,10},{-84,
            90},{-100,90}}, color={0,0,127}));
    connect(gain.y, greater.u1)
      annotation (Line(points={{-59.6,10},{-44,10},{-34,10}}, color={0,0,127}));
    connect(switch2.u1, add.y) annotation (Line(points={{52.8,64.8},{34,64.8},{34,
            84},{-1.2,84}},
                    color={0,0,127}));
    connect(hysteresis_control.WP_an, switch1.u2) annotation (Line(points={{-8.04,
            -58},{40.4,-58},{40.4,-60}},      color={255,0,255}));
    connect(hysteresis_control.WP_an, and1.u2) annotation (Line(points={{-8.04,
            -58},{0,-58},{0,53.6},{-5.6,53.6}}, color={255,0,255}));
    connect(T_Top1, hysteresis_control.T_Top) annotation (Line(points={{-100,-88},
            {-70,-88},{-70,-52},{-39.12,-52}}, color={0,0,127}));
    connect(and1.y, and2.u1) annotation (Line(points={{12.8,60},{20,60},{20,26},{30.4,
            26}}, color={255,0,255}));
    connect(less.y, and2.u2) annotation (Line(points={{24.7,14},{28,14},{28,19.6},
            {30.4,19.6}}, color={255,0,255}));
    connect(T_Top1, less.u1) annotation (Line(points={{-100,-88},{-46,-88},{-46,14},
            {8.6,14}}, color={0,0,127}));
    connect(hysteresis_control.T_Min_out, less.u2) annotation (Line(points={{-8.6,
            -61.2},{-8.6,-26.6},{8.6,-26.6},{8.6,7.6}}, color={0,0,127}));
    connect(and2.y, switch2.u2) annotation (Line(points={{48.8,26},{50,26},{50,60},
            {52.8,60}}, color={255,0,255}));
    connect(switch2.y, division.u1) annotation (Line(points={{66.6,60},{70,60},{70,
            72},{75,72}}, color={0,0,127}));
    connect(HR_QMax.y, division.u2) annotation (Line(points={{86.6,26},{84,26},{84,
            66},{75,66}}, color={0,0,127}));
    connect(division.y, Q_HeatingRod_OnOff) annotation (Line(points={{86.5,69},{91.25,
            69},{91.25,60},{106,60}}, color={0,0,127}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end Control;
end Archive;
