within VCLib.HeatPumpFlowSheets.HPS_model;
model System_MapOneHeatpump
  extends Modelica.Icons.Example;

 /******************************* Parameters *******************************/

  // Medium
  replaceable package Medium = AixLib.Media.Water "Medium within pipes";

  // Assumptions
  parameter Boolean allowFlowReversal = true
    "= false to simplify equations, assuming, but not enforcing, no flow reversal"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);

  // Optimization parameters
  parameter Modelica.SIunits.Power Q_flow_hp_biv = 5200 "Heat pump heat flow at T_biv -2°C"; // 4910
  parameter Modelica.SIunits.Power Q_flow_hr = 8100 "Electric power of heating rod"; // 10251
  parameter Modelica.SIunits.Volume v_buffer_sto = 0.690 "Volume of buffer storage - m^3"; // 0.735
  parameter Modelica.SIunits.Volume v_dhw_sto = 0.075 "Volume of dhw storage - m^3"; // 0.050
  parameter String refrigerant = "R410A" "Variable defining refrigerant"; // Note: Variable doesnt have any function in this model (simply used for optimization)

  // Filenames of input data (cluster data)
  parameter String filename_T_amb = ModelicaServices.ExternalReferences.loadResource("modelica://VCLib/HeatPumpFlowSheets/HPS_model/Data/TRY/00-Aachen_Normal/T_amb_buffer.mat") "Path to mat file with T_ambient data";
  parameter String filename_Qdem = ModelicaServices.ExternalReferences.loadResource("modelica://VCLib/HeatPumpFlowSheets/HPS_model/Data/TRY/00-Aachen_Normal/Q_dem_buffer.mat") "Path to mat file with Q_dem data";
  parameter String filename_DHW = ModelicaServices.ExternalReferences.loadResource("modelica://VCLib/HeatPumpFlowSheets/HPS_model/Data/TRY/00-Aachen_Normal/DHW_buffer.mat") "Path to mat file with DHW data";

  // String to sdf file
  parameter String filename_map = ModelicaServices.ExternalReferences.loadResource("modelica://VCLib/HeatPumpFlowSheets/HPS_model/Data/Kennfeld/Heatpumps.sdf") "Path to sdf file";
  parameter String dataset_COP = "/Refigerants/"+refrigerant+"/COP" "Path within svg file to COP dataset";
  parameter String dataset_Qflow = "/Refigerants/"+refrigerant+"/Q_dot_heating" "Path within svg file to Qflow dataset";
  parameter String dataset_QflowRef = "/Refigerants/"+refrigerant+"/Q_dot_ref" "Path within svg file to QflowRef value";

  // Generation
  parameter Modelica.SIunits.MassFlowRate m_flowGen = 0.18 "Mass flow rate through heat pump condenser" annotation(Dialog(group = "Generation"));
  parameter Modelica.SIunits.MassFlowRate m_flowNomGen = 0.2 "Nominal mass flow rate used in generation" annotation(Dialog(group = "Generation"));

  // Demand settings
  parameter Modelica.SIunits.MassFlowRate m_flowNomDem = 0.2 "Nominal mass flow rate used in demand" annotation(Dialog(group = "Demand"));
  parameter Modelica.SIunits.MassFlowRate m_flowDem = 0.24 "Mass flow rate in building" annotation(Dialog(group = "Demand"));
  parameter Modelica.SIunits.Temperature T_heatingThresh=288.15   "Heating threshold temperature - assumed to be 15°C" annotation(Dialog(group = "Demand"));
  parameter Modelica.SIunits.Pressure p_hydr=200000
                                                   "Hydraulic pressure in pipes" annotation(Dialog(group = "Demand"));
  parameter Modelica.SIunits.Temperature T_WaterCold=283.15   "Cold water temperature (new water)" annotation(Dialog(group = "Demand"));
  parameter Modelica.SIunits.Temperature T_dhw_set=323.15   "Set dhw storage temperature";

  // Storage settings
  parameter Modelica.SIunits.Temperature T_stoEnv=291.15   "Temperature of storage surroundings (assumed 18°C)" annotation(Dialog(group = "Storage"));
  parameter Integer n_stoLayer = 4 "Number of layers in storage" annotation(Dialog(group = "Storage"));
  parameter Modelica.SIunits.CoefficientOfHeatTransfer alpha_stoIn = 100 "Internal heat transfer coefficient" annotation(Dialog(group = "Storage"));
  parameter Modelica.SIunits.CoefficientOfHeatTransfer alpha_stoOut = 10
                                                                     "External heat transfer coefficient" annotation(Dialog(group = "Storage"));
  final parameter Real storage_H_dia_ratio = 2 "Storage tank height-diameter ration";
  parameter Modelica.SIunits.Length d_buffer_sto = (v_buffer_sto * 4 / (storage_H_dia_ratio * Modelica.Constants.pi))^(1/3) "Diameter of buffer storage";
  parameter Modelica.SIunits.Length h_buffer_sto = storage_H_dia_ratio * d_buffer_sto "Storage height";
  parameter Modelica.SIunits.Length d_dhw_sto = (v_dhw_sto * 4 / (storage_H_dia_ratio * Modelica.Constants.pi))^(1/3) "Diameter of dhw storage";
  parameter Modelica.SIunits.Length h_dhw_sto = storage_H_dia_ratio * d_dhw_sto "Storage height";

  // Heating Rod settings
  parameter Real eta_hr = 0.97 "Heating rod efficiency" annotation(Dialog(group = "Heating Rod"));
  parameter Modelica.SIunits.Power P_elNomHr = Q_flow_hr "Nominal heating power of heating rod" annotation(Dialog(group = "Heating Rod"));

  // Heat Pump settings
  parameter Modelica.SIunits.Power Q_flowNomHp = Q_flow_hp_biv "Nominal heating power of heat pump" annotation(Dialog(group="Heat Pump"));
  parameter Modelica.SIunits.Temperature T_bivNom=271.15   "Nominal bivalence temperature (assumption: -2°C)" annotation(Dialog(group="Heat Pump"));
  parameter Real ratio_Qmin = 0.5 "Ratio of minimum partial load heating power to nominal heating power of heat pump" annotation(Dialog(group="Heat Pump"));
  parameter Modelica.SIunits.Volume V_con = 0.001 "Volume of condenser" annotation(Dialog(group="Heat Pump"));

  // Controlling
  parameter Real gradient_heatCurve = 1.2 "Gradient of heat curve in K/K - define positive here!";
  parameter Modelica.SIunits.TemperatureDifference dT_loading = 10 "Temperature difference in storage hx between loading fluid and storage fluid";
  parameter Modelica.SIunits.TemperatureDifference dT_hys = 10 "Hysteresis for temperature regulation in storage";
  parameter Modelica.SIunits.TemperatureDifference dT_heater = 5 "Temperature difference when heating rod shall be activated (see controller)";

  // Algorithm
  parameter Integer n_buffer_days = 10 "Number of buffer days used at beginning of simulation (see input data)";
  final parameter Modelica.SIunits.Time sec_1_day = 86400 "Number of seconds within one day";

  /******************************* Variables *******************************/
