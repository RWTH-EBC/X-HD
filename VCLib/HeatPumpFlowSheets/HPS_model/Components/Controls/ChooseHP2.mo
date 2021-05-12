within VCLib.HeatPumpFlowSheets.HPS_model.Components.Controls;
model ChooseHP2 "Choose which heat pump should run - DHW has priority"

  parameter Modelica.SIunits.Temperature T_Set = 323.15;
  parameter Modelica.SIunits.TemperatureDifference Hysteresis = 10;
  parameter Modelica.SIunits.Temperature T_Min = T_Set - Hysteresis/2;
  parameter Modelica.SIunits.Temperature T_Max = T_Set + Hysteresis/2;

  Modelica.Blocks.Interfaces.BooleanInput DemandDHW
    annotation (Placement(transformation(extent={{-140,10},{-100,50}})));
  Modelica.Blocks.Interfaces.BooleanInput DemandBuffer
    annotation (Placement(transformation(extent={{-140,-90},{-100,-50}})));
  Modelica.Blocks.Interfaces.RealInput T_Top_DHW
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
  Modelica.Blocks.Interfaces.RealInput T_Top_Buffer
    annotation (Placement(transformation(extent={{-140,-40},{-100,0}})));
  Modelica.Blocks.Interfaces.BooleanOutput DHW_OnOff
    annotation (Placement(transformation(extent={{100,42},{120,62}})));
  Modelica.Blocks.Interfaces.BooleanOutput Buffer_OnOff
    annotation (Placement(transformation(extent={{100,-60},{120,-40}})));
  Modelica.Blocks.Interfaces.BooleanInput RunForced "Defines whether heat pump needs to keep running (see minRunTime)"
    annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={0,120})));
equation
  if (DemandDHW == true) then
    DHW_OnOff = true;
    Buffer_OnOff = false;
  elseif (DemandBuffer == true) then
    DHW_OnOff = false;
    Buffer_OnOff = true;
  elseif (RunForced == true and T_Top_Buffer < 373.15) then
    DHW_OnOff = false;
    Buffer_OnOff = true;
  elseif (RunForced == true and T_Top_DHW < 373.15) then
    DHW_OnOff = true;
    Buffer_OnOff = false;
  else
    DHW_OnOff = false;
    Buffer_OnOff = false;
  end if;

  annotation (Icon(graphics={
        Rectangle(
          extent={{-100,-6},{100,-94}},
          lineColor={28,108,200},
          pattern=LinePattern.Dash,
          lineThickness=0.5,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,94},{100,6}},
          lineColor={28,108,200},
          pattern=LinePattern.Dash,
          lineThickness=0.5,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-114,-10},{-6,-38}},
          lineColor={238,46,47},
          textString="T_Top"),
        Text(
          extent={{-112,98},{20,60}},
          lineColor={238,46,47},
          textString="T_Top"),
        Text(
          extent={{-78,42},{80,-4}},
          lineColor={217,67,180},
          textString="DHW"),
        Text(
          extent={{-64,-54},{66,-96}},
          lineColor={217,67,180},
          textString="Buffer")}));
end ChooseHP2;
