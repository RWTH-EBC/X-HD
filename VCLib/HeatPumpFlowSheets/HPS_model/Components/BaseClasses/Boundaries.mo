within VCLib.HeatPumpFlowSheets.HPS_model.Components.BaseClasses;
package Boundaries

  model Boundary_p "Pressure boundary, no enthapy, no massflow"
    outer HPS_model.Components.BaseClasses.BaseParameters.BaseParameters
      baseParameters "System properties";
    parameter Boolean use_p_in = false "Get the pressure from the input connector" annotation(Evaluate = true, HideResult = true, choices(__Dymola_checkBox = true));
    parameter Modelica.SIunits.Pressure p = 100000.0 "Fixed value of pressure" annotation(Evaluate = true, Dialog(enable = not use_p_in));
  protected
    Modelica.Blocks.Interfaces.RealInput p_in_internal;
  public
    HPS_model.Components.BaseClasses.Interfaces.Port_a port_a
      annotation (Placement(transformation(extent={{90,-10},{110,10}})));
    Modelica.Blocks.Interfaces.RealInput p_in if use_p_in annotation(Placement(transformation(extent = {{-140, 40}, {-100, 80}})));
  equation
    connect(p_in, p_in_internal);
    if not use_p_in then
      p_in_internal = p;
    end if;
    port_a.p = p_in_internal;
    port_a.h_outflow = 0;
    annotation(Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -100}, {100, 100}}), graphics), Icon(graphics={  Ellipse(extent = {{-100, 100}, {100, -100}}, lineColor = {0, 0, 255}, fillColor = {0, 0, 255},
              fillPattern = FillPattern.Sphere)}),
  Documentation(info = "<html>
<p>Defines prescribed value for pressure boundary condition.</p>
<p><h4><font color=\"#008000\">Lecture Information</font></h4></p>
<p>
Introduced in lecture: V02 - Rohrleitungen
</p>
</html>",
  revisions = "<html>
<p>01.11.2013, by <i>Ana Constantin</i>: implemented</p>
</html>"));
  end Boundary_p;

  model Boundary_h_mflow
    outer HPS_model.Components.BaseClasses.BaseParameters.BaseParameters
      baseParameters "System properties";
    parameter Boolean use_m_flow_in = false "Get the mass flow from the input connector" annotation (
      Evaluate = true,
      HideResult = true,
      choices(__Dymola_checkBox = true));
    parameter Boolean use_h_in = false "Get the specific enthalpy from the input connector" annotation (
      Evaluate = true,
      HideResult = true,
      choices(__Dymola_checkBox = true));
    parameter Modelica.SIunits.MassFlowRate m_flow = 0.1 "Fixed value of mass flow rate" annotation (
      Evaluate = true,
      Dialog(enable = not use_p_in));
    parameter Modelica.SIunits.SpecificEnthalpy h = 100000.0 "Fixed value of specific enthalpy" annotation (
      Evaluate = true,
      Dialog(enable = not use_h_in));
    HPS_model.Components.BaseClasses.Interfaces.Port_a port_a
      annotation (Placement(transformation(extent={{90,-10},{110,10}})));
    Modelica.Blocks.Interfaces.RealInput m_flow_in if use_m_flow_in annotation (
      Placement(transformation(extent = {{-140, 40}, {-100, 80}})));
    Modelica.Blocks.Interfaces.RealInput h_in if use_h_in annotation (
      Placement(transformation(extent = {{-140, -60}, {-100, -20}})));
  protected
    Modelica.Blocks.Interfaces.RealInput m_flow_in_internal "Needed to connect to conditional connector";
    Modelica.Blocks.Interfaces.RealInput h_in_internal "Needed to connect to conditional connector";
  equation
    connect(m_flow_in, m_flow_in_internal);
    connect(h_in, h_in_internal);
    if not use_m_flow_in then
      m_flow_in_internal = m_flow;
    end if;
    if not use_h_in then
      h_in_internal = h;
    end if;
    port_a.m_flow = -m_flow_in_internal;
    port_a.h_outflow = h_in_internal;
    annotation (
      Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -100}, {100, 100}}), graphics),
      Icon(graphics={  Ellipse(extent = {{-100, 100}, {100, -100}}, lineColor = {0, 0, 255}, fillColor = {0, 0, 255},
              fillPattern =                                                                                                         FillPattern.Sphere)}),
      Documentation(revisions = "<html>
<p>25.04.2019, by <i>Christoph Höges</i>: implemented</p>
</html>",   info = "<html>
<p><h4><font color=\"#008000\">Overview</font></h4></p>
<p>
Defines prescribed values for boundary conditions:
</p>
<ul>
<li> Prescribed boundary mass flow rate.</li>
<li> Prescribed boundary temperature.</li>
</ul>
<p><h4><font color=\"#008000\">Concept</font></h4></p>
<p>If <code>use_m_flow_in</code> is false (default option), the <code>m_flow</code> parameter
is used as boundary mass flow rate, and the <code>m_flow_in</code> input connector is disabled; if <code>use_m_flow_in</code> is true, then the <code>m_flow</code> parameter is ignored, and the value provided by the input connector is used instead.</p>
<p>The same thing goes for the specific enthalpy</p>
<p>
Note, that boundary temperature has only an effect if the mass flow
is from the boundary into the port. If mass is flowing from
the port into the boundary, the boundary definitions,
with exception of boundary pressure, do not have an effect.
</p>
</html>"));
  end Boundary_h_mflow;
end Boundaries;
