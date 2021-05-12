within VCLib.HeatPumpFlowSheets.HPS_model.Components.Controls;
model System_controller "Currently removed T_Biv constraint"

  // NOTES: Some variables / parameters are not used anymore in current version

  // Defines whether heating is needed and which heat pump will run (or heating rod)
  // Lockout:  Specific minimum Standby time
  // ForcedRun: Specific minium run time
  // DHW has priority to buffer storage
  /******************************* Parameters *********************************/
  parameter Modelica.SIunits.Temperature T_Biv = 273.15-2 "";
  parameter Modelica.SIunits.Time LockoutTime=0 annotation(Evaluate=false);
  parameter Modelica.SIunits.Time MinRunTime=0 annotation(Evaluate=false);
  parameter Modelica.SIunits.TemperatureDifference hysteresisDHW_HR = 5 annotation(Evaluate=false);
  parameter Modelica.SIunits.TemperatureDifference hysteresisBuffer_HR = 5 annotation(Evaluate=false);
  parameter Modelica.SIunits.TemperatureDifference hysteresisDHW_HP = 10 "Heat pump hysteresis for dhw storage" annotation(Evaluate=false);
  parameter Modelica.SIunits.TemperatureDifference hysteresisBuffer_HP = 10 "Heat pump hysteresis for buffer storage" annotation(Evaluate=false);
  parameter Modelica.SIunits.Temperature T_Set_DHW_konst = 323.15 "Set temperature for dhw storage" annotation(Evaluate=false);
  parameter Modelica.SIunits.Temperature T_Buffer_Thres_konst = 295.15 "Room temerature" annotation(Evaluate=false);
  parameter Real Gradient_HeatCurve = 1 "Heat curve gradient" annotation(Evaluate=false);
  parameter Modelica.SIunits.Temperature T_hrMax = 278.15 "Maximum ambient air temperature when hr can be activated";

  /******************************* Inputs *********************************/
  input Modelica.SIunits.Temperature T_top_DHW "Temperature of top layer in DHW storage";
  input Modelica.SIunits.Temperature T_top_buffer "Temperature of top layer in buffer storage";
  input Modelica.SIunits.Temperature T_bot_buffer "Temperature of bottom layer in buffer storage";

  /******************************* Variables *********************************/
  Modelica.SIunits.Time t_op(start=0) "Total operation time of heat pump";
  Modelica.SIunits.Time t_opSt(start=0) "Helper variable";

  /******************************* Components *********************************/

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
        origin={-60,114})));
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
        origin={97,-11})));

  Modelica.Blocks.Logical.And DemandAndNoPauseDHW
    annotation (Placement(transformation(extent={{-6,-38},{2,-30}})));
  Modelica.Blocks.Logical.And DemandAndNoPauseBuffer
    annotation (Placement(transformation(extent={{8,-58},{16,-50}})));

  HPS_model.Components.Controls.HeatCurve heatCurve(T_Buffer_Thres=
        T_Buffer_Thres_konst)
    annotation (Placement(transformation(extent={{-76,-84},{-64,-72}})));
  Modelica.Blocks.Sources.Constant T_Set_DHW(k=T_Set_DHW_konst)
    annotation (Placement(transformation(extent={{-7,-7},{7,7}},
        rotation=90,
        origin={-59,-27})));
  HPS_model.Components.Controls.Hysteresis CalcDhwDemand(Hysteresis=
        hysteresisDHW_HP, Hysteresis_HR=hysteresisDHW_HR)
    annotation (Placement(transformation(extent={{-72,-14},{-44,-2}})));
  HPS_model.Components.Controls.Hysteresis CalcBufferDemand(Hysteresis=
        hysteresisBuffer_HP, Hysteresis_HR=hysteresisBuffer_HR)
    annotation (Placement(transformation(extent={{-72,-60},{-44,-48}})));

  Modelica.Blocks.Logical.And DemandBuffer "Buffer storage should be heated"
    annotation (Placement(transformation(extent={{-22,-62},{-14,-54}})));
  Modelica.Blocks.Logical.Less less
    "Ambient temperature below treshold heating temperature"
    annotation (Placement(transformation(extent={{-34,-68},{-26,-60}})));
  Modelica.Blocks.Sources.RealExpression m(y=Gradient_HeatCurve)
    annotation (Placement(transformation(extent={{-156,-106},{-136,-86}})));
  Modelica.Blocks.Logical.LessThreshold lessThreshold(threshold=T_Biv)
    annotation (Placement(transformation(extent={{36,-106},{48,-94}})));
  Modelica.Blocks.Logical.And HR_Tbiv
    annotation (Placement(transformation(extent={{68,-100},{76,-92}})));
  ChooseHP2                         chooseHP2_1
    annotation (Placement(transformation(extent={{42,-56},{68,-30}})));
  Modelica.Blocks.Sources.BooleanExpression booleanExpression(y=true)
    annotation (Placement(transformation(extent={{28,-132},{48,-112}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=T_top_DHW)
    annotation (Placement(transformation(extent={{-118,0},{-98,20}})));
  Modelica.Blocks.Sources.RealExpression realExpression1(y=T_top_buffer)
    annotation (Placement(transformation(extent={{-118,-38},{-98,-18}})));
  Modelica.Blocks.Sources.RealExpression realExpression2(y=T_bot_buffer)
    annotation (Placement(transformation(extent={{-118,-68},{-98,-48}})));
  Components.Controls.Counter_switchOn counter_switchOn
    annotation (Placement(transformation(extent={{142,-22},{162,-2}})));

  Modelica.Blocks.Interfaces.BooleanOutput LoadDhwSto
    "Option whether Dhw storage should be loaded or not" annotation (Placement(
        transformation(extent={{120,-56},{156,-20}}), iconTransformation(extent={{116,-52},
            {144,-24}})));

  Modelica.Blocks.Interfaces.BooleanOutput HP_OnOff
    "Option whether heat pump should run or not" annotation (Placement(
        transformation(extent={{126,2},{162,38}}), iconTransformation(extent={{-15,-15},
            {15,15}},
        rotation=270,
        origin={-35,-129})));
  Modelica.Blocks.Interfaces.RealInput T_Amb "Ambient air temperature in K"
                                             annotation (Placement(
        transformation(
        extent={{20,-20},{-20,20}},
        rotation=180,
        origin={-120,-110}), iconTransformation(
        extent={{20,20},{-20,-20}},
        rotation=180,
        origin={-120,-80})));
  Modelica.Blocks.Interfaces.BooleanOutput LoadHeatingSto
    "Option whether buffer storage should be loaded" annotation (Placement(
        transformation(extent={{120,-86},{156,-50}}), iconTransformation(extent={{-14,-14},
            {14,14}},
        rotation=0,
        origin={130,-76})));
  Modelica.Blocks.Interfaces.BooleanOutput HR_OnOff
    "Option whether heating rod should run or not" annotation (Placement(
        transformation(extent={{120,-116},{160,-76}}), iconTransformation(
          extent={{-15,-15},{15,15}},
        rotation=270,
        origin={13,-129})));
  Modelica.Blocks.Interfaces.RealInput T_Thresh
    "Heating threshold temperature in K (approx 15°C)"
                                                annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={0,-128}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,120})));

  Modelica.Blocks.Logical.Or HRactive annotation (Placement(transformation(
        extent={{-5,-5},{5,5}},
        rotation=0,
        origin={49,-77})));
  Modelica.Blocks.Interfaces.RealOutput T_heatCurve
    "Storage set temperature in K defined by heat curve" annotation (Placement(
        transformation(extent={{-58,-100},{-38,-80}}), iconTransformation(
        extent={{-15,-15},{15,15}},
        rotation=270,
        origin={-85,-129})));
  Modelica.Blocks.Logical.And HR_Tbiv1
    annotation (Placement(transformation(extent={{92,-100},{100,-92}})));
  Modelica.Blocks.Logical.LessThreshold lessThreshold1(threshold=T_hrMax)
    annotation (Placement(transformation(extent={{66,-136},{78,-124}})));

