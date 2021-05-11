within VCLib.Components.Compressors.ModularPhysicalCompressors;
package Rotary "Package with detailed reciprocating compressor model"

    //VCLib.Media.Refrigerants.R32.R32_IIR_P1_70_T233_373_Horner;
    //VCLib.Media.Refrigerants.R744.R744_I0_P10_100_T233_373_Horner;
    //VCLib.Media.Refrigerants.R134a.R134a_IIR_P1_395_T233_455_Horner;
    //VCLib.Media.Refrigerants.R410A_HEoS.R410a_IIR_P1_48_T233_473_Horner;
    //VCLib.Media.Refrigerants.R290.R290_IIR_P05_30_T263_343_Horner;

    import Modelica.Units.SI.*;
    constant Real pi = Modelica.Constants.pi;
    constant Real small =  Modelica.Constants.small;
    import Modelica.Math.sin;
    import Modelica.Math.asin;
    import Modelica.Math.cos;


annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                Ellipse(
                  extent={{80,80},{-80,-80}},
                  lineColor={0,0,0},
                  startAngle=0,
                  endAngle=360,
                  fillPattern=FillPattern.Sphere,
                  fillColor={214,214,214}),
        Ellipse(
          extent={{-64,38},{16,-42}},
          lineColor={0,0,0},
          fillColor={230,230,230},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-44,28},{16,-32}},
          lineColor={0,0,0},
          fillColor={182,182,182},
          fillPattern=FillPattern.CrossDiag),
        Ellipse(
          extent={{-34,6},{-22,-6}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-30,40},{-26,20}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
                Line(
                  points={{74,30},{-58,54}},
                  color={0,0,0},
                  thickness=0.5),
                Line(
                  points={{74,-30},{-60,-52}},
                  color={0,0,0},
                  thickness=0.5)}),                            Diagram(
    coordinateSystem(preserveAspectRatio=false)));
end Rotary;
