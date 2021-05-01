within Configurations.Controls;
model ControlUnit_HP_HR
  parameter Modelica.SIunits.Temperature T_Biv = 273.15-2;
  parameter Modelica.SIunits.Time LockoutTime=0 annotation(Evaluate=false);
  parameter Modelica.SIunits.Time MinRunTime=0 annotation(Evaluate=false);
  parameter Modelica.SIunits.TemperatureDifference hysteresisDHW_HR = 5 annotation(Evaluate=false);
  parameter Modelica.SIunits.TemperatureDifference hysteresisBuffer_HR = 5 annotation(Evaluate=false);
  parameter Modelica.SIunits.TemperatureDifference hysteresisDHW_HP = 10 annotation(Evaluate=false);
  parameter Modelica.SIunits.TemperatureDifference hysteresisBuffer_HP = 10 annotation(Evaluate=false);
  parameter Modelica.SIunits.Temperature T_Set_DHW_konst = 323.15 annotation(Evaluate=false);
  parameter Modelica.SIunits.Temperature T_Buffer_Thres_konst = 293.15 annotation(Evaluate=false);
  parameter Real Gradient_HeatCurve = 1 annotation(Evaluate=false);

  Modelica.Blocks.Interfaces.RealInput T_Top_Buffer annotation (Placement(
        transformation(extent={{-140,-60},{-100,-20}}),  iconTransformation(
          extent={{-20,-20},{20,20}},
        rotation=0,
        origin={20,-72})));

  Modelica.Blocks.MathBoolean.OnDelay fallingEdgeHP(delayTime=0)
    annotation (Placement(transformation(extent={{-42,16},{-34,24}})));
  Modelica.Blocks.Logical.Not fallingEdgeNeg
    annotation (Placement(transformation(extent={{-28,16},{-20,24}})));
  Modelica.Blocks.Discrete.TriggeredMax sampleTimeMinPause
    annotation (Placement(transformation(extent={{-22,30},{-14,38}})));
  Modelica.Blocks.Sources.RealExpression currentTime(y=time)
    annotation (Placement(transformation(extent={{-108,56},{-96,68}})));
  Modelica.Blocks.Math.Feedback deltaTimeMinPause
    annotation (Placement(transformation(extent={{-12,42},{-4,50}})));
  Modelica.Blocks.Logical.Pre pre1
    annotation (Placement(transformation(extent={{-4,-4},{4,4}},
        rotation=-90,
        origin={-60,108})));
  Modelica.Blocks.Logical.GreaterEqualThreshold greaterEqualThreshold(threshold=
       LockoutTime)
    annotation (Placement(transformation(extent={{2,42},{10,50}})));
  Modelica.Blocks.MathBoolean.OnDelay risingEdgeHP(delayTime=0)
    annotation (Placement(transformation(extent={{-42,80},{-34,88}})));
  Modelica.Blocks.Discrete.TriggeredMax sampleTimeMinRun
    annotation (Placement(transformation(extent={{-24,74},{-16,82}})));
  Modelica.Blocks.Math.Feedback deltaTimeMinRun
    annotation (Placement(transformation(extent={{-16,90},{-8,98}})));
  Modelica.Blocks.Logical.LessEqualThreshold lessEqualThreshold(threshold=
        MinRunTime)
    annotation (Placement(transformation(extent={{-2,90},{6,98}})));
  Modelica.Blocks.Logical.Or HPactive annotation (Placement(transformation(
        extent={{-5,-5},{5,5}},
        rotation=0,
        origin={89,-7})));
  Modelica.Blocks.Interfaces.BooleanOutput HP_Buffer_OnOff
    "Connector of Boolean output signal"
    annotation (Placement(transformation(extent={{120,-50},{140,-30}}),
        iconTransformation(extent={{120,-50},{140,-30}})));
  Modelica.Blocks.Interfaces.RealInput T_Top_DHW annotation (Placement(
        transformation(extent={{-140,90},{-100,130}}),  iconTransformation(
          extent={{-20,-20},{20,20}},
        rotation=0,
        origin={20,120})));
  Modelica.Blocks.Logical.And DemandAndNoPauseDHW
    annotation (Placement(transformation(extent={{-14,-38},{-6,-30}})));
  Modelica.Blocks.Interfaces.BooleanOutput HP_DHW_OnOff
    "Connector of Boolean output signal"
    annotation (Placement(transformation(extent={{120,80},{140,100}}),
        iconTransformation(extent={{120,80},{140,100}})));
  Modelica.Blocks.Logical.And DemandAndNoPauseBuffer
    annotation (Placement(transformation(extent={{8,-58},{16,-50}})));
  Modelica.Blocks.Interfaces.RealInput T_Amb annotation (Placement(
        transformation(
        extent={{20,-20},{-20,20}},
        rotation=180,
        origin={-120,-110}), iconTransformation(
        extent={{20,20},{-20,-20}},
        rotation=180,
        origin={-120,-80})));
  HeatCurve heatCurve(T_Buffer_Thres=T_Buffer_Thres_konst)
    annotation (Placement(transformation(extent={{-74,-84},{-62,-72}})));
  Modelica.Blocks.Sources.Constant T_Set_DHW(k=T_Set_DHW_konst)
    annotation (Placement(transformation(extent={{-7,-7},{7,7}},
        rotation=90,
        origin={-59,-27})));
  Modelica.Blocks.Interfaces.RealInput T_Bottom_Buffer annotation (Placement(transformation(extent={{-140,-94},{-100,-54}}),
        iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={20,-120})));
  Hysteresis CalcDhwDemand(Hysteresis=hysteresisDHW_HP, Hysteresis_HR=
        hysteresisDHW_HR)                            annotation (Placement(transformation(extent={{-74,-14},{-46,-2}})));
  Hysteresis CalcBufferDemand(Hysteresis=hysteresisBuffer_HP, Hysteresis_HR=
        hysteresisBuffer_HR)                               annotation (Placement(transformation(extent={{-72,-60},{-44,-48}})));
  Modelica.Blocks.Interfaces.BooleanOutput HR_Buffer_OnOff "Connector of Boolean output signal" annotation (Placement(
        transformation(extent={{120,-100},{140,-80}}), iconTransformation(extent={{120,-100},{140,-80}})));
  Modelica.Blocks.Interfaces.BooleanOutput HR_DHW_OnOff "Connector of Boolean output signal"
    annotation (Placement(transformation(extent={{120,30},{140,50}}), iconTransformation(extent={{120,30},{140,50}})));
  Modelica.Blocks.Sources.RealExpression HysteresisDHW(y=hysteresisDHW_HP)
    annotation (Placement(transformation(extent={{-152,-8},{-132,12}})));
  Modelica.Blocks.Sources.RealExpression HysteresisBuffer(y=hysteresisBuffer_HP)
    annotation (Placement(transformation(extent={{-152,-22},{-132,-2}})));
  Modelica.Blocks.Sources.RealExpression TSetDHW(y=T_Set_DHW_konst)
    annotation (Placement(transformation(extent={{-150,20},{-130,40}})));
  Modelica.Blocks.Routing.Multiplex4 multiplex4_1 annotation (Placement(transformation(extent={{-116,8},{-108,16}})));
  Modelica.Blocks.Interfaces.RealOutput SetTemperatureStorage[4]
    "Connector of Real output signals"
    annotation (Placement(transformation(extent={{-130,40},{-110,60}})));
  Modelica.Blocks.Interfaces.RealInput T_Thres annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={0,-120}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,120})));
  Modelica.Blocks.Logical.And DemandBuffer
    annotation (Placement(transformation(extent={{-22,-62},{-14,-54}})));
  Modelica.Blocks.Logical.Less less
    annotation (Placement(transformation(extent={{-34,-68},{-26,-60}})));
  Modelica.Blocks.Sources.RealExpression m(y=Gradient_HeatCurve)
    annotation (Placement(transformation(extent={{-116,-106},{-96,-86}})));
  Modelica.Blocks.Interfaces.RealOutput gradient_HeatCurve
    "Value of Real output"
    annotation (Placement(transformation(extent={{-130,-18},{-110,2}})));
  Modelica.Blocks.Logical.LessThreshold lessThreshold(threshold=T_Biv)
    annotation (Placement(transformation(extent={{42,-98},{54,-86}})));
  Modelica.Blocks.Logical.And HRBuffer
    annotation (Placement(transformation(extent={{70,-116},{78,-108}})));
  Modelica.Blocks.Logical.Not noDHW
    annotation (Placement(transformation(extent={{80,-84},{88,-76}})));
  Modelica.Blocks.Logical.And HRBufferAndNoDHW
    annotation (Placement(transformation(extent={{104,-94},{112,-86}})));
  ChooseHP2 chooseHP2_1
    annotation (Placement(transformation(extent={{42,-56},{68,-30}})));
