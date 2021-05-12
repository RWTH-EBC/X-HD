within VCLib.HeatPumpFlowSheets.HPS_model.Components.Generation;
model Calc_Tbiv
  "Calculates actual bivalence temperature of model - in case heating rod is never turned on, temperature stays at default 0"

  /****************************** Parameters *********************************/
  parameter Modelica.SIunits.Time start_time = 0 "Start time when logging should start. Is needed since simulation has starting buffer time!";

  /****************************** Variables **********************************/

  Modelica.SIunits.Temperature T_biv(start=0) "Actual bivalence temperature of system";

  /****************************** Components *********************************/
  Modelica.Blocks.Interfaces.BooleanInput HeatingRod_OnOff
    "Boolean defining whether heating rod is activated or not"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));
  Modelica.Blocks.Interfaces.RealInput T_amb
    "Current ambient air temperature in K"
    annotation (Placement(transformation(extent={{-140,-40},{-100,0}})));

  /****************************** Algorithm **********************************/
algorithm
  when HeatingRod_OnOff then
    if (T_amb > T_biv) and time > start_time then
      T_biv :=T_amb;
    else
      T_biv :=T_biv;
    end if;
  end when;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          lineThickness=1,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid), Text(
          extent={{-90,44},{92,-78}},
          lineColor={0,0,0},
          lineThickness=1,
          fillColor={255,255,255},
          fillPattern=FillPattern.None,
          textString="%name
")}), Diagram(coordinateSystem(preserveAspectRatio=false)));
end Calc_Tbiv;
