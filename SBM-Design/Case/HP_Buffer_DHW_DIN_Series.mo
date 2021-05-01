within Configurations.Case;
model HP_Buffer_DHW_DIN_Series

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

  //Mass flows in the cycles and heat pump design
  parameter Real m_flow_Cycle = HP_load_at_threshold/(T_diff*4180) "Water mass flow in cycle based on the assumption that the temperature difference has to be achieved at threshold temperature (e.g. 15 °C) [kg/s]"
                                                                                                                                                                                                        annotation(Evaluate=false,Dialog(group="Mass flow parameterization", descriptionLabel=true));
  parameter Real m_flow_DHW = 5.5/60 "Mass flow of fresh water entering the DHW storage based on assumptions in DIN 16147 [kg/s]"
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
  parameter Real dp_pump_DHW =  896724*m_flow_Cycle^1.7947
                                                       "Pressure drop over pump assuming same mass flow over heatpump in dhw cycle like in buffer storage cycle [Pa]"
                                                                                                                                                                     annotation(Evaluate=false,Dialog(group="Pressure losses", descriptionLabel=true));
  HeatPump_Buffer_DIN_newcontrol_series heatPump_Buffer_DIN_newcontrol(
    final m_flow_pump_HP=m_flow_Cycle,
    final T_diff_gen=T_diff,
    final T_NA=T_NA,
    final T_BIV=T_Biv_para,
    final T_THRESH=T_THRESH,
    final dp_HP=dp_HP,
    final dp_HR=dp_HR,
    final dp_building=dp_Building,
    final dp_max_total_Cycle=dp_HP + dp_HR + dp_Building,
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
    annotation (Placement(transformation(extent={{-34,-82},{64,0}})));

  HeatPump_DHW_DIN_newcontrol heatPump_DHW_DIN_newcontrol(
    h_Storage=dhw_h_Storage,
    h_lowerPorts=dhw_h_lowerPorts,
    h_upperPorts=dhw_h_upperPorts,
    h_upperHeatingCoil=dhw_h_upperHeatingCoil,
    h_lowerHeatingCoil=dhw_h_lowerHeatingCoil,
    h_upperHeatingCoil_2=dhw_h_upperHeatingCoil_2,
    h_lowerHeatingCoil_2=dhw_h_lowerHeatingCoil_2,
    h_heatingRod=dhw_h_heatingRod,
    d_Buffer=dhw_d_Buffer,
    h_lowerSenTemp=dhw_h_lowerSenTemp,
    h_upperSenTemp=dhw_h_upperSenTemp,
    Q_flow_HP_Biv=Q_flow_Biv_HP,
    Q_flow_HR_design=Q_HR_design,
    T_BIV=T_Biv_para,
    T_THRESH=T_THRESH,
    T_NA=T_NA,
    dp_HR=dp_HR,
    Q_HL=Q_HL,
    T_diff_gen=T_diff,
    dp_max_pump_HP=dp_pump_DHW,
    T_CW=T_CW_DHW,
    final m_flow_pump_HP=m_flow_Cycle,
    m_flow_pump_HC=m_flow_DHW,
    redeclare package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater,
    redeclare package MediumHC1 =
        Modelica.Media.Water.ConstantPropertyLiquidWater,
    redeclare package MediumHC2 =
        Modelica.Media.Water.ConstantPropertyLiquidWater,
    dp_HP=dp_HP)
    annotation (Placement(transformation(extent={{-32,16},{58,96}})));

  DataBase.Tamb_TRYAachen_2a tamb_TRYAachen_2a
    annotation (Placement(transformation(extent={{-98,-68},{-78,-48}})));
  General.calc_FinalEnergy calc_FinalEnergy
    annotation (Placement(transformation(extent={{96,4},{116,24}})));
  Controls.ControlUnit_HP_HR controlUnit_HP_HR(T_Biv=T_Biv_para)
    annotation (Placement(transformation(extent={{-98,6},{-70,30}})));
  Modelica.Blocks.Sources.Constant const(k=T_THRESH)
    annotation (Placement(transformation(extent={{-5,-5},{5,5}},
        rotation=-90,
        origin={-95,63})));
equation
  connect(tamb_TRYAachen_2a.y, heatPump_Buffer_DIN_newcontrol.T_amb)
    annotation (Line(points={{-77,-58},{-56,-58},{-56,-84},{-35.96,-84},{-35.96,
          -77.08}}, color={0,0,127}));
  connect(tamb_TRYAachen_2a.y, heatPump_DHW_DIN_newcontrol.T_amb) annotation (
      Line(points={{-77,-58},{-56,-58},{-56,20},{-33.8,20}}, color={0,0,127}));
  connect(heatPump_DHW_DIN_newcontrol.Q_flow_HP_DHW, calc_FinalEnergy.Q_flow_HP_DHW)
    annotation (Line(points={{59.8,48},{78,48},{78,23},{95.6,23}}, color={0,0,
          127}));
  connect(heatPump_DHW_DIN_newcontrol.COP_carnot_DHW, calc_FinalEnergy.COP_DHW)
    annotation (Line(points={{60.7,24},{78,24},{78,19.2},{95.6,19.2}}, color={0,
          0,127}));
  connect(heatPump_Buffer_DIN_newcontrol.Q_flow_HP, calc_FinalEnergy.Q_flow_HP_Buffer)
    annotation (Line(points={{66.94,-8.2},{81.47,-8.2},{81.47,15.4},{95.6,15.4}},
        color={0,0,127}));
  connect(heatPump_Buffer_DIN_newcontrol.COP_Buffer, calc_FinalEnergy.COP_Buffer)
    annotation (Line(points={{67.92,-75.44},{67.92,-31.72},{95.6,-31.72},{95.6,
          11.6}}, color={0,0,127}));
  connect(heatPump_Buffer_DIN_newcontrol.Q_flow_HeatingRod, calc_FinalEnergy.Q_flow_HR_Buffer)
    annotation (Line(points={{66.94,-46.74},{66.94,8.63},{95.6,8.63},{95.6,8}},
        color={0,0,127}));
  connect(heatPump_DHW_DIN_newcontrol.Q_flow_HeatingRod_DHW, calc_FinalEnergy.Q_flow_HR_DHW)
    annotation (Line(points={{59.8,64},{78,64},{78,4.4},{95.6,4.4}}, color={0,0,
          127}));
  connect(heatPump_Buffer_DIN_newcontrol.P_pump_HP_Buffer, calc_FinalEnergy.P_pump_HP_Buffer)
    annotation (Line(points={{31.66,-84.46},{31.66,-29.23},{102,-29.23},{102,
          25.2}}, color={0,0,127}));
  connect(heatPump_DHW_DIN_newcontrol.P_el_pump_HP_DHW, calc_FinalEnergy.P_pump_HP_DHW)
    annotation (Line(points={{13,13.6},{59.5,13.6},{59.5,25.2},{108.2,25.2}},
        color={0,0,127}));
  connect(heatPump_Buffer_DIN_newcontrol.P_pump_demand, calc_FinalEnergy.P_pump_demand)
    annotation (Line(points={{50.28,-84.46},{50.28,31.77},{114.2,31.77},{114.2,
          25.2}}, color={0,0,127}));
  connect(controlUnit_HP_HR.HP_DHW_OnOff, heatPump_DHW_DIN_newcontrol.HeatPump_DHW_on)
    annotation (Line(points={{-68.8333,27},{-54.2084,27},{-54.2084,39.6},{
          -33.35,39.6}}, color={255,0,255}));
  connect(controlUnit_HP_HR.HR_DHW_OnOff, heatPump_DHW_DIN_newcontrol.HR_onoff)
    annotation (Line(points={{-68.8333,22},{-54,22},{-54,81.2},{-33.35,81.2}},
        color={255,0,255}));
  connect(controlUnit_HP_HR.HP_Buffer_OnOff, heatPump_Buffer_DIN_newcontrol.HeatPump_Buffer_on)
    annotation (Line(points={{-68.8333,14},{-54,14},{-54,-58.22},{-35.96,-58.22}},
        color={255,0,255}));
  connect(controlUnit_HP_HR.HR_Buffer_OnOff, heatPump_Buffer_DIN_newcontrol.HR_onoff)
    annotation (Line(points={{-68.8333,9},{-56.2084,9},{-56.2084,-15.17},{
          -35.47,-15.17}}, color={255,0,255}));
  connect(heatPump_Buffer_DIN_newcontrol.T_Top_Buffer, controlUnit_HP_HR.T_Top_Buffer)
    annotation (Line(points={{66.94,-19.68},{-9.53,-19.68},{-9.53,10.8},{
          -81.6667,10.8}}, color={0,0,127}));
  connect(heatPump_Buffer_DIN_newcontrol.T_Bottom_Buffer, controlUnit_HP_HR.T_Bottom_Buffer)
    annotation (Line(points={{66.94,-31.98},{-10.53,-31.98},{-10.53,6},{
          -81.6667,6}}, color={0,0,127}));
  connect(heatPump_DHW_DIN_newcontrol.T_Top_DHW, controlUnit_HP_HR.T_Top_DHW)
    annotation (Line(points={{60.7,77.6},{-13.65,77.6},{-13.65,30},{-81.6667,30}},
        color={0,0,127}));
  connect(tamb_TRYAachen_2a.y, controlUnit_HP_HR.T_Amb) annotation (Line(points=
         {{-77,-58},{-94,-58},{-94,10},{-98,10}}, color={0,0,127}));
  connect(const.y, controlUnit_HP_HR.T_Thres) annotation (Line(points={{-95,57.5},
          {-95,43.5},{-98,43.5},{-98,30}},        color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>The system is based on a bivalent heat pump heating system with DHW demand.</p>
<p>The DHW storage is integrated in <b>parallel</b> and the buffer storage<b> in series</b>. </p>
<p>The model is used to test different design configurations and their effect on the system efficiency.</p>
<p>Following assumptions were made:</p>
<p><br><h4>1. General:</h4></p>
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
<p><br><br><h4>4. DHW storage:</h4></p>
<p><br>The DHW storage&acute;s volume can be adapted by changing its sizing parameters.</p><p><br>A Python script was used to change set parameters according to respective volume.</p>
<p><br><h4>5. Buffer storage:</h4></p>
<p>For parameterization s. point 4.</p>
<p><br><h4>6. Pumps</h4></p>
<p>Pumps are modelled as dp-const. pumps.</p>
<p>Pressure losses remain constant. Thus, no part load bahviour is implemented.</p>
</html>"));
end HP_Buffer_DHW_DIN_Series;
