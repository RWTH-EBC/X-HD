within Configurations.Case;
model HP_Buffer_DHW_DIN_Parallel_newcontrol

  /////////Heating rod design parameters
  parameter Real Q_HR_design = 6641.61 "On/off heating rod heating capacity [W]"
                                                                                annotation(Evaluate=false,Dialog(group="Heating rod sizing", descriptionLabel=true));


  /////////DHW Storage sizing parameters
  //Default sizing parameters are based on a DHW volume of 100 l (DHW demand according to DIN 16147 profile M)
  parameter Real dhw_h_Storage = 0.7911 "m"
                                           annotation(Dialog(group="DHW storage sizing", descriptionLabel=true));
  parameter Real dhw_h_lowerPorts = 0.1 "m"
                                           annotation(Dialog(group="DHW storage sizing", descriptionLabel=true));
  parameter Real dhw_h_upperPorts = 0.7461 "m"
                                              annotation(Dialog(group="DHW storage sizing", descriptionLabel=true));
  parameter Real dhw_h_upperHeatingCoil = 0.6911 "m"
                                                    annotation(Dialog(group="DHW storage sizing", descriptionLabel=true));
  parameter Real dhw_h_lowerHeatingCoil = 0.1 "m"
                                                 annotation(Dialog(group="DHW storage sizing", descriptionLabel=true));
  parameter Real dhw_h_upperHeatingCoil_2 = 0.6911 "m"
                                                      annotation(Dialog(group="DHW storage sizing", descriptionLabel=true));
  parameter Real dhw_h_lowerHeatingCoil_2= 0.1 "m"
                                                  annotation(Dialog(group="DHW storage sizing", descriptionLabel=true));
  parameter Real dhw_h_heatingRod = 0.5 "m"
                                           annotation(Dialog(group="DHW storage sizing", descriptionLabel=true));
  parameter Real dhw_d_Buffer = 0.402 "m"
                                         annotation(Dialog(group="DHW storage sizing", descriptionLabel=true));
  parameter Real dhw_h_lowerSenTemp = 0.1 "m"
                                             annotation(Dialog(group="DHW storage sizing", descriptionLabel=true));
  parameter Real dhw_h_upperSenTemp = 0.7461 "m"
                                                annotation(Dialog(group="DHW storage sizing", descriptionLabel=true));

  parameter Real T_CW_DHW = 283.15 "Cold water temperatur of DHW water entering DHW storage [K]"; //Cold water temperatur of DHW water entering DHW storage

  //Buffer Storage sizing parameters
   //Default sizing parameters are based on a buffer storage volume of 193 l (assuming a specific buffer storage volume of 23.5 l/kW_WP)
  parameter Real buffer_h_Storage = 0.984 "m"
                                             annotation(Dialog(group="Buffer storage sizing", descriptionLabel=true));
  parameter Real buffer_h_lowerPorts = 0.0984 "m"
                                                 annotation(Dialog(group="Buffer storage sizing", descriptionLabel=true));
  parameter Real buffer_h_upperPorts = 0.886 "m"
                                                annotation(Dialog(group="Buffer storage sizing", descriptionLabel=true));
  parameter Real buffer_h_upperHeatingCoil = 0.886 "m"
                                                      annotation(Dialog(group="Buffer storage sizing", descriptionLabel=true));
  parameter Real buffer_h_lowerHeatingCoil = 0.098 "m"
                                                      annotation(Dialog(group="Buffer storage sizing", descriptionLabel=true));
  parameter Real buffer_h_upperHeatingCoil_2 = 0.886 "m"
                                                        annotation(Dialog(group="Buffer storage sizing", descriptionLabel=true));
  parameter Real buffer_h_lowerHeatingCoil_2= 0.098 "m"
                                                       annotation(Dialog(group="Buffer storage sizing", descriptionLabel=true));
  parameter Real buffer_h_heatingRod = 0.492 "m"
                                                annotation(Dialog(group="Buffer storage sizing", descriptionLabel=true));
  parameter Real buffer_d_Buffer = 0.5 "m"
                                          annotation(Dialog(group="Buffer storage sizing", descriptionLabel=true));
  parameter Real buffer_h_lowerSenTemp = 0.098 "m"
                                                  annotation(Dialog(group="Buffer storage sizing", descriptionLabel=true));
  parameter Real buffer_h_upperSenTemp = 0.886 "m"
                                                  annotation(Dialog(group="Buffer storage sizing", descriptionLabel=true));


  //Mass flows in the cycles
  parameter Real m_flow_HP = HP_load_at_threshold/(T_diff*4180) "Mass flow through heat pump condenser"
                                                             annotation(Evaluate=false,Dialog(group="Mass flow parameterization", descriptionLabel=true));
  parameter Real m_flow_DHW = 5.5/60 "Mass flow of fresh water entering the DHW storage based on assumptions in DIN 16147 [kg/s]"
                                                                                                                                 annotation(Dialog(group="Mass flow parameterization", descriptionLabel=true));
  parameter Real m_flow_HC = 0.233806 "Mass flow through building based on calculations by MoNetGen [kg/s]"
                                                                                                           annotation(Evaluate=false,Dialog(group="Mass flow parameterization", descriptionLabel=true));

  //Parameterization of Heat pump
  parameter Real T_NA = 261.15 "Standard outdoor temperature based on DIN 12831 for Aachen [K]"
                                                                                               annotation(Evaluate=false,Dialog(group="General", descriptionLabel=true));
  parameter Real T_Biv_para = 271.15 "Bivalence temperature used for parameterization of heat pump characteristic (here: based on DIN V 4701: bivalence temperature is -2 °C) [K]"
                                                                                                                                                                                   annotation(Evaluate=false,Dialog(group="General", descriptionLabel=true));
  parameter Real T_THRESH = 288.15 "Threshold temperature upon which no heat demand is considered (based on building characteristics) [K]"
                                                                                                                                          annotation(Evaluate=false,Dialog(group="General", descriptionLabel=true));
  parameter Real T_diff = 10 "Temperature difference over heat generation/building at design point [K]"
                                                                                                       annotation(Evaluate=false,Dialog(group="General", descriptionLabel=true));

  parameter Real Q_flow_HP_Biv_para = 8248.21 "Heat pump heating load at T_Biv_para; here, the guidelines provided by German standards DIN 15450/VDI4645 are used [W]" annotation(Evaluate=false,Dialog(group="Heat pump parameterization", descriptionLabel=true));
  parameter Real Q_flow_Biv_HP = 8248.21 "This parameter has to be adapted when changing sizes of the heat pump [W]" annotation(Evaluate=false,Dialog(group="Heat pump parameterization", descriptionLabel=true));
  parameter Real Q_HL = 9710.1 "Building heat load without DHW [W]" annotation(Evaluate=false,Dialog(group="General", descriptionLabel=true));
  parameter Real Q_flow_NA_HP_para = 0.46*Q_HL "Heat pump heating load at standard outside temperature; Assumption based on DIN 4701 [W]" annotation(Evaluate=false,Dialog(group="Heat pump parameterization", descriptionLabel=true));
  parameter Real Q_flow_NA_HP = Q_flow_NA_HP_para+(Q_flow_Biv_HP-Q_flow_HP_Biv_para)
                                                                                    annotation(Evaluate=false,Dialog(group="Heat pump parameterization", descriptionLabel=true));
  parameter Real gradient_HP = (Q_flow_HP_Biv_para-0.46*Q_HL)/(T_Biv_para-T_NA) "gradient of the heat pump performance characteristic in dotQ/T diagram [-]" annotation(Evaluate=false,Dialog(group="Heat pump parameterization", descriptionLabel=true));
  parameter Real HP_load_at_threshold = gradient_HP*(T_THRESH-T_NA)+ Q_flow_NA_HP "Heat pump heating load at threshold temperature [W]"
                                                                                                                                       annotation(Evaluate=false,Dialog(group="Heat pump parameterization", descriptionLabel=true));


  //Pressure losses in System
  parameter Real dp_Building = 8281.98 "Building pressure loss based on MoNetGen [Pa]"
                                                                                      annotation(Dialog(group="Pressure losses", descriptionLabel=true));
  parameter Real dp_HP = 5000 "Heat pump pressure losses [Pa]"
                                                              annotation(Evaluate=false,Dialog(group="Pressure losses", descriptionLabel=true));
  parameter Real dp_HR = 0 "Heating rod pressure losses [Pa]"
                                                             annotation(Dialog(group="Pressure losses", descriptionLabel=true));
  parameter Real dp_pump_DHW =  896724*m_flow_HP^1.7947
                                                       "Pressure drop over pump assuming same mass flow over heatpump in dhw cycle like in buffer storage cycle [Pa]"
                                                                                                                                                                     annotation(Evaluate=false,Dialog(group="Pressure losses", descriptionLabel=true));



  HeatPump_DHW_DIN_newcontrol heatPump_DHW_DIN_newcontrol(
    Q_flow_HP_Biv=Q_flow_Biv_HP,
    Q_flow_HR_design=Q_HR_design,
    h_Storage=dhw_h_Storage,
    h_lowerPorts=dhw_h_lowerPorts,
    h_upperPorts=dhw_h_upperPorts,
    h_upperHeatingCoil=dhw_h_upperHeatingCoil,
    h_lowerHeatingCoil=dhw_h_lowerHeatingCoil,
    h_heatingRod=dhw_h_heatingRod,
    d_Buffer=dhw_d_Buffer,
    h_lowerSenTemp=dhw_h_lowerSenTemp,
    h_upperSenTemp=dhw_h_upperSenTemp,
    h_upperHeatingCoil_2=dhw_h_upperHeatingCoil_2,
    h_lowerHeatingCoil_2=dhw_h_lowerHeatingCoil_2,
    T_BIV=T_Biv_para,
    T_THRESH=T_THRESH,
    T_NA=T_NA,
    Q_HL=Q_HL,
    dp_HR=dp_HR,
    T_diff_gen=T_diff,
    dp_max_pump_HP=dp_pump_DHW,
    dp_HP=dp_HP,
    final m_flow_pump_HP=m_flow_HP,
    m_flow_pump_HC=m_flow_DHW,
    final T_CW=T_CW_DHW,
    redeclare package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater,
    redeclare package MediumHC1 =
        Modelica.Media.Water.ConstantPropertyLiquidWater,
    redeclare package MediumHC2 =
        Modelica.Media.Water.ConstantPropertyLiquidWater)
    annotation (Placement(transformation(extent={{-8,14},{74,88}})));

  HeatPump_Buffer_DIN_newcontrol_parallel heatPump_Buffer_DIN_newcontrol(
    final m_flow_pump_HP=m_flow_HP,
    final m_flow_pump_HC=m_flow_HC,
    final T_diff_gen=T_diff,
    final T_NA=T_NA,
    final T_BIV=T_Biv_para,
    final T_THRESH=T_THRESH,
    final dp_HP=dp_HP,
    final dp_HR=dp_HR,
    final dp_building=dp_Building,
    final dp_max_pump_HP=dp_HP + dp_HR,
    final Q_HL=Q_HL,
    final Q_flow_HP_Biv=Q_flow_Biv_HP,
    final Q_flow_HR_design=Q_HR_design,
    final h_Storage=buffer_h_Storage,
    final h_lowerPorts=buffer_h_lowerPorts,
    final h_upperPorts=buffer_h_upperPorts,
    final h_upperHeatingCoil=buffer_h_upperHeatingCoil,
    final h_lowerHeatingCoil=buffer_h_lowerHeatingCoil,
    final h_upperHeatingCoil_2=buffer_h_upperHeatingCoil_2,
    final h_lowerHeatingCoil_2=buffer_h_lowerHeatingCoil_2,
    final h_heatingRod=buffer_h_heatingRod,
    final d_Buffer=buffer_d_Buffer,
    final h_lowerSenTemp=buffer_h_lowerSenTemp,
    final h_upperSenTemp=buffer_h_upperSenTemp,
    redeclare package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater,
    redeclare package MediumHC1 =
        Modelica.Media.Water.ConstantPropertyLiquidWater,
    redeclare package MediumHC2 =
        Modelica.Media.Water.ConstantPropertyLiquidWater)
    annotation (Placement(transformation(extent={{-36,-86},{48,-16}})));

  DataBase.Tamb_TRYAachen_2a tamb_TRYAachen_2a
    annotation (Placement(transformation(extent={{-98,-68},{-78,-48}})));
  General.calc_FinalEnergy calc_FinalEnergy
    annotation (Placement(transformation(extent={{82,-28},{102,-8}})));
  Controls.ControlUnit_HP_HR controlUnit_HP_HR(T_Biv=T_Biv_para)
    annotation (Placement(transformation(extent={{-92,0},{-44,24}})));
  Modelica.Blocks.Sources.Constant const(k=T_THRESH)
    annotation (Placement(transformation(extent={{-100,56},{-88,68}})));