algorithm
  when HP_OnOff then
    t_opSt :=time;
  end when;

  when HP_OnOff == false then
    t_op :=t_op + (time - t_opSt);
  end when;

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
  connect(risingEdgeHP.u, pre1.y) annotation (Line(points={{-43.6,84},{-60,84},{
          -60,109.6}},            color={255,0,255}));
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
        points={{-6.8,-34},{-22,-34},{-22,4},{14,4},{14,46},{10.4,46}},
                                                      color={255,0,255}));
  connect(pre1.y, fallingEdgeHP.u) annotation (Line(points={{-60,109.6},{-60,20},
          {-43.6,20}},          color={255,0,255}));
  connect(DemandAndNoPauseBuffer.u1, greaterEqualThreshold.y) annotation (Line(
        points={{7.2,-54},{-14,-54},{-14,-18},{30,-18},{30,44},{28,44},{28,46},
          {10.4,46}},                                   color={255,0,255}));
  connect(heatCurve.T_Amb, T_Amb) annotation (Line(points={{-77.2,-75},{-84,-75},
          {-84,-110},{-120,-110}},           color={0,0,127}));
  connect(T_Set_DHW.y, CalcDhwDemand.T_Set)
    annotation (Line(points={{-59,-19.3},{-60,-19.3},{-60,-13.8},{-56.4444,
          -13.8}},                                                                            color={0,0,127}));
  connect(CalcBufferDemand.T_Set, heatCurve.T_Set)
    annotation (Line(points={{-56.4444,-59.8},{-56,-59.8},{-56,-78},{-63.4,-78}},           color={0,0,127}));
  connect(heatCurve.T_Thres, T_Thresh) annotation (Line(points={{-77.2,-81},{-78,
          -81},{-78,-118},{-40,-118},{-40,-128},{0,-128}},
                                     color={0,0,127}));
  connect(less.y, DemandBuffer.u2) annotation (Line(points={{-25.6,-64},{-26,
          -64},{-26,-61.2},{-22.8,-61.2}}, color={255,0,255}));
  connect(less.u1, T_Amb) annotation (Line(points={{-34.8,-64},{-46,-64},{-46,-110},
          {-120,-110}}, color={0,0,127}));
  connect(DemandAndNoPauseBuffer.u2, DemandBuffer.y) annotation (Line(points={{7.2,
          -57.2},{-7.4,-57.2},{-7.4,-58},{-13.6,-58}},      color={255,0,255}));
  connect(heatCurve.m, m.y) annotation (Line(points={{-77.2,-78},{-82,-78},{-82,
          -96},{-135,-96}},color={0,0,127}));
  connect(lessThreshold.u, T_Amb) annotation (Line(points={{34.8,-100},{-34,-100},
          {-34,-110},{-120,-110}}, color={0,0,127}));
  connect(DemandBuffer.u1, CalcBufferDemand.OnOff_HP) annotation (Line(points={{-22.8,
          -58},{-34,-58},{-34,-51.4},{-44.9333,-51.4}},        color={255,0,255}));
  connect(lessEqualThreshold.y, chooseHP2_1.RunForced) annotation (Line(points={{6.4,94},
          {54,94},{54,-27.4},{55,-27.4}},           color={255,0,255}));
  connect(DemandAndNoPauseDHW.y, chooseHP2_1.DemandDHW) annotation (Line(points={{2.4,-34},
          {18,-34},{18,-39.1},{39.4,-39.1}},            color={255,0,255}));
  connect(DemandAndNoPauseBuffer.y, chooseHP2_1.DemandBuffer) annotation (Line(
        points={{16.4,-54},{28,-54},{28,-52.1},{39.4,-52.1}}, color={255,0,255}));
  connect(booleanExpression.y, HR_Tbiv.u2) annotation (Line(points={{49,-122},{60,
          -122},{60,-99.2},{67.2,-99.2}}, color={255,0,255}));
  connect(T_Thresh, less.u2) annotation (Line(points={{0,-128},{0,-72},{-42,-72},
          {-42,-67.2},{-34.8,-67.2}}, color={0,0,127}));
  connect(realExpression.y, CalcDhwDemand.T_Top) annotation (Line(points={{-97,10},
          {-76,10},{-76,-4},{-70.4444,-4}}, color={0,0,127}));
  connect(realExpression.y, CalcDhwDemand.T_2) annotation (Line(points={{-97,10},
          {-76,10},{-76,-12},{-70.4444,-12}}, color={0,0,127}));
  connect(realExpression.y, chooseHP2_1.T_Top_DHW) annotation (Line(points={{-97,10},
          {24,10},{24,-32.6},{39.4,-32.6}},     color={0,0,127}));
  connect(realExpression1.y, CalcBufferDemand.T_Top) annotation (Line(points={{-97,-28},
          {-86,-28},{-86,-50},{-70.4444,-50}},          color={0,0,127}));
  connect(realExpression1.y, chooseHP2_1.T_Top_Buffer) annotation (Line(points={{-97,-28},
          {-86,-28},{-86,-45.6},{39.4,-45.6}},            color={0,0,127}));
  connect(realExpression2.y, CalcBufferDemand.T_2)
    annotation (Line(points={{-97,-58},{-70.4444,-58}}, color={0,0,127}));
  connect(chooseHP2_1.DHW_OnOff, HPactive.u1) annotation (Line(points={{69.3,-36.24},
          {78,-36.24},{78,-11},{91,-11}}, color={255,0,255}));
  connect(chooseHP2_1.Buffer_OnOff, HPactive.u2) annotation (Line(points={{69.3,
          -49.5},{82,-49.5},{82,-15},{91,-15}}, color={255,0,255}));
  connect(HPactive.y, pre1.u) annotation (Line(points={{102.5,-11},{114,-11},{114,
          136},{-60,136},{-60,118.8}}, color={255,0,255}));
  connect(HPactive.y, counter_switchOn.IsOn) annotation (Line(points={{102.5,-11},
          {141.5,-11},{141.5,-12.1}}, color={255,0,255}));
  connect(HPactive.y, HP_OnOff) annotation (Line(points={{102.5,-11},{124,-11},
          {124,20},{144,20}},color={255,0,255}));
  connect(DemandAndNoPauseDHW.u2, CalcDhwDemand.OnOff_HP) annotation (Line(
        points={{-6.8,-37.2},{-30,-37.2},{-30,-5.4},{-44.9333,-5.4}}, color={255,
          0,255}));
  connect(chooseHP2_1.DHW_OnOff, LoadDhwSto) annotation (Line(points={{69.3,
          -36.24},{110,-36.24},{110,-38},{138,-38}},
                                             color={255,0,255}));
  connect(chooseHP2_1.Buffer_OnOff, LoadHeatingSto) annotation (Line(points={{69.3,
          -49.5},{106,-49.5},{106,-68},{138,-68}}, color={255,0,255}));
  connect(CalcBufferDemand.OnOff_HR, HRactive.u2) annotation (Line(points={{
          -44.9333,-56.6},{-40,-56.6},{-40,-81},{43,-81}},
                                                  color={255,0,255}));
  connect(CalcDhwDemand.OnOff_HR, HRactive.u1) annotation (Line(points={{
          -44.9333,-10.6},{-38,-10.6},{-38,-77},{43,-77}},
                                                  color={255,0,255}));
  connect(HRactive.y, HR_Tbiv.u1) annotation (Line(points={{54.5,-77},{62,-77},{
          62,-96},{67.2,-96}}, color={255,0,255}));
  connect(LoadDhwSto, LoadDhwSto)
    annotation (Line(points={{138,-38},{138,-38}}, color={255,0,255}));
  connect(LoadHeatingSto, LoadHeatingSto)
    annotation (Line(points={{138,-68},{138,-68}}, color={255,0,255}));
  connect(heatCurve.T_Set, T_heatCurve) annotation (Line(points={{-63.4,-78},{
          -60,-78},{-60,-90},{-48,-90}}, color={0,0,127}));
  connect(T_Amb, lessThreshold1.u) annotation (Line(points={{-120,-110},{-88,-110},
          {-88,-130},{64.8,-130}}, color={0,0,127}));
  connect(HR_Tbiv.y, HR_Tbiv1.u1)
    annotation (Line(points={{76.4,-96},{91.2,-96}}, color={255,0,255}));
  connect(HR_Tbiv1.y, HR_OnOff)
    annotation (Line(points={{100.4,-96},{140,-96}}, color={255,0,255}));
  connect(booleanExpression.y, HR_Tbiv1.u2) annotation (Line(points={{49,-122},
          {82,-122},{82,-99.2},{91.2,-99.2}}, color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-120,-120},{120,120}}),
                                                                graphics={
        Rectangle(
          extent={{120,120},{-120,-120}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-104,42},{96,-30}},
          lineColor={0,0,0},
          pattern=LinePattern.Dash,
          lineThickness=0.5,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="HP Control")}),                            Diagram(
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
")}),
    experiment(StopTime=3801600, __Dymola_NumberOfIntervals=10000));
end System_controller;
