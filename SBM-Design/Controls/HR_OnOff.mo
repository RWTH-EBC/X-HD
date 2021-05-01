within Configurations.Controls;
model HR_OnOff
  parameter Modelica.SIunits.Time MaxDhwTime=0;
  parameter Modelica.SIunits.Time MaxBufferTime=600;

  Modelica.Blocks.Sources.RealExpression currentTime(y=time)
    annotation (Placement(transformation(extent={{-38,72},{-26,84}})));
  Modelica.Blocks.MathBoolean.OnDelay risingEdgeHP(delayTime=0)
    annotation (Placement(transformation(extent={{-50,28},{-42,36}})));
  Modelica.Blocks.Discrete.TriggeredMax sampleTimeMinRun
    annotation (Placement(transformation(extent={{-8,58},{0,66}})));
  Modelica.Blocks.Math.Feedback deltaTimeMinRun
    annotation (Placement(transformation(extent={{6,82},{14,90}})));
  Modelica.Blocks.Discrete.TriggeredMax sampleTimeMinRun1
    annotation (Placement(transformation(extent={{8,-70},{16,-62}})));
  Modelica.Blocks.Math.Feedback deltaTimeMinRun1
    annotation (Placement(transformation(extent={{22,-46},{30,-38}})));
  Modelica.Blocks.MathBoolean.OnDelay risingEdgeHP1(
                                                   delayTime=0)
    annotation (Placement(transformation(extent={{-46,-64},{-38,-56}})));
  Modelica.Blocks.Logical.And DHWAndBufferDemand annotation (Placement(transformation(extent={{26,14},{36,24}})));
  Modelica.Blocks.Logical.Or DHWorBoth
    annotation (Placement(transformation(extent={{76,60},{86,70}})));
  Modelica.Blocks.Logical.Not noDHW annotation (Placement(transformation(extent={{42,-28},{50,-20}})));
  Modelica.Blocks.Interfaces.BooleanInput HpDhw "Boolean input signal"
    annotation (Placement(transformation(extent={{-120,30},{-80,70}}),
        iconTransformation(extent={{-120,30},{-80,70}})));
  Modelica.Blocks.Interfaces.BooleanInput HpBuffer "Boolean input signal"
    annotation (Placement(transformation(extent={{-120,-70},{-80,-30}}),
        iconTransformation(extent={{-120,-70},{-80,-30}})));
  Modelica.Blocks.Interfaces.BooleanOutput Buffer_OnOff
    "Connector of Boolean output signal"
    annotation (Placement(transformation(extent={{90,-60},{110,-40}}), iconTransformation(extent={{90,-60},{110,-40}})));
  Modelica.Blocks.Interfaces.BooleanOutput DHW_OnOff
    "Connector of Boolean output signal"
    annotation (Placement(transformation(extent={{90,40},{110,60}}), iconTransformation(extent={{90,40},{110,60}})));
  Modelica.Blocks.Logical.GreaterEqualThreshold greaterEqualThreshold(threshold=
       MaxDhwTime)
    annotation (Placement(transformation(extent={{24,82},{32,90}})));
  Modelica.Blocks.Logical.GreaterEqualThreshold greaterEqualThreshold1(threshold=
       MaxBufferTime)
    annotation (Placement(transformation(extent={{38,-46},{46,-38}})));
  Modelica.Blocks.Interfaces.BooleanInput DemandBuffer
    "Connector of second Boolean input signal"
    annotation (Placement(transformation(extent={{-120,-32},{-80,8}})));
  Modelica.Blocks.Interfaces.BooleanInput DemandDhw
    "Connector of first Boolean input signal"
    annotation (Placement(transformation(extent={{-120,0},{-80,40}})));
  Modelica.Blocks.Logical.And TimeAndDHW
    annotation (Placement(transformation(extent={{52,64},{62,74}})));
  Modelica.Blocks.MathBoolean.And TimeAndBuffer(nu=3)
    annotation (Placement(transformation(extent={{70,-56},{82,-44}})));
