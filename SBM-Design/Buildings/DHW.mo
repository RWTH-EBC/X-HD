within Configurations.Buildings;
model DHW

  parameter Real dp_DHW = 500000 "Pa";
  parameter Real m_flow_DHW = 5.5/60 "kg/s";

  Modelica.Blocks.Sources.Constant Q_flow_design_dhw(final k=-Heatdemand.Q_flow_nominal)
    annotation (Placement(transformation(extent={{-96,14},{-76,34}})));
  AixLib.Fluid.HeatExchangers.HeaterCooler_u Heatdemand(
    Q_flow_nominal=-20000,
    final m_flow_nominal=m_flow_DHW,
    final dp_nominal=dp_DHW,
    redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{4,-52},{24,-32}})));

  Modelica.Blocks.Interfaces.RealOutput Q_dhw "Heat added to the fluid"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Fluid.Interfaces.FluidPort_a dhw_in(redeclare package Medium =
        Modelica.Media.Water.ConstantPropertyLiquidWater)
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-114,-110},{-94,-90}})));
  Modelica.Fluid.Interfaces.FluidPort_b dhw_out(redeclare package Medium =
        Modelica.Media.Water.ConstantPropertyLiquidWater)
    "Fluid connector b (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{94,-110},{114,-90}})));
  Modelica.Blocks.Interfaces.RealOutput dhw_OnOff
    annotation (Placement(transformation(extent={{100,84},{120,104}})));
  General.Heatratio_calc heatratio_calc1
    annotation (Placement(transformation(extent={{-40,26},{-24,40}})));
  DataBase.DHW_ProfilM dHW_ProfilM(table=[0,0; 25200,12600; 25230,0; 26100,
        11506.85; 26538,0; 27000,12600; 27030,0; 28860,12600; 28890,0; 29700,
        12600; 29730,0; 30600,12600; 30630,0; 31500,12600; 31530,0; 32400,12600;
        32430,0; 34200,12600; 34230,0; 37800,12600; 37830,0; 41400,12600; 41430,
        0; 42300,12600; 42330,0; 45900,17181.82; 45966,0; 52200,12600; 52230,0;
        55800,12600; 55830,0; 59400,12600; 59430,0; 64800,12600; 64830,0; 65700,
        15750; 65724,0; 66600,15750; 66624,0; 68400,12600; 68430,0; 73800,17640;
        74010,0; 76500,12600; 76530,0; 77400,11506.85; 77838,0; 86400,0])
    annotation (Placement(transformation(extent={{-134,74},{-114,94}})));
  DataBase.DHW_ProfilM_Test dHW_ProfilM_Test(table=[3600,0; 25200,100; 25230,0;
        26100,100; 26538,0; 27000,100; 27030,0; 28860,100; 28890,0; 29700,100;
        29730,0; 30600,100; 30630,0; 31500,100; 31530,0; 32400,100; 32430,0;
        34200,100; 34230,0; 37800,100; 37830,0; 41400,100; 41430,0; 42300,100;
        42330,0; 45900,100; 45966,0; 52200,100; 52230,0; 55800,100; 55830,0;
        59400,100; 59430,0; 64800,100; 64830,0; 65700,100; 65724,0; 66600,100;
        66624,0; 68400,100; 68430,0; 73800,100; 74010,0; 76500,100; 76530,0;
        77400,100; 77838,0; 86400,0])
    annotation (Placement(transformation(extent={{-88,46},{-68,66}})));
  replaceable package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater
    constrainedby Modelica.Media.Interfaces.PartialMedium annotation (
      __Dymola_choicesAllMatching=true);
equation
  connect(Heatdemand.port_a, dhw_in) annotation (Line(points={{4,-42},{-52,-42},
          {-52,-100},{-104,-100}}, color={0,127,255}));
  connect(Heatdemand.port_b, dhw_out) annotation (Line(points={{24,-42},{56,-42},
          {56,-100},{104,-100}}, color={0,127,255}));
  connect(Heatdemand.Q_flow, Q_dhw) annotation (Line(points={{25,-36},{58,-36},
          {58,0},{110,0}}, color={0,0,127}));
  connect(dhw_OnOff, dhw_OnOff)
    annotation (Line(points={{110,94},{110,94}}, color={0,0,127}));
  connect(Q_flow_design_dhw.y, heatratio_calc1.dotQ_design) annotation (Line(
        points={{-75,24},{-58,24},{-58,28.8},{-40.48,28.8}}, color={0,0,127}));
  connect(heatratio_calc1.y_Heater, dhw_OnOff) annotation (Line(points={{-23.52,
          33},{38.24,33},{38.24,94},{110,94}}, color={0,0,127}));
  connect(heatratio_calc1.y_Heater, Heatdemand.u) annotation (Line(points={{
          -23.52,33},{-23.52,-1.5},{2,-1.5},{2,-36}}, color={0,0,127}));
  connect(dHW_ProfilM_Test.y[1], heatratio_calc1.dotQ_actual) annotation (Line(
        points={{-67,56},{-54,56},{-54,37.2},{-40.48,37.2}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          lineThickness=1,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-38,28},{-50,-8},{-50,-14},{-46,-18},{-42,-20},{-34,-20},{
              -26,-20},{-22,-18},{-20,-16},{-20,-10},{-22,-6},{-24,0},{-38,28}},
          lineColor={0,0,0},
          lineThickness=1,
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{40,38},{28,2},{28,-4},{32,-8},{36,-10},{44,-10},{52,-10},{56,
              -8},{58,-6},{58,0},{56,4},{54,10},{40,38}},
          lineColor={0,0,0},
          lineThickness=1,
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{2,-6},{-10,-42},{-10,-48},{-6,-52},{-2,-54},{6,-54},{14,-54},
              {18,-52},{20,-50},{20,-44},{18,-40},{16,-34},{2,-6}},
          lineColor={0,0,0},
          lineThickness=1,
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-2,66},{-14,30},{-14,24},{-10,20},{-6,18},{2,18},{10,18},{14,
              20},{16,22},{16,28},{14,32},{12,38},{-2,66}},
          lineColor={0,0,0},
          lineThickness=1,
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid)}), Diagram(coordinateSystem(
          preserveAspectRatio=false)));
end DHW;