protected
  Real on_off_counter_0 "Counter for hp on/off";
public
  Modelica.SIunits.Energy W_el "Electric demand in case no clustering is done in J";
  Modelica.SIunits.Energy W_tmp "Helper variable";
  Modelica.SIunits.Energy W_el_cl "Electric demand in case no clustering is done in J";
  Modelica.SIunits.Energy W_el_hr "Electric energy demand of heating rod in case of clustering in J";
  Integer mode(start=0) "Helper variable for algorithm";
  Real on_off_counter(start=0) "Counter for hp on/off of heat pump";
  Modelica.SIunits.Temperature T_bivAct = calc_Tbiv.T_biv "Actual bivalence temperature";
  Modelica.SIunits.Energy Q_demGes "Total heat demand";
  Modelica.SIunits.Energy Q_demWP "Total heat provided by heat pump";
  Modelica.SIunits.Time t_opHp "Operation time of heat pump";

  /******************************* Components *******************************/

  Components.Demand.DemandCase_v2 demandCase(
    redeclare package Medium = Medium,
    allowFlowReversal=allowFlowReversal,
    p_hydr=p_hydr,
    T_stoEnv=T_stoEnv,
    n_stoLayer=n_stoLayer,
    alpha_stoIn=alpha_stoIn,
    alpha_stoOut=alpha_stoOut,
    d_dhw_sto=d_dhw_sto,
    h_dhw_sto=h_dhw_sto,
    m_flowDem=m_flowDem,
    m_flowNomDem=m_flowNomDem,
    T_heatingThresh=T_heatingThresh,
    filename_Qdem=filename_Qdem,
    filename_DHW=filename_DHW,
    T_WaterCold=T_WaterCold,
    d_buf_sto=d_buffer_sto,
    h_buf_sto=h_buffer_sto)
    annotation (Placement(transformation(extent={{64,-14},{86,8}})));
  HPS_model.Components.Generation.GenerationMapCase generationCase(
    redeclare package Medium = Medium,
    p_hydr=p_hydr,
    m_flowGen=m_flowGen,
    m_flowNomGen=m_flowNomGen,
    eta_hr=eta_hr,
    P_elNomHr=P_elNomHr,
    Q_flowNomHp=Q_flowNomHp,
    ratio_Qmin=ratio_Qmin,
    V_con=V_con,
    allowFlowReversal=allowFlowReversal,
    filename=filename_map,
    dataset_COP=dataset_COP,
    dataset_Qflow=dataset_Qflow,
    dataset_QflowRef=dataset_QflowRef)
    annotation (Placement(transformation(extent={{-24,-12},{-2,10}})));
  Components.Controls.TSupplySetControl tSupplySetControl(T_dhw_set=T_dhw_set,
      dT_loading=dT_loading)
    annotation (Placement(transformation(extent={{-72,-12},{-52,8}})));
  Components.Generation.Calc_Tbiv calc_Tbiv(start_time=n_buffer_days*sec_1_day)
    annotation (Placement(transformation(extent={{22,68},{42,88}})));
  Components.Controls.System_controller system_controller(
    T_Thresh=T_heatingThresh,
    hysteresisDHW_HP=dT_hys,
    hysteresisBuffer_HP=dT_hys,
    T_Set_DHW_konst=T_dhw_set,
    hysteresisDHW_HR=dT_heater,
    hysteresisBuffer_HR=dT_heater,
    Gradient_HeatCurve=gradient_heatCurve,
    T_top_DHW=demandCase.T_stoTopDhw,
    T_top_buffer=demandCase.T_stoTopBuf,
    T_bot_buffer=demandCase.T_stoBotBuf,
    T_Biv=T_bivNom,
    T_Buffer_Thres_konst=293.15)
    annotation (Placement(transformation(extent={{-44,40},{-20,64}})));
  Modelica.Blocks.Sources.CombiTimeTable combiTimeTable_T_amb(
    tableOnFile=true,
    tableName="T_amb",
    fileName=filename_T_amb,
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    columns={2})
    annotation (Placement(transformation(extent={{-100,34},{-80,54}})));

  /******************************* Algorithm *******************************/
  Components.Generation.Heater.StartUp_LossesFixed startUp_Losses
    annotation (Placement(transformation(extent={{16,20},{36,40}})));
  inner Components.BaseClasses.BaseParameters.BaseParameters baseParameters
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
algorithm
  when n_buffer_days * sec_1_day < time then
    mode :=1;
    on_off_counter_0 :=system_controller.counter_switchOn.Count;
  end when;

