within VCLib.Components.ExpansionValves.ExpansionValveModels.Distributed_parameter_models.Utilities.Types;
type Choice = enumeration(
    Bernoulli  " m_flow = C*A*sqrt(d_inlet*(pinl-pOut))",
    Bernoullip_th
               "m_flow = C*A*sqrt(d_inlet*(pInl-p_th))")
  "Enumeration to define calculation procedure of mass flow and pressure drop"
   annotation (Evaluate=true);
