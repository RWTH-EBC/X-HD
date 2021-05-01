within Configurations.Case.Archive;
model HP_Buffer_DHW_DIN_Parallel
  HeatPump_Buffer_DIN heatPump_Buffer_DIN_newcontrol(T_Min_hysteresis_Buffer=
        control_HP_BufferDHW_LockoutAndRunForced_krit.T_Min_Storage_Buffer)
    annotation (Placement(transformation(extent={{-82,-92},{22,-14}})));
  HeatPump_DHW_DIN heatPump_DHW_DIN_newcontrol(T_Min_hysteresis_DHW=
        control_HP_BufferDHW_LockoutAndRunForced_krit.T_Min_Storage_DHW)
    annotation (Placement(transformation(extent={{-52,10},{46,100}})));
  Controls.Control_HP_BufferDHW_LockoutAndRunForced_krit
    control_HP_BufferDHW_LockoutAndRunForced_krit(
    MinRunTime=10,
    T_Max_Storage_Buffer=328.15,
    T_Min_Storage_Buffer=318.15)
    annotation (Placement(transformation(extent={{-94,-10},{-56,18}})));
  General.calc_FinalEnergy calc_FinalEnergy
    annotation (Placement(transformation(extent={{58,-60},{78,-40}})));
equation
  connect(control_HP_BufferDHW_LockoutAndRunForced_krit.HP_DHW_OnOff,
    heatPump_DHW_DIN_newcontrol.HeatPump_DHW_on) annotation (Line(points={{
          -54.6429,13},{-54.6429,24.3214},{-53.47,24.3214},{-53.47,36.55}},
        color={255,0,255}));
  connect(control_HP_BufferDHW_LockoutAndRunForced_krit.HP_Buffer_OnOff,
    heatPump_Buffer_DIN_newcontrol.HeatPump_Buffer_on) annotation (Line(points={{
          -54.6429,-5},{-54.6429,-40.3214},{-84.08,-40.3214},{-84.08,-76.4}},
        color={255,0,255}));
  connect(heatPump_Buffer_DIN_newcontrol.T_Top_Buffer,
    control_HP_BufferDHW_LockoutAndRunForced_krit.T_Top_Buffer) annotation (
      Line(points={{25.12,-32.72},{-103.44,-32.72},{-103.44,-6},{-94,-6}},
        color={0,0,127}));
  connect(heatPump_DHW_DIN_newcontrol.T_Top_DHW,
    control_HP_BufferDHW_LockoutAndRunForced_krit.T_Top_DHW) annotation (Line(
        points={{48.94,79.3},{-101.53,79.3},{-101.53,14},{-94,14}}, color={0,0,
          127}));
  connect(heatPump_DHW_DIN_newcontrol.Q_flow_HP_DHW, calc_FinalEnergy.Q_flow_HP_DHW)
    annotation (Line(points={{47.96,46},{52,46},{52,-41},{57.6,-41}}, color={0,
          0,127}));
  connect(heatPump_DHW_DIN_newcontrol.COP_carnot_DHW, calc_FinalEnergy.COP_DHW)
    annotation (Line(points={{48.94,19},{48.94,-13.5},{57.6,-13.5},{57.6,-44.8}},
        color={0,0,127}));
  connect(heatPump_Buffer_DIN_newcontrol.Q_flow_HP, calc_FinalEnergy.Q_flow_HP_Buffer)
    annotation (Line(points={{25.12,-21.8},{40.56,-21.8},{40.56,-48.6},{57.6,
          -48.6}}, color={0,0,127}));
  connect(heatPump_Buffer_DIN_newcontrol.COP_Buffer, calc_FinalEnergy.COP_Buffer)
    annotation (Line(points={{26.16,-82.64},{26.16,-67.32},{57.6,-67.32},{57.6,
          -52.4}}, color={0,0,127}));
  connect(heatPump_Buffer_DIN_newcontrol.Q_flow_HeatingRod, calc_FinalEnergy.Q_flow_HR_Buffer)
    annotation (Line(points={{25.12,-58.46},{40.56,-58.46},{40.56,-56},{57.6,
          -56}}, color={0,0,127}));
  connect(heatPump_DHW_DIN_newcontrol.Q_flow_HeatingRod_DHW, calc_FinalEnergy.Q_flow_HR_DHW)
    annotation (Line(points={{47.96,64},{52,64},{52,-59.6},{57.6,-59.6}}, color=
         {0,0,127}));
  connect(heatPump_Buffer_DIN_newcontrol.P_pump_HP_Buffer, calc_FinalEnergy.P_pump_HP_Buffer)
    annotation (Line(points={{-12.32,-94.34},{25.84,-94.34},{25.84,-38.8},{64,
          -38.8}}, color={0,0,127}));
  connect(heatPump_DHW_DIN_newcontrol.P_el_pump_HP_DHW, calc_FinalEnergy.P_pump_HP_DHW)
    annotation (Line(points={{-3,7.3},{32.5,7.3},{32.5,-38.8},{68,-38.8}},
        color={0,0,127}));
  connect(heatPump_Buffer_DIN_newcontrol.P_pump_Buffer_demand, calc_FinalEnergy.P_pump_demand)
    annotation (Line(points={{9.52,-94.34},{40.76,-94.34},{40.76,-38.8},{72,
          -38.8}}, color={0,0,127}));
  connect(heatPump_DHW_DIN_newcontrol.P_el_pump_DHW, calc_FinalEnergy.P_pump_dhw)
    annotation (Line(points={{26.4,7.3},{51.2,7.3},{51.2,-38.8},{76,-38.8}},
        color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end HP_Buffer_DHW_DIN_Parallel;