equation

  der(W_el) = generationCase.P_el;

  if mode == 0 then
    der(W_tmp) = 0;
    der(W_el_hr) = 0;
    der(Q_demGes) = 0;
    der(Q_demWP) = 0;
    der(t_opHp) = 0;
  else
    der(W_tmp) = der(W_el);
    der(W_el_hr) = generationCase.P_el_hr;
    der(Q_demGes) = generationCase.heatingRod.prescribedHeatFlow.Q_flow + generationCase.heatPump.HeatFlowCondenser.Q_flow;
    der(Q_demWP) = generationCase.heatPump.HeatFlowCondenser.Q_flow;
    if system_controller.HP_OnOff then
      der(t_opHp) = 1;
    else
      der(t_opHp) = 0;
    end if;
  end if;
  W_el_cl = W_tmp + startUp_Losses.W_elLoss;

  // Defining on/off of heat pump
  on_off_counter = system_controller.counter_switchOn.Count - on_off_counter_0;
  connect(generationCase.port_b, demandCase.port_a) annotation (Line(points={{-2,3.4},
          {32,3.4},{32,1.4},{64,1.4}},      color={0,127,255}));
  connect(generationCase.port_a, demandCase.port_b) annotation (Line(points={{-2,-5.4},
          {32,-5.4},{32,-7.4},{64,-7.4}},       color={0,127,255}));
  connect(system_controller.HR_OnOff, calc_Tbiv.HeatingRod_OnOff) annotation (
      Line(points={{-30.7,39.1},{-30.7,32},{4,32},{4,82},{20,82}}, color={255,0,
          255}));
  connect(combiTimeTable_T_amb.y[1], system_controller.T_Amb) annotation (Line(
        points={{-79,44},{-44,44}},                   color={0,0,127}));
  connect(combiTimeTable_T_amb.y[1], calc_Tbiv.T_amb) annotation (Line(points={{-79,44},
          {-66,44},{-66,76},{20,76}},         color={0,0,127}));
  connect(combiTimeTable_T_amb.y[1], generationCase.T_amb) annotation (Line(
        points={{-79,44},{-66,44},{-66,20},{-34,20},{-34,4.06},{-25.1,4.06}},
        color={0,0,127}));
  connect(tSupplySetControl.y, generationCase.T_supSet) annotation (Line(points={{-51.4,
          -2},{-38,-2},{-38,-0.12},{-25.1,-0.12}},        color={0,0,127}));
  connect(system_controller.HP_OnOff, generationCase.hp_on) annotation (Line(
        points={{-35.5,39.1},{-35.5,24},{-18.5,24},{-18.5,11.1}},color={255,0,255}));
  connect(system_controller.HR_OnOff, generationCase.hr_on) annotation (Line(
        points={{-30.7,39.1},{-30.7,32},{-14.1,32},{-14.1,11.1}},color={255,0,255}));
  connect(system_controller.LoadHeatingSto, tSupplySetControl.buffer_on)
    annotation (Line(points={{-19,44.4},{-14,44.4},{-14,34},{-62,34},{-62,9.2}},
        color={255,0,255}));
  connect(system_controller.LoadDhwSto, tSupplySetControl.dhw_on) annotation (
      Line(points={{-19,48.2},{-16,48.2},{-16,36},{-70,36},{-70,16},{-66,16},{-66,
          9.2}}, color={255,0,255}));
  connect(system_controller.LoadDhwSto, demandCase.dhw_on) annotation (Line(
        points={{-19,48.2},{70.6,48.2},{70.6,9.32}}, color={255,0,255}));
  connect(system_controller.LoadHeatingSto, demandCase.buffer_on) annotation (
      Line(points={{-19,44.4},{75,44.4},{75,9.32}}, color={255,0,255}));
  connect(combiTimeTable_T_amb.y[1], demandCase.T_amb) annotation (Line(points={{-79,44},
          {-66,44},{-66,20},{-34,20},{-34,-38},{75,-38},{75,-14}},
        color={0,0,127}));
  connect(tSupplySetControl.T_buf_set, system_controller.T_heatCurve)
    annotation (Line(points={{-73.4,3},{-82,3},{-82,26},{-40.5,26},{-40.5,39.1}},
        color={0,0,127}));
  connect(system_controller.HP_OnOff, startUp_Losses.OnOff_Hp) annotation (Line(
        points={{-35.5,39.1},{-35.5,26},{8,26},{8,34.6},{15,34.6}}, color={255,0,
          255}));
  annotation (experiment(
      StopTime=5184000,
      Interval=3600,
      Tolerance=0.001,
      __Dymola_Algorithm="Dassl"));
end System_MapOneHeatpump;