equation
  connect(tamb_TRYAachen_2a.y, heatPump_Buffer_DIN_newcontrol.T_amb)
    annotation (Line(points={{-77,-58},{-30,-58},{-30,-82.5},{-37.68,-82.5}},
        color={0,0,127}));
  connect(tamb_TRYAachen_2a.y, heatPump_DHW_DIN_newcontrol.T_amb) annotation (
      Line(points={{-77,-58},{-30,-58},{-30,17.7},{-9.64,17.7}}, color={0,0,127}));
  connect(heatPump_DHW_DIN_newcontrol.Q_flow_HP_DHW, calc_FinalEnergy.Q_flow_HP_DHW)
    annotation (Line(points={{75.64,43.6},{75.64,17.8},{81.6,17.8},{81.6,-9}},
        color={0,0,127}));
  connect(heatPump_DHW_DIN_newcontrol.COP_carnot_DHW, calc_FinalEnergy.COP_DHW)
    annotation (Line(points={{76.46,21.4},{76.46,3.7},{81.6,3.7},{81.6,-12.8}},
        color={0,0,127}));
  connect(heatPump_Buffer_DIN_newcontrol.Q_flow_HP, calc_FinalEnergy.Q_flow_HP_Buffer)
    annotation (Line(points={{50.52,-21.6},{69.08,-21.6},{69.08,-16.6},{81.6,
          -16.6}},
        color={0,0,127}));
  connect(heatPump_Buffer_DIN_newcontrol.COP_Buffer, calc_FinalEnergy.COP_Buffer)
    annotation (Line(points={{51.36,-77.6},{51.36,-18.8},{81.6,-18.8},{81.6,
          -20.4}}, color={0,0,127}));
  connect(heatPump_Buffer_DIN_newcontrol.Q_flow_HeatingRod, calc_FinalEnergy.Q_flow_HR_Buffer)
    annotation (Line(points={{50.52,-61.5},{50.52,-23.95},{81.6,-23.95},{81.6,
          -24}}, color={0,0,127}));
  connect(heatPump_DHW_DIN_newcontrol.Q_flow_HeatingRod_DHW, calc_FinalEnergy.Q_flow_HR_DHW)
    annotation (Line(points={{75.64,58.4},{75.64,16.2},{81.6,16.2},{81.6,-27.6}},
        color={0,0,127}));
  connect(heatPump_Buffer_DIN_newcontrol.P_pump_HP_Buffer, calc_FinalEnergy.P_pump_HP_Buffer)
    annotation (Line(points={{0.12,-88.1},{0.12,-47.05},{88,-47.05},{88,-6.8}},
        color={0,0,127}));
  connect(heatPump_DHW_DIN_newcontrol.P_el_pump_HP_DHW, calc_FinalEnergy.P_pump_HP_DHW)
    annotation (Line(points={{33,11.78},{63.5,11.78},{63.5,-6.8},{94.2,-6.8}},
        color={0,0,127}));
  connect(heatPump_Buffer_DIN_newcontrol.P_pump_Buffer_demand, calc_FinalEnergy.P_pump_demand)
    annotation (Line(points={{32.04,-88.1},{32.04,-1.05},{100.2,-1.05},{100.2,
          -6.8}}, color={0,0,127}));
  connect(tamb_TRYAachen_2a.y, controlUnit_HP_HR.T_Amb) annotation (Line(points=
         {{-77,-58},{-112,-58},{-112,4},{-92,4}}, color={0,0,127}));
  connect(heatPump_Buffer_DIN_newcontrol.T_Top_Buffer, controlUnit_HP_HR.T_Top_Buffer)
    annotation (Line(points={{50.52,-32.8},{-7.74,-32.8},{-7.74,4.8},{-64,4.8}},
        color={0,0,127}));
  connect(heatPump_Buffer_DIN_newcontrol.T_Bottom_Buffer, controlUnit_HP_HR.T_Bottom_Buffer)
    annotation (Line(points={{50.52,-46.8},{-7.74,-46.8},{-7.74,0},{-64,0}},
        color={0,0,127}));
  connect(heatPump_DHW_DIN_newcontrol.T_Top_DHW, controlUnit_HP_HR.T_Top_DHW)
    annotation (Line(points={{76.46,70.98},{-75.77,70.98},{-75.77,24},{-64,24}},
        color={0,0,127}));
  connect(controlUnit_HP_HR.HP_DHW_OnOff, heatPump_DHW_DIN_newcontrol.HeatPump_DHW_on)
    annotation (Line(points={{-42,21},{-28,21},{-28,35.83},{-9.23,35.83}},
        color={255,0,255}));
  connect(controlUnit_HP_HR.HR_DHW_OnOff, heatPump_DHW_DIN_newcontrol.HR_onoff)
    annotation (Line(points={{-42,16},{-28,16},{-28,74.31},{-9.23,74.31}},
        color={255,0,255}));
  connect(controlUnit_HP_HR.HR_Buffer_OnOff, heatPump_Buffer_DIN_newcontrol.HR_onoff)
    annotation (Line(points={{-42,3},{-42,-12},{-42,-28.95},{-37.26,-28.95}},
        color={255,0,255}));
  connect(controlUnit_HP_HR.HP_Buffer_OnOff, heatPump_Buffer_DIN_newcontrol.HeatPump_Buffer_on)
    annotation (Line(points={{-42,8},{-42,-28},{-42,-65.7},{-37.68,-65.7}},
        color={255,0,255}));
  connect(const.y, controlUnit_HP_HR.T_Thres) annotation (Line(points={{-87.4,
          62},{-100,62},{-100,24},{-92,24}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment,
    __Dymola_experimentSetupOutput(events=false),
    __Dymola_experimentFlags(
      Advanced(GenerateVariableDependencies=false, OutputModelicaCode=false),
      Evaluate=false,
      OutputCPUtime=false,
      OutputFlatModelica=false),
    Documentation(info="<html>
<p>The system is based on a bivalent heat pump heating system with DHW demand.</p>
<p>The DHW storage is integrated in <b>parallel</b> and the buffer storage in <b>parallel</b>. </p>
<p>The model is used to test different design configurations and their effect on the system efficiency.</p>
<p>Following assumptions were made:</p>
<p><br><b>1. General:</b></p>
<p>The system is used to test various sizings of the 4 components: heat pump, heating rod, domestic hot water (DHW) storage and buffer storage.</p>
<p>Sizing methods are based on DIN EN 15450. </p>
<p><br><b>2. Heating rod:</b></p>
<p>The heating rod works in on/off mode.</p>
<p><br><b>3. Heat pump:</b></p>
<p>The heat pump works in on/off mode.</p>
<p>An idealised heat capacity function is calculated based on two set points:</p>
<p>a) The heat pump&acute;s capacity at standard ambient temperature (e.g. Aachen: -12 &deg;C) is 46 &percnt; of the building&acute;s heat load (based on DIN V 4701).</p>
<p>b) The bivalence point is used as second set point. For monoenergetic systems, a bivalence temperature of -2 &deg;C is recommended.</p>
<p><br>The resulting heat pump heating capacity characteristic is depicted in the following figure (red line):</p>
<p><img src=\"modelica://Configurations/../../../Students-Exchange/Austausch_lma_kbr/Dokumentation/HLH/Abb_NormativeAuswertung/abb3.PNG\"/></p>
<p><br><br><b>4. DHW storage:</b></p>
<p>The DHW storage&acute;s volume can be adapted by changing its sizing parameters.</p>
<p><br>A Python script was used to change set parameters according to respective volume.</p>
<p><br><b>5. Buffer storage:</b></p>
<p>For parameterization s. point 4.</p>
<p><br><b>6. Pumps</b></p>
<p>Pumps are modelled as dp-const. pumps.</p>
<p>Pressure losses remain constant. Thus, no part load bahviour is implemented.</p>
</html>"));
end HP_Buffer_DHW_DIN_Parallel_newcontrol;
