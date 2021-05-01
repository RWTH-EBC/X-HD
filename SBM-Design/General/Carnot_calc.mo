within Configurations.General;
model Carnot_calc
  Modelica.Blocks.Interfaces.RealInput T_amb "Ambient Temperature in K"
    annotation (Placement(transformation(extent={{-128,-72},{-88,-32}})));
  Modelica.Blocks.Interfaces.RealOutput COP_Carnot
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealInput T_supply "Supply temperature in K"
    annotation (Placement(transformation(extent={{-124,40},{-84,80}})));
  Modelica.Blocks.Logical.GreaterThreshold greaterThreshold
    annotation (Placement(transformation(extent={{-18,12},{2,32}})));
  Modelica.Blocks.Logical.Switch switch1
    annotation (Placement(transformation(extent={{38,-46},{52,-32}})));
  Modelica.Blocks.Math.Add add(k1=-1, k2=+1)
    annotation (Placement(transformation(extent={{-46,-54},{-26,-34}})));
  Modelica.Blocks.Logical.GreaterThreshold greaterThreshold1
    annotation (Placement(transformation(extent={{-16,-74},{4,-54}})));
  Modelica.Blocks.Logical.Switch switch2
    annotation (Placement(transformation(extent={{38,30},{54,46}})));
  Modelica.Blocks.Logical.And and1
    annotation (Placement(transformation(extent={{10,-16},{26,0}})));
  Modelica.Blocks.Math.Division division
    annotation (Placement(transformation(extent={{64,-8},{80,8}})));
  Modelica.Blocks.Sources.Constant const(k=0)
    annotation (Placement(transformation(extent={{6,26},{18,38}})));
  Modelica.Blocks.Sources.Constant const1(k=1)
    annotation (Placement(transformation(extent={{14,-50},{26,-38}})));
  Modelica.Blocks.Interfaces.BooleanInput HP_on
    annotation (Placement(transformation(extent={{-126,-20},{-86,20}})));
  Modelica.Blocks.Logical.And and2
    annotation (Placement(transformation(extent={{-20,-12},{-6,2}})));
equation
  connect(T_amb, add.u1) annotation (Line(points={{-108,-52},{-70,-52},{-70,-38},
          {-48,-38}}, color={0,0,127}));
  connect(T_supply, add.u2) annotation (Line(points={{-104,60},{-68,60},{-68,
          -50},{-48,-50}}, color={0,0,127}));
  connect(add.y, greaterThreshold1.u) annotation (Line(points={{-25,-44},{-22,
          -44},{-22,-64},{-18,-64}}, color={0,0,127}));
  connect(division.y, COP_Carnot)
    annotation (Line(points={{80.8,0},{110,0}}, color={0,0,127}));
  connect(T_supply, greaterThreshold.u) annotation (Line(points={{-104,60},{-76,
          60},{-76,22},{-20,22}}, color={0,0,127}));
  connect(greaterThreshold.y, and1.u1) annotation (Line(points={{3,22},{6,22},{
          6,-8},{8.4,-8}}, color={255,0,255}));
  connect(const.y, switch2.u3) annotation (Line(points={{18.6,32},{20,32},{20,
          31.6},{36.4,31.6}}, color={0,0,127}));
  connect(and1.y, switch2.u2) annotation (Line(points={{26.8,-8},{32,-8},{32,38},
          {36.4,38}}, color={255,0,255}));
  connect(and1.y, switch1.u2) annotation (Line(points={{26.8,-8},{32,-8},{32,
          -39},{36.6,-39}}, color={255,0,255}));
  connect(const1.y, switch1.u3) annotation (Line(points={{26.6,-44},{36.6,-44},
          {36.6,-44.6}}, color={0,0,127}));
  connect(add.y, switch1.u1) annotation (Line(points={{-25,-44},{6,-44},{6,
          -33.4},{36.6,-33.4}}, color={0,0,127}));
  connect(switch1.y, division.u2) annotation (Line(points={{52.7,-39},{52.7,
          -22.5},{62.4,-22.5},{62.4,-4.8}}, color={0,0,127}));
  connect(T_supply, switch2.u1) annotation (Line(points={{-104,60},{-34,60},{
          -34,44.4},{36.4,44.4}}, color={0,0,127}));
  connect(switch2.y, division.u1) annotation (Line(points={{54.8,38},{52,38},{
          52,4.8},{62.4,4.8}}, color={0,0,127}));
  connect(HP_on, and2.u1) annotation (Line(points={{-106,0},{-74,0},{-74,-5},{
          -21.4,-5}}, color={255,0,255}));
  connect(greaterThreshold1.y, and2.u2) annotation (Line(points={{5,-64},{-18,
          -64},{-18,-10.6},{-21.4,-10.6}}, color={255,0,255}));
  connect(and2.y, and1.u2) annotation (Line(points={{-5.3,-5},{1.35,-5},{1.35,
          -14.4},{8.4,-14.4}}, color={255,0,255}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={28,108,200},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid), Text(
          extent={{-62,28},{58,-26}},
          lineColor={0,0,0},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid,
          textString="COP Carnot calc")}),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
</html>"));
end Carnot_calc;
