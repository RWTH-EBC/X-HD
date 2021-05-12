within VCLib.HeatPumpFlowSheets.HPS_model.Components.Generation;
package Heater
  model HeatingRod
    "Simple heating rod - always using full nominal power (on/off controlled)"
    extends AixLib.Fluid.Interfaces.PartialTwoPort;

    /******************************* Parameters *******************************/
    parameter Real eta = 0.97 "Heating rod efficiency";
    parameter Modelica.SIunits.Power P_elNom = 5000 "Nominal heating power of heating rod";
    parameter Modelica.SIunits.Volume V_vol = 0.001 "Volume of volume";
    parameter Modelica.SIunits.MassFlowRate m_flowNom = 0.2 "Nominal mass flow rate used for volume";
  protected
    parameter Modelica.SIunits.Power P_elDem = P_elNom / eta "Electric power demand of heating rod";

    /******************************* Components *******************************/

  public
    Modelica.Blocks.Interfaces.BooleanInput OnOff
      "Boolean defining whether heating rod is activated or deactivated"
      annotation (Placement(transformation(extent={{-126,34},{-86,74}})));
    AixLib.Fluid.MixingVolumes.MixingVolume vol(nPorts=2, redeclare package
        Medium = Medium,
      m_flow_nominal=m_flowNom,
      V=V_vol)           annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={0,28})));
    Modelica.Blocks.Logical.Switch switch1
      annotation (Placement(transformation(extent={{-70,18},{-50,38}})));
    Modelica.Blocks.Sources.RealExpression dummyZero "Dummy zero value"
      annotation (Placement(transformation(extent={{-100,10},{-80,30}})));
    Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow
      annotation (Placement(transformation(extent={{-40,18},{-20,38}})));
    Modelica.Blocks.Sources.RealExpression dummyHeatingPower(y=P_elNom)
      "Dummy heating power"
      annotation (Placement(transformation(extent={{-100,68},{-80,88}})));
    Modelica.Blocks.Interfaces.RealOutput P_el annotation (Placement(
          transformation(extent={{96,56},{116,76}}), iconTransformation(extent={{
              96,56},{116,76}})));
    Modelica.Blocks.Math.Gain gain(k=1/eta)
      annotation (Placement(transformation(extent={{32,56},{52,76}})));
  equation
    connect(port_a, vol.ports[1]) annotation (Line(points={{-100,0},{-4,0},{-4,18},
            {-2,18}}, color={0,127,255}));
    connect(port_b, vol.ports[2])
      annotation (Line(points={{100,0},{0,0},{0,18},{2,18}}, color={0,127,255}));
    connect(prescribedHeatFlow.port, vol.heatPort)
      annotation (Line(points={{-20,28},{-10,28}}, color={191,0,0}));
    connect(dummyZero.y, switch1.u3)
      annotation (Line(points={{-79,20},{-72,20}}, color={0,0,127}));
    connect(OnOff, switch1.u2) annotation (Line(points={{-106,54},{-82,54},{-82,28},
            {-72,28}}, color={255,0,255}));
    connect(switch1.y, prescribedHeatFlow.Q_flow)
      annotation (Line(points={{-49,28},{-40,28}}, color={0,0,127}));
    connect(dummyHeatingPower.y, switch1.u1) annotation (Line(points={{-79,78},{-76,
            78},{-76,36},{-72,36}}, color={0,0,127}));
    connect(gain.y, P_el)
      annotation (Line(points={{53,66},{106,66}}, color={0,0,127}));
    connect(switch1.y, gain.u) annotation (Line(points={{-49,28},{-46,28},{-46,66},
            {30,66}}, color={0,0,127}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -80},{100,80}}), graphics={Rectangle(
            extent={{-100,70},{100,-70}},
            lineColor={0,0,0},
            lineThickness=1,
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid)}),                      Diagram(
          coordinateSystem(preserveAspectRatio=false, extent={{-100,-80},{100,80}})),
          Documentation(info = "<html>
        <p>Simple on/off controlled heating rod. Always adds full capacity to enthalpy flow (in case it is activated).</p>
</html>",   revisions = "<html>
<p>01.08.2019, Christoph Höges</p>
<p><ul>
<li>implemented</li>
</ul></p>
</html>"));
  end HeatingRod;

  model SimpleHeatPump_Map_OneFlow "Simple heat pump using characteristic map"
    extends Partial_HeatPump_FixSupply;

    /******************************* Parameters *******************************/
    // Strings
    parameter String filename = "D:/cve-cho/sciebo/03-Daten/08-Kennfeld/Heatpumps.sdf" "Path to sdf file";
    parameter String dataset_COP = "/Refrigerants/R410A/COP" "Path within svg file to COP dataset";
    parameter String dataset_Qflow = "/Refrigerants/R410A/Q_dot_heating" "Path within svg file to Qflow dataset";
    parameter String dataset_QflowRef = "/Refrigerants/R410A/Q_dot_ref" "Path within svg file to QflowRef value";

    // Parameters Heat pump operation
    parameter Modelica.SIunits.Power Q_flowNom = 5000 "Nominal heating power of heat pump";
    parameter Real ratio_Qmin = 0.5 "Ratio of minimum partial load heating power to nominal heating power";

    parameter Modelica.SIunits.Power Q_flowTableMax = max(SDF.Functions.readDatasetDouble1D(Modelica.Utilities.Files.loadResource(filename), dataset_Qflow, "W"))*scaling "Max heat flow rate within sdf table already scaled!";

  protected
    parameter Modelica.SIunits.Power Q_flowHpRef = SDF.Functions.readDatasetDouble(Modelica.Utilities.Files.loadResource(filename), dataset_QflowRef, "W") "Reference table heating power of heat pump at T tuple -2°C/55°C in [W]";
    parameter Real scaling = Q_flowNom / Q_flowHpRef "Scaling of current heat pump in regards to tabled heat pump";

    /******************************* Variables *******************************/
  public
    Modelica.SIunits.SpecificEnthalpy h_supplySet "Specific enthalpy of medium at supply set temperature";

    /******************************* Components *******************************/

    Q_flow_set q_flow_set(
      q_minRel=ratio_Qmin,
      Q_flowHpSet=Q_flowNom,
      m_flow_supply=port_a.m_flow,
      h_return=inStream(port_a.h_outflow),
      h_supplySet=h_supplySet,
      Q_flow_max=Q_flowTableMax) annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=90,
          origin={-48,-66})));

    SDF.NDTable Table_COP(
      dataUnit="-",
      scaleUnits={"K","K","W"},
      nin=3,
      extrapMethod=SDF.Types.ExtrapolationMethod.Hold,
      filename=filename,
      dataset=dataset_COP)
             "nD table with performance map of heat pump"
      annotation (Placement(transformation(extent={{-68,6},{-48,26}})));
    Modelica.Blocks.Math.Division division
      annotation (Placement(transformation(extent={{-16,24},{-6,34}})));
    Modelica.Blocks.Sources.RealExpression dummyQScaling(y=scaling)
      "Scaling for heat pump power "
      annotation (Placement(transformation(extent={{-54,-102},{-74,-82}})));
    Modelica.Blocks.Math.Division rescaled_Q_flow
      "Calculated heat flow needs to be rescaled for table"
                                                  annotation (Placement(
          transformation(
          extent={{-6,6},{6,-6}},
          rotation=90,
          origin={-78,-44})));
  equation

    h_supplySet = Medium.specificEnthalpy(state=
                      Medium.setState_pTX(p=port_b.p, T=T_supplySet, X=port_b.Xi_outflow));

    connect(division.y, SwitchPower.u1) annotation (Line(points={{-5.5,29},{1.25,29},
            {1.25,28},{10,28}}, color={0,0,127}));
    connect(TSupply.T, Table_COP.u[1]) annotation (Line(points={{79,32},{40,32},{
            40,50},{-76,50},{-76,14.6667},{-70,14.6667}},
                                                       color={0,0,127}));
    connect(T_amb, Table_COP.u[2]) annotation (Line(points={{-100,40},{-80,40},{-80,
            16},{-70,16}}, color={0,0,127}));
    connect(rescaled_Q_flow.y, Table_COP.u[3]) annotation (Line(points={{-78,
            -37.4},{-78,17.3333},{-70,17.3333}},
                                          color={0,0,127}));
    connect(q_flow_set.Q_flow, rescaled_Q_flow.u1) annotation (Line(points={{-48,-55.4},
            {-48,-44},{-66,-44},{-66,-54},{-74.4,-54},{-74.4,-51.2}}, color={0,0,127}));
    connect(rescaled_Q_flow.u2, dummyQScaling.y) annotation (Line(points={{-81.6,-51.2},
            {-81.6,-92},{-75,-92}}, color={0,0,127}));
    connect(q_flow_set.Q_flow, division.u1) annotation (Line(points={{-48,-55.4},
            {-48,-12},{-58,-12},{-58,32},{-17,32}},color={0,0,127}));
    connect(Table_COP.y, division.u2) annotation (Line(points={{-47,16},{-26,16},
            {-26,26},{-17,26}}, color={0,0,127}));
    connect(q_flow_set.Q_flow, SwitchHeatFlowCondenser.u1) annotation (Line(
          points={{-48,-55.4},{-48,-12},{10,-12}}, color={0,0,127}));
  annotation(Documentation(info = "<html>
<p>Simple heat pump model using characteristic map to calcuate actual COP. Model calculates needed heat flow using return flow enthalpy as well as enthalpy at set supply temperature.
        Heat pump can run in partial loading mode - min heat flow rate is defined by ration_Qmin. Source flow will be neglected and only ambient air temperature will be used.</p>
</html>",   revisions = "<html>
<p>01.08.2019, Christoph Höges</p>
<p><ul>
<li>implemented</li>
</ul></p>
</html>"));
  end SimpleHeatPump_Map_OneFlow;

  partial model Partial_HeatPump "Partial heat pump model for one flow"

    /******************************* Parameters *******************************/
    replaceable package Medium =
        Modelica.Media.Interfaces.PartialMedium "Medium in the component"
        annotation (choicesAllMatching = true);

    parameter Boolean allowFlowReversal = true
      "= false to simplify equations, assuming, but not enforcing, no flow reversal"
      annotation(Dialog(tab="Assumptions"), Evaluate=true);

    parameter Modelica.SIunits.Volume V_con = 0.001 "Volume of condenser";
    parameter Modelica.SIunits.MassFlowRate m_flowNom = 0.2 "Nominal mass flow rate in condenser";

    /******************************* Components *******************************/

    Modelica.Fluid.Interfaces.FluidPort_a port_a(
      redeclare package Medium = Medium,
       m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
       h_outflow(start = Medium.h_default, nominal = Medium.h_default))
      "Fluid connector a (positive design flow direction is from port_a to port_b)"
      annotation (Placement(transformation(extent={{90,-70},{110,-50}})));
    Modelica.Fluid.Interfaces.FluidPort_b port_b(
      redeclare package Medium = Medium,
      m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
       h_outflow(start = Medium.h_default, nominal = Medium.h_default))
      "Fluid connector b (positive design flow direction is from port_a to port_b)"
      annotation (Placement(transformation(extent={{110,50},{90,70}})));

    Modelica.Blocks.Interfaces.BooleanInput OnOff
      "Boolean turning heat pump on or off" annotation (Placement(transformation(
          extent={{-20,-20},{20,20}},
          rotation=270,
          origin={0,120}), iconTransformation(
          extent={{-20,-20},{20,20}},
          rotation=270,
          origin={0,100})));
    Modelica.Blocks.Interfaces.RealInput T_amb
      "Current ambient air temperature in K"
      annotation (Placement(transformation(extent={{-120,20},{-80,60}}),
          iconTransformation(extent={{-120,20},{-80,60}})));
    Modelica.Blocks.Sources.RealExpression dummyZero
      annotation (Placement(transformation(extent={{-36,-10},{-16,10}})));
    Modelica.Blocks.Logical.Switch SwitchPower
      annotation (Placement(transformation(extent={{12,10},{32,30}})));
    Modelica.Blocks.Logical.Switch SwitchHeatFlowCondenser
      annotation (Placement(transformation(extent={{12,-30},{32,-10}})));
    Modelica.Blocks.Interfaces.RealOutput P_el
      "Electric power demand of heat pump in W"
      annotation (Placement(transformation(extent={{48,10},{68,30}}),
          iconTransformation(
          extent={{-10,-10},{10,10}},
          rotation=270,
          origin={0,-84})));
    AixLib.Fluid.MixingVolumes.MixingVolume vol(nPorts=2, redeclare package
        Medium =                                                                           Medium,
      m_flow_nominal=m_flowNom,
      allowFlowReversal=allowFlowReversal,
      V=V_con)                                                                                     annotation (Placement(
          transformation(
          extent={{-10,-10},{10,10}},
          rotation=90,
          origin={68,-2})));
    Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow HeatFlowCondenser
      annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=90,
          origin={68,-30})));
    AixLib.Fluid.Sensors.TemperatureTwoPort TSupply(m_flow_nominal=m_flowNom,
        redeclare package Medium = Medium) annotation (Placement(
          transformation(
          extent={{-10,-10},{10,10}},
          rotation=90,
          origin={90,32})));
    AixLib.Fluid.Sensors.TemperatureTwoPort TReturn(m_flow_nominal=m_flowNom,
        redeclare package Medium = Medium) annotation (Placement(
          transformation(
          extent={{-10,-10},{10,10}},
          rotation=90,
          origin={90,-34})));
  equation
    connect(OnOff, SwitchPower.u2)
      annotation (Line(points={{0,120},{0,20},{10,20}}, color={255,0,255}));
    connect(OnOff, SwitchHeatFlowCondenser.u2)
      annotation (Line(points={{0,120},{0,-20},{10,-20}}, color={255,0,255}));
    connect(dummyZero.y, SwitchPower.u3) annotation (Line(points={{-15,0},{-6,0},{
            -6,12},{10,12}}, color={0,0,127}));
    connect(dummyZero.y, SwitchHeatFlowCondenser.u3) annotation (Line(points={{-15,
            0},{-6,0},{-6,-28},{10,-28}}, color={0,0,127}));
    connect(SwitchPower.y, P_el)
      annotation (Line(points={{33,20},{58,20}}, color={0,0,127}));
    connect(vol.heatPort, HeatFlowCondenser.port)
      annotation (Line(points={{68,-12},{68,-20}}, color={191,0,0}));
    connect(SwitchHeatFlowCondenser.y, HeatFlowCondenser.Q_flow) annotation (Line(
          points={{33,-20},{42,-20},{42,-48},{68,-48},{68,-40}}, color={0,0,127}));
    connect(vol.ports[1], TSupply.port_a)
      annotation (Line(points={{78,-4},{90,-4},{90,22}}, color={0,127,255}));
    connect(TSupply.port_b, port_b)
      annotation (Line(points={{90,42},{90,60},{100,60}}, color={0,127,255}));
    connect(vol.ports[2], TReturn.port_b) annotation (Line(points={{78,-6.66134e-016},
            {90,-6.66134e-016},{90,-24}}, color={0,127,255}));
    connect(TReturn.port_a, port_a)
      annotation (Line(points={{90,-44},{90,-60},{100,-60}}, color={0,127,255}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={                                         Rectangle(extent = {{-80, 80}, {80, -80}}, lineColor = {0, 0, 255}, fillColor = {249, 249, 249},
              fillPattern =                                                                                                   FillPattern.Solid), Rectangle(extent = {{-80, 80}, {-60, -80}}, lineColor = {0, 0, 255}, fillColor = {170, 213, 255},
              fillPattern =                                                                                                   FillPattern.Solid), Rectangle(extent = {{60, 80}, {80, -80}}, lineColor = {0, 0, 255}, fillColor = {255, 170, 213},
              fillPattern =                                                                                                   FillPattern.Solid),
                                                                            Text(
            extent={{-80,-86},{86,-162}},
            lineColor={0,0,0},
            lineThickness=1,
            fillColor={255,255,255},
            fillPattern=FillPattern.None,
            textString="%name")}),                                 Diagram(
          coordinateSystem(preserveAspectRatio=false)),
          Documentation(info = "<html>
        <p>Partial model for simple heat pump. Source flow will be neglected and only ambient air temperature will be used.</p>
</html>",   revisions = "<html>
<p>01.08.2019, Christoph Höges</p>
<p><ul>
<li>implemented</li>
</ul></p>
</html>"));
  end Partial_HeatPump;

  partial model Partial_HeatPump_FixSupply
    "Partial heat pump model using supply temperature input"
    extends HPS_model.Components.Generation.Heater.Partial_HeatPump;

     /******************************* Components *******************************/
    Modelica.Blocks.Interfaces.RealInput T_supplySet
      "Supply set temperature in K" annotation (Placement(transformation(extent={{
              -120,-40},{-80,0}}), iconTransformation(extent={{-120,-40},{-80,0}})));

    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)),
             Documentation(info = "<html>
<p>Partial model for simple heat pump. Source flow will be neglected and only ambient air temperature will be used. Additional real input used to temperature of enthalpy flow leaving heat pump.</p>
</html>",   revisions = "<html>
<p>01.08.2019, Christoph Höges</p>
<p><ul>
<li>implemented</li>
</ul></p>
</html>"));
  end Partial_HeatPump_FixSupply;

  model StartUp_LossesFixed "Model calculating start-up losses"

    /******************************* Parameters *******************************/

    parameter Modelica.SIunits.Energy dQ_Loss = 452 / 1457 * 3.6e6 "Loss value for each on/off from Paper: Hengel, Heinzel 2014, Table 4 (Mode 2)";
    parameter Real COP_avg = 2.5 "Average COP to calculate electric power demand for loss value (Mode 2)";

    /******************************* Variables *******************************/

    Modelica.SIunits.Energy W_elLoss(start=0) "Total losses";

    /******************************* Components *******************************/
    Modelica.Blocks.Interfaces.BooleanInput OnOff_Hp "Heat pump on/off"
      annotation (Placement(transformation(extent={{-130,26},{-90,66}})));

  algorithm

      when OnOff_Hp then
        W_elLoss := W_elLoss + dQ_Loss/COP_avg;

      end when;

    annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
            Rectangle(
            extent={{-100,100},{100,-100}},
            lineColor={0,0,0},
            lineThickness=1,
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid), Text(
            extent={{-110,-112},{126,-180}},
            lineColor={0,0,0},
            lineThickness=1,
            fillColor={255,255,255},
            fillPattern=FillPattern.None,
            textString="%name")}),            Diagram(coordinateSystem(
            preserveAspectRatio=false)),
             Documentation(info = "<html>
<p>Model calcuating start-up losses. Not an exact model, simple penalizing start-up numbers of heat pump.</p>
</html>",   revisions = "<html>
<p>20.08.2019, Christoph Höges</p>
<p><ul>
<li>implemented</li>
</ul></p>
</html>"));
  end StartUp_LossesFixed;

  model Q_flow_set "Calculates needed heat flow and limits to max and min"

    /***************************** Parameters *********************************/
    parameter Real q_minRel = 0.5 "Minimum relative heating power (percentage of Q_flowHpSet) of heat pump";
    parameter Modelica.SIunits.Power Q_flowHpSet = 5000 "Nominal heating power of heat pump at -2/55";

    /***************************** Components *********************************/

    Modelica.Blocks.Interfaces.RealInput h_supplySet "Supply set enthalpy"
      annotation (Placement(transformation(extent={{-128,48},{-88,88}})));
    Modelica.Blocks.Interfaces.RealInput h_return
      "Specific enthalpy of return flow"
      annotation (Placement(transformation(extent={{-128,4},{-88,44}})));
    Modelica.Blocks.Interfaces.RealInput m_flow_supply
      "Mass flow rate of supply flow in kg/s"
      annotation (Placement(transformation(extent={{-128,-48},{-88,-8}})));
    Modelica.Blocks.Interfaces.RealInput Q_flow_max
      "Max heat flow at current ambient air temperature in W"
      annotation (Placement(transformation(extent={{-128,-90},{-88,-50}})));
    Modelica.Blocks.Interfaces.RealOutput Q_flow
      "Heat flow rate of heat pump in W"
      annotation (Placement(transformation(extent={{96,-10},{116,10}})));
    Modelica.Blocks.Math.Product Q_flow_theo "Theoretical needed heat flow in W"
      annotation (Placement(transformation(extent={{-60,8},{-48,20}})));
    Modelica.Blocks.Logical.Switch switch2 "Switch case greater Qmax"
      annotation (Placement(transformation(extent={{76,-4},{86,6}})));
    Modelica.Blocks.Logical.LessThreshold lessThreshold(threshold=Q_flowHpSet*
          q_minRel)
      annotation (Placement(transformation(extent={{-36,38},{-24,50}})));
    Modelica.Blocks.Sources.RealExpression dummyZero(y=Q_flowHpSet*q_minRel)
                                                          "Dummy for 0"
      annotation (Placement(transformation(extent={{-38,60},{-18,80}})));
    Modelica.Blocks.Logical.LessEqual lessEqual
      annotation (Placement(transformation(extent={{36,-4},{48,8}})));
    Modelica.Blocks.Logical.Switch switch3 "Switch case greater 0"
      annotation (Placement(transformation(extent={{16,28},{26,38}})));
    Modelica.Blocks.Math.Add add(k2=-1)
      annotation (Placement(transformation(extent={{-84,36},{-64,56}})));
  equation
    connect(Q_flow_max, switch2.u3) annotation (Line(points={{-108,-70},{54,-70},
            {54,-3},{75,-3}}, color={0,0,127}));
    connect(switch2.y, Q_flow) annotation (Line(points={{86.5,1},{96,1},{96,0},{
            106,0}}, color={0,0,127}));
    connect(Q_flow_theo.y, lessThreshold.u) annotation (Line(points={{-47.4,14},{
            -42,14},{-42,44},{-37.2,44}}, color={0,0,127}));
    connect(lessThreshold.y, switch3.u2) annotation (Line(points={{-23.4,44},{4,
            44},{4,33},{15,33}}, color={255,0,255}));
    connect(Q_flow_max, lessEqual.u2) annotation (Line(points={{-108,-70},{16,-70},
            {16,-2.8},{34.8,-2.8}}, color={0,0,127}));
    connect(lessEqual.y, switch2.u2) annotation (Line(points={{48.6,2},{62,2},{62,
            1},{75,1}}, color={255,0,255}));
    connect(switch3.y, lessEqual.u1) annotation (Line(points={{26.5,33},{30,33},{
            30,2},{34.8,2}}, color={0,0,127}));
    connect(switch3.y, switch2.u1) annotation (Line(points={{26.5,33},{66,33},{66,
            5},{75,5}}, color={0,0,127}));
    connect(dummyZero.y, switch3.u1) annotation (Line(points={{-17,70},{10,70},{
            10,37},{15,37}}, color={0,0,127}));
    connect(Q_flow_theo.y, switch3.u3) annotation (Line(points={{-47.4,14},{6,14},
            {6,29},{15,29}}, color={0,0,127}));
    connect(m_flow_supply, Q_flow_theo.u2) annotation (Line(points={{-108,-28},{-74,
            -28},{-74,10.4},{-61.2,10.4}}, color={0,0,127}));
    connect(h_supplySet, add.u1) annotation (Line(points={{-108,68},{-84,68},{-84,
            60},{-94,60},{-94,52},{-86,52}}, color={0,0,127}));
    connect(add.y, Q_flow_theo.u1) annotation (Line(points={{-63,46},{-56,46},{-56,
            28},{-74,28},{-74,17.6},{-61.2,17.6}}, color={0,0,127}));
    connect(h_return, add.u2) annotation (Line(points={{-108,24},{-82,24},{-82,34},
            {-94,34},{-94,40},{-86,40}}, color={0,0,127}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
            Rectangle(
            extent={{-100,100},{100,-100}},
            lineColor={0,0,0},
            lineThickness=1,
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid), Text(
            extent={{-100,46},{98,-38}},
            lineColor={0,0,0},
            lineThickness=1,
            fillColor={255,255,255},
            fillPattern=FillPattern.None,
            textString="%name")}), Diagram(coordinateSystem(preserveAspectRatio=
             false)),
             Documentation(info = "<html>
           <p>Model to calculate actual heating power of heat pump. Minimum value is defined by q_minRel percentage of nominal heating power</p>
</html>",   revisions = "<html>
<p>29.07.2019, Christoph Höges</p>
<p><ul>
<li>implemented</li>
</ul></p>
</html>"));
  end Q_flow_set;
end Heater;
