within Configurations.Controls;
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
  parameter Modelica.SIunits.TemperatureDifference Hysteresis_HR = 5;





equation

  if ((T_Top <= T_Set - (Hysteresis/2+Hysteresis_HR)) or ((pre(state_HR) == 1) and (T_2 < (T_Set - Hysteresis/2)))) then
    OnOff_HP = true;
    OnOff_HR = true;
    state_HP = 1;
    state_HR = 1;
  elseif (((pre(state_HP) == 1) and (T_2 < (T_Set + Hysteresis/2))) or (T_Top <= T_Set - Hysteresis/2)) then
    OnOff_HP = true;
    OnOff_HR = false;
    state_HP = 1;
    state_HR = 2;
  elseif (((pre(state_HP) == 1) and (T_2 >= T_Set + Hysteresis/2)) or ((pre(state_HP) == 2) and (T_Top > T_Set - Hysteresis/2))) then
    OnOff_HP = false;
    OnOff_HR = false;
    state_HP = 2;
    state_HR = 2;
  else
    OnOff_HP = true;
    OnOff_HR = false;
    state_HP = 1;
    state_HR = 2;
  end if;

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