equation
  connect(sampleTimeMinPause.y, deltaTimeMinPause.u2) annotation (Line(points={{-13.6,
          34},{-8,34},{-8,42.8}},                 color={0,0,127}));
  connect(fallingEdgeHP.y, fallingEdgeNeg.u) annotation (Line(points={{-33.2,20},
          {-33.2,20},{-28.8,20}}, color={255,0,255}));
  connect(fallingEdgeNeg.y, sampleTimeMinPause.trigger) annotation (Line(points={{-19.6,
          20},{-19.6,20},{-18,20},{-18,29.28}},          color={255,0,255}));
  connect(deltaTimeMinPause.u1, currentTime.y) annotation (Line(points={{-11.2,46},
          {-12,46},{-50,46},{-50,62},{-95.4,62}},
                                  color={0,0,127}));
  connect(greaterEqualThreshold.u, deltaTimeMinPause.y) annotation (Line(points={{1.2,46},
          {1.2,46},{-4.4,46}},              color={0,0,127}));
  connect(risingEdgeHP.u, pre1.y) annotation (Line(points={{-43.6,84},{-60,84},{-60,103.6}},
                                  color={255,0,255}));
  connect(risingEdgeHP.y, sampleTimeMinRun.trigger) annotation (Line(points={{-33.2,
          84},{-30,84},{-30,72},{-20,72},{-20,73.28}},    color={255,0,255}));
  connect(sampleTimeMinRun.y, deltaTimeMinRun.u2)
    annotation (Line(points={{-15.6,78},{-12,78},{-12,90.8}},
                                                            color={0,0,127}));
  connect(sampleTimeMinRun.u, currentTime.y) annotation (Line(points={{-24.8,78},
          {-24.8,78},{-28,78},{-28,62},{-95.4,62}},  color={0,0,127}));
  connect(deltaTimeMinRun.u1, currentTime.y) annotation (Line(points={{-15.2,94},
          {-50,94},{-50,62},{-95.4,62}},              color={0,0,127}));
  connect(deltaTimeMinRun.y, lessEqualThreshold.u)
    annotation (Line(points={{-8.4,94},{-8.4,94},{-2.8,94}}, color={0,0,127}));
  connect(sampleTimeMinPause.u, currentTime.y) annotation (Line(points={{-22.8,34},
          {-50,34},{-50,62},{-95.4,62}},    color={0,0,127}));
  connect(DemandAndNoPauseDHW.u1, greaterEqualThreshold.y) annotation (Line(
        points={{-14.8,-34},{-22,-34},{-22,4},{14,4},{14,46},{10.4,46}},
                                                      color={255,0,255}));
  connect(pre1.y, fallingEdgeHP.u) annotation (Line(points={{-60,103.6},{-60,103.6},{-60,20},{-43.6,20}},
                                color={255,0,255}));
  connect(DemandAndNoPauseBuffer.u1, greaterEqualThreshold.y) annotation (Line(
        points={{7.2,-54},{-14,-54},{-14,-18},{30,-18},{30,44},{28,44},{28,46},
          {10.4,46}},                                   color={255,0,255}));
  connect(heatCurve.T_Amb, T_Amb) annotation (Line(points={{-75.2,-75},{-84,-75},
          {-84,-110},{-120,-110}},           color={0,0,127}));
  connect(CalcDhwDemand.T_Top, T_Top_DHW)
    annotation (Line(points={{-72.4444,-4},{-80,-4},{-80,-2},{-80,110},{-82,110},
          {-120,110}},                                                                        color={0,0,127}));
  connect(T_Set_DHW.y, CalcDhwDemand.T_Set)
    annotation (Line(points={{-59,-19.3},{-60,-19.3},{-60,-18},{-60,-13.8},{
          -58.4444,-13.8}},                                                                   color={0,0,127}));
  connect(CalcDhwDemand.T_2, T_Top_DHW)
    annotation (Line(points={{-72.4444,-12},{-80,-12},{-80,14},{-80,110},{-120,
          110}},                                                                      color={0,0,127}));
  connect(CalcBufferDemand.T_2, T_Bottom_Buffer)
    annotation (Line(points={{-70.4444,-58},{-86,-58},{-86,-74},{-120,-74}}, color={0,0,127}));
  connect(CalcBufferDemand.T_Set, heatCurve.T_Set)
    annotation (Line(points={{-56.4444,-59.8},{-56,-59.8},{-56,-78},{-61.4,-78}},           color={0,0,127}));
  connect(HPactive.y, pre1.u)
    annotation (Line(points={{94.5,-7},{94,-7},{94,-8},{98,-8},{98,112},{24,112},
          {24,112.8},{-60,112.8}},                                                               color={255,0,255}));
  connect(CalcBufferDemand.T_Top, T_Top_Buffer)
    annotation (Line(points={{-70.4444,-50},{-96,-50},{-96,-40},{-48,-40},{-120,
          -40}},                                                                       color={0,0,127}));
  connect(multiplex4_1.u1[1], TSetDHW.y)
    annotation (Line(points={{-116.8,15.6},{-120,15.6},{-120,30},{-129,30}}, color={0,0,127}));
  connect(multiplex4_1.y, SetTemperatureStorage)
    annotation (Line(points={{-107.6,12},{-104,12},{-104,50},{-120,50}}, color={0,0,127}));
  connect(multiplex4_1.u2[1], heatCurve.T_Set) annotation (Line(points={{-116.8,
          13.2},{-116.8,14},{-158,14},{-158,-130},{-58,-130},{-58,-88},{-61.4,
          -88},{-61.4,-78}},                                                   color={0,0,127}));
  connect(HysteresisDHW.y, multiplex4_1.u3[1])
    annotation (Line(points={{-131,2},{-124,2},{-124,10.8},{-116.8,10.8}}, color={0,0,127}));
  connect(HysteresisBuffer.y, multiplex4_1.u4[1])
    annotation (Line(points={{-131,-12},{-124,-12},{-124,8.4},{-116.8,8.4}}, color={0,0,127}));
  connect(heatCurve.T_Thres, T_Thres) annotation (Line(points={{-75.2,-81},{-78,
          -81},{-78,-118},{-40,-118},{-40,-120},{0,-120}},
                                     color={0,0,127}));
  connect(less.y, DemandBuffer.u2) annotation (Line(points={{-25.6,-64},{-26,
          -64},{-26,-61.2},{-22.8,-61.2}}, color={255,0,255}));
  connect(less.u1, T_Amb) annotation (Line(points={{-34.8,-64},{-46,-64},{-46,-110},
          {-120,-110}}, color={0,0,127}));
  connect(less.u2, T_Thres) annotation (Line(points={{-34.8,-67.2},{-34.8,-88.6},
          {0,-88.6},{0,-120}}, color={0,0,127}));
  connect(DemandAndNoPauseBuffer.u2, DemandBuffer.y) annotation (Line(points={{7.2,
          -57.2},{-7.4,-57.2},{-7.4,-58},{-13.6,-58}},      color={255,0,255}));
  connect(heatCurve.m, m.y) annotation (Line(points={{-75.2,-78},{-82,-78},{-82,
          -96},{-95,-96}}, color={0,0,127}));
  connect(m.y, gradient_HeatCurve) annotation (Line(points={{-95,-96},{-108,-96},
          {-108,-8},{-120,-8}}, color={0,0,127}));
  connect(HRBuffer.u2, lessThreshold.y) annotation (Line(points={{69.2,-115.2},
          {54.6,-115.2},{54.6,-92}},
                              color={255,0,255}));
  connect(lessThreshold.u, T_Amb) annotation (Line(points={{40.8,-92},{-34,-92},
          {-34,-110},{-120,-110}}, color={0,0,127}));
  connect(DemandBuffer.u1, CalcBufferDemand.OnOff_HP) annotation (Line(points={{-22.8,
          -58},{-34,-58},{-34,-51.4},{-44.9333,-51.4}},        color={255,0,255}));
  connect(DemandAndNoPauseDHW.u2, CalcDhwDemand.OnOff_HP) annotation (Line(
        points={{-14.8,-37.2},{-14.8,-5.4},{-46.9333,-5.4}}, color={255,0,255}));
  connect(CalcDhwDemand.OnOff_HR, HR_DHW_OnOff) annotation (Line(points={{
          -46.9333,-10.6},{38.5333,-10.6},{38.5333,40},{130,40}}, color={255,0,
          255}));
  connect(HRBufferAndNoDHW.y, HR_Buffer_OnOff) annotation (Line(points={{112.4,
          -90},{130,-90}},                     color={255,0,255}));
  connect(HRBufferAndNoDHW.u1, noDHW.y) annotation (Line(points={{103.2,-90},{
          90,-90},{90,-80},{88.4,-80}},
                                     color={255,0,255}));
  connect(CalcBufferDemand.OnOff_HR, HRBuffer.u1) annotation (Line(points={{
          -44.9333,-56.6},{-42,-56.6},{-42,-56},{-38,-56},{-38,-112},{69.2,-112}},
        color={255,0,255}));
  connect(HRBuffer.y, HRBufferAndNoDHW.u2) annotation (Line(points={{78.4,-112},
          {90,-112},{90,-93.2},{103.2,-93.2}}, color={255,0,255}));
  connect(lessEqualThreshold.y, chooseHP2_1.RunForced) annotation (Line(points=
          {{6.4,94},{54,94},{54,-27.4},{55,-27.4}}, color={255,0,255}));
  connect(DemandAndNoPauseDHW.y, chooseHP2_1.DemandDHW) annotation (Line(points=
         {{-5.6,-34},{18,-34},{18,-39.1},{39.4,-39.1}}, color={255,0,255}));
  connect(DemandAndNoPauseBuffer.y, chooseHP2_1.DemandBuffer) annotation (Line(
        points={{16.4,-54},{28,-54},{28,-52.1},{39.4,-52.1}}, color={255,0,255}));
  connect(T_Top_DHW, chooseHP2_1.T_Top_DHW) annotation (Line(points={{-120,110},
          {-42,110},{-42,-32.6},{39.4,-32.6}}, color={0,0,127}));
  connect(T_Top_Buffer, chooseHP2_1.T_Top_Buffer) annotation (Line(points={{
          -120,-40},{-42,-40},{-42,-45.6},{39.4,-45.6}}, color={0,0,127}));
  connect(chooseHP2_1.DHW_OnOff, HPactive.u1) annotation (Line(points={{69.3,
          -36.24},{69.3,-22.12},{83,-22.12},{83,-7}}, color={255,0,255}));
  connect(chooseHP2_1.Buffer_OnOff, HPactive.u2) annotation (Line(points={{69.3,
          -49.5},{69.3,-29.75},{83,-29.75},{83,-11}}, color={255,0,255}));
  connect(chooseHP2_1.DHW_OnOff, HP_DHW_OnOff) annotation (Line(points={{69.3,
          -36.24},{69.3,25.88},{130,25.88},{130,90}}, color={255,0,255}));
  connect(chooseHP2_1.Buffer_OnOff, HP_Buffer_OnOff) annotation (Line(points={{
          69.3,-49.5},{96.65,-49.5},{96.65,-40},{130,-40}}, color={255,0,255}));
  connect(chooseHP2_1.DHW_OnOff, noDHW.u) annotation (Line(points={{69.3,-36.24},
          {69.3,-58.12},{79.2,-58.12},{79.2,-80}}, color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-120,-120},{120,120}}),
                                                                graphics={
        Rectangle(
          extent={{120,120},{-120,-120}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{26,96},{106,8}},
          lineColor={217,67,180},
          pattern=LinePattern.Dash,
          lineThickness=0.5,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="DHW"),
        Text(
          extent={{26,-6},{102,-66}},
          lineColor={217,67,180},
          pattern=LinePattern.Dash,
          lineThickness=0.5,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="Buffer"),
        Text(
          extent={{-62,-58},{4,-126}},
          lineColor={238,46,47},
          pattern=LinePattern.Dash,
          lineThickness=0.5,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="T"),
        Text(
          extent={{-104,42},{96,-30}},
          lineColor={0,0,0},
          pattern=LinePattern.Dash,
          lineThickness=0.5,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="HP Control"),
        Text(
          extent={{-54,126},{12,58}},
          lineColor={238,46,47},
          pattern=LinePattern.Dash,
          lineThickness=0.5,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="T")}),                                     Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-120,-120},{120,120}}),
                                                     graphics={
        Rectangle(
          extent={{-54,12},{18,52}},
          lineColor={28,108,200},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-54,70},{18,106}},
          lineColor={28,108,200},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-16,20},{2,12}},
          lineColor={28,108,200},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="Lockout"),
        Text(
          extent={{-24,106},{-2,94}},
          lineColor={28,108,200},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="RunForced
")}));
end ControlUnit_HP_HR;
