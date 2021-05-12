within VCLib.HeatPumpFlowSheets.HPS_model.Components.Controls;
model Hysteresis

  Modelica.Blocks.Interfaces.RealInput T_Top
    annotation (Placement(transformation(extent={{-120,10},{-80,50}}),
        iconTransformation(extent={{-100,30},{-80,50}})));
  Modelica.Blocks.Interfaces.BooleanOutput OnOff_HP
    annotation (Placement(transformation(extent={{100,20},{120,40}}),
        iconTransformation(extent={{60,12},{88,40}})));
  Modelica.Blocks.Interfaces.RealInput T_Set
    annotation (Placement(transformation(
          extent={{-20,-20},{20,20}},
        rotation=90,
        origin={0,-60}),                   iconTransformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-58})));
  Modelica.Blocks.Interfaces.BooleanOutput OnOff_HR
    annotation (Placement(
        transformation(extent={{100,-40},{120,-20}}), iconTransformation(extent={{60,-40},
            {88,-12}})));
  Modelica.Blocks.Interfaces.RealInput T_2
    annotation (Placement(transformation(extent={{-120,-70},{-80,-30}}),
        iconTransformation(extent={{-100,-50},{-80,-30}})));

  discrete Integer state_HP(start = 1); // 1: on, 2: off
  discrete Integer state_HR(start = 1);
  parameter Modelica.SIunits.TemperatureDifference Hysteresis = 10;
  parameter Modelica.SIunits.TemperatureDifference Hysteresis_HR = 5 "Additional threshold for heating rod, in case heat pump is not able to provide heat";

  Integer switch(start=0);

algorithm

    // top temperature smaller than min-hysteresis or (heating rod was activated and 2nd temperature smaller than min-hysteresis)
    if ((T_Top <= T_Set - (Hysteresis/2+Hysteresis_HR)) or ((pre(state_HR) == 1) and (T_2 < (T_Set - Hysteresis/2)))) then
      // activate heating rod and heat pump
      OnOff_HP :=true;
      OnOff_HR :=true;
      state_HP :=1;
      state_HR :=1;
      switch :=1;
    // (heat pump activated and 2nd temperature smaller than max-hysteresis) or top temperature smaller than min-hysteresis
    elseif (((pre(state_HP) == 1) and (T_2 < (T_Set + Hysteresis/2))) or (T_Top <= T_Set - Hysteresis/2)) then
      // activate heat pump
      OnOff_HP :=true;
      OnOff_HR :=false;
      state_HP :=1;
      state_HR :=2;
      switch :=2;
    // (heat pump activated and  2nd temperature higher than max-hysteresis) or (heat pump deactivated and top temperature higher than min-hysteresis)
    elseif (((pre(state_HP) == 1) and (T_2 >= T_Set + Hysteresis/2)) or ((pre(state_HP) == 2) and (T_Top > T_Set - Hysteresis/2))) then
      // deactivate heating rod and heat pump
      OnOff_HP :=false;
      OnOff_HR :=false;
      state_HP :=2;
      state_HR :=2;
      switch :=3;
    // otherwise
    else
      // Activate heat pump and deactivate heating rod
      OnOff_HP :=true;
      OnOff_HR :=false;
      state_HP :=1;
      state_HR :=2;
      switch :=4;
    end if;

//    // Top temperature below lower limit and heat pump deactivated -> activate heat pump
//    when T_Top < (T_Set - Hysteresis/2) then
//      // Heat pump activate
//      OnOff_HP :=true;
//      OnOff_HR :=false;
//      state_HP :=1;
//      state_HR :=2;
//      switch :=1;
//    end when;
//    // Top temperature below lower limit and heat pump is activated -> activate heating rod
//    when T_Top < (T_Set - Hysteresis/2 - Hysteresis_HR) then
//      // activate heating rod
//      OnOff_HP :=true;
//      OnOff_HR :=true;
//      state_HP :=1;
//      state_HR :=1;
//      switch :=2;
//    end when;
//    // Top temperature above upper hysteresis limit -> deactivate heating rod and heat pump
//    when T_2 > (T_Set + Hysteresis/2) then
//      // deactivate heat pump and heating rod
//      OnOff_HP :=false;
//      OnOff_HR :=false;
//      state_HP :=2;
//      state_HR :=2;
//      switch :=3;
//    end when;

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-60},{100,60}})),
                                          Icon(coordinateSystem(extent={{-100,-60},{80,60}},
                        preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-80,60},{60,-60}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5),
        Text(
          extent={{-70,56},{-16,24}},
          lineColor={0,0,127},
          textString="T_Top"),
        Text(
          extent={{2,-30},{58,-56}},
          lineColor={0,0,127},
          textString="T_Set"),
        Text(
          extent={{-12,16},{54,-10}},
          lineColor={255,0,255},
          textString="OnOff"),
        Text(
          extent={{-86,-26},{-30,-52}},
          lineColor={0,0,127},
          textString="T_2")}));
end Hysteresis;