equation
  connect(currentTime.y, sampleTimeMinRun.u)
    annotation (Line(points={{-25.4,78},{-18,78},{-18,62},{-12,62},{-12,62},{-8.8,62}}, color={0,0,127}));
  connect(sampleTimeMinRun.y, deltaTimeMinRun.u2) annotation (Line(points={{0.4,62},{6,62},{6,82.8},{10,82.8}}, color={0,0,127}));
  connect(sampleTimeMinRun.trigger, risingEdgeHP.y)
    annotation (Line(points={{-4,57.28},{-8,57.28},{-8,32},{-41.2,32}}, color={255,0,255}));
  connect(deltaTimeMinRun.u1, currentTime.y)
    annotation (Line(points={{6.8,86},{-18,86},{-18,78},{-25.4,78}}, color={0,0,127}));
  connect(currentTime.y, sampleTimeMinRun1.u)
    annotation (Line(points={{-25.4,78},{-18,78},{-18,-66},{7.2,-66}}, color={0,0,127}));
  connect(sampleTimeMinRun1.y, deltaTimeMinRun1.u2)
    annotation (Line(points={{16.4,-66},{22,-66},{22,-45.2},{26,-45.2}}, color={0,0,127}));
  connect(deltaTimeMinRun1.u1, currentTime.y)
    annotation (Line(points={{22.8,-42},{-18,-42},{-18,78},{-25.4,78}}, color={0,0,127}));
  connect(risingEdgeHP1.y, sampleTimeMinRun1.trigger)
    annotation (Line(points={{-37.2,-60},{-30,-60},{-30,-72},{-10,-72},{-10,-70.72},{12,-70.72}}, color={255,0,255}));
  connect(DHWAndBufferDemand.y, DHWorBoth.u2) annotation (Line(points={{36.5,19},
          {36.5,39.5},{75,39.5},{75,61}}, color={255,0,255}));
  connect(risingEdgeHP.u, HpDhw) annotation (Line(points={{-51.6,32},{-72,32},{
          -72,50},{-100,50}}, color={255,0,255}));
  connect(noDHW.u, HpDhw) annotation (Line(points={{41.2,-24},{-30,-24},{-30,50},
          {-100,50}}, color={255,0,255}));
  connect(risingEdgeHP1.u, HpBuffer) annotation (Line(points={{-47.6,-60},{-72,
          -60},{-72,-50},{-100,-50}}, color={255,0,255}));
  connect(DHWorBoth.y, DHW_OnOff)
    annotation (Line(points={{86.5,65},{100,65},{100,50}}, color={255,0,255}));
  connect(greaterEqualThreshold.u, deltaTimeMinRun.y)
    annotation (Line(points={{23.2,86},{13.6,86},{13.6,86}}, color={0,0,127}));
  connect(greaterEqualThreshold1.u, deltaTimeMinRun1.y) annotation (Line(points=
         {{37.2,-42},{29.6,-42},{29.6,-42}}, color={0,0,127}));
  connect(DHWAndBufferDemand.u2, DemandBuffer) annotation (Line(points={{25,15},
          {-37.5,15},{-37.5,-12},{-100,-12}}, color={255,0,255}));
  connect(TimeAndBuffer.y, Buffer_OnOff)
    annotation (Line(points={{82.9,-50},{100,-50}}, color={255,0,255}));
  connect(TimeAndBuffer.u[1], noDHW.y) annotation (Line(points={{70,-47.2},{62,
          -47.2},{62,-24},{50.4,-24}}, color={255,0,255}));
  connect(TimeAndBuffer.u[2], greaterEqualThreshold1.y) annotation (Line(points=
         {{70,-50},{58,-50},{58,-42},{46.4,-42}}, color={255,0,255}));
  connect(TimeAndBuffer.u[3], DemandBuffer) annotation (Line(points={{70,-52.8},
          {-12,-52.8},{-12,-12},{-100,-12}}, color={255,0,255}));
  connect(TimeAndDHW.u1, greaterEqualThreshold.y) annotation (Line(points={{51,
          69},{52,69},{52,70},{50,70},{32.4,70},{32.4,86}}, color={255,0,255}));
  connect(TimeAndDHW.u2, DemandDhw) annotation (Line(points={{51,65},{28,65},{
          28,50},{4,50},{4,20},{-100,20}}, color={255,0,255}));
  connect(DHWAndBufferDemand.u1, HpDhw) annotation (Line(points={{25,19},{-33.5,
          19},{-33.5,50},{-100,50}}, color={255,0,255}));
  connect(DHWorBoth.u1, TimeAndDHW.y) annotation (Line(points={{75,65},{75,66},
          {62,66},{62,68},{62.5,68},{62.5,69}}, color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-80,-20},{80,-80}},
          lineColor={28,108,200},
          pattern=LinePattern.Dash,
          lineThickness=0.5,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-80,80},{80,20}},
          lineColor={28,108,200},
          pattern=LinePattern.Dash,
          lineThickness=0.5,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-76,70},{82,24}},
          lineColor={217,67,180},
          textString="DHW"),
        Text(
          extent={{-62,-34},{68,-76}},
          lineColor={217,67,180},
          textString="Buffer")}), Diagram(coordinateSystem(preserveAspectRatio=false)));
end HR_OnOff;
